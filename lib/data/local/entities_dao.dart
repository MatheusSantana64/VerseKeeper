import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import 'app_database.dart';
import 'entity_codec.dart';
import 'entity_codecs.dart';

part 'entities_dao.g.dart';

/// Generic persistence + full-text search over the document-store
/// [Entities] table.
///
/// Works with any [StoredEntity] through its codec, so repositories never
/// talk to SQL directly. All mutations write both the entity row and the FTS5
/// search index entry in one transaction.
@DriftAccessor(tables: [Entities])
class EntitiesDao extends DatabaseAccessor<AppDatabase> with _$EntitiesDaoMixin {
  EntitiesDao(super.attachedDatabase);

  /// Inserts or replaces [entity], then re-indexes it for search.
  Future<void> upsert<T extends StoredEntity>(T entity) async {
    await transaction(() async {
      final codec = codecFor<T>(entity.entityType);
      await into(entities).insertOnConflictUpdate(EntitiesCompanion.insert(
        id: entity.id,
        type: entity.entityType.name,
        data: jsonEncode(entity.toJson()),
        name: Value(codec.nameOf(entity)),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ));
      await _indexForSearch(entity.id, entity.entityType, codec.searchTextOf(entity));
    });
  }

  /// Soft-deletes an entity (tombstone for sync) and removes it from search.
  Future<void> softDelete(EntityType type, String id) async {
    await transaction(() async {
      await (update(entities)..where((e) => e.id.equals(id)))
          .write(EntitiesCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ));
      await customStatement(
        'DELETE FROM ${AppDatabase.entitySearchTable} WHERE entityId = ?',
        [id],
      );
    });
  }

  /// Permanently removes an entity (used after its deletion has synced).
  Future<void> hardDelete(EntityType type, String id) async {
    await transaction(() async {
      await (delete(entities)..where((e) => e.id.equals(id))).go();
      await customStatement(
        'DELETE FROM ${AppDatabase.entitySearchTable} WHERE entityId = ?',
        [id],
      );
    });
  }

  /// Single non-deleted entity by id, or `null`.
  Future<T?> getById<T extends StoredEntity>(EntityType type, String id) async {
    final row = await (select(entities)
          ..where((e) => e.id.equals(id) & e.deleted.equals(false)))
        .getSingleOrNull();
    return row == null ? null : _decode<T>(type, row);
  }

  /// Reactive list of non-deleted entities, newest first.
  Stream<List<T>> watchAll<T extends StoredEntity>(EntityType type) {
    final codec = codecFor<T>(type);
    final query = (select(entities)
          ..where((e) => e.type.equals(type.name) & e.deleted.equals(false))
          ..orderBy([(e) => OrderingTerm.desc(e.updatedAt)]))
        .watch();
    return query.map((rows) => rows.map((r) => _decode<T>(type, r, codec)).toList());
  }

  /// One-shot snapshot of all non-deleted entity ids (used by sync to detect
  /// what exists locally).
  Future<List<String>> allIds(EntityType type) async {
    final rows = await (select(entities)
          ..where((e) => e.type.equals(type.name) & e.deleted.equals(false)))
        .get();
    return rows.map((r) => r.id).toList();
  }

  /// Count of non-deleted entities of [type].
  Future<int> count(EntityType type) async {
    final query = select(entities)
      ..where((e) => e.type.equals(type.name) & e.deleted.equals(false));
    return query.get().then((rows) => rows.length);
  }

  /// Full-text search across all entity types.
  ///
  /// Performs an FTS5 `MATCH` with AND-combined prefix terms (so "har prin"
  /// matches "Haru, Princess"). Results are ranked by FTS5 relevance and
  /// exclude soft-deleted entities. Returns an empty list for a blank query.
  Future<List<StoredEntity>> search(String rawQuery) async {
    final ftsQuery = _toFtsQuery(rawQuery);
    if (ftsQuery.isEmpty) return const [];

    final rows = await customSelect(
      '''
      SELECT e.data, e.type
      FROM ${AppDatabase.entitySearchTable}
      JOIN entities AS e ON e.id = ${AppDatabase.entitySearchTable}.entityId
        AND e.type = ${AppDatabase.entitySearchTable}.type
      WHERE ${AppDatabase.entitySearchTable} MATCH ?
        AND e.deleted = 0
      ORDER BY ${AppDatabase.entitySearchTable}.rank
      ''',
      variables: [Variable(ftsQuery)],
    ).get();

    return rows.map((row) {
      final type = EntityType.values.byName(row.read<String>('type'));
      final data = jsonDecode(row.read<String>('data')) as Map<String, dynamic>;
      return codecFor<StoredEntity>(type).fromJson(data);
    }).toList();
  }

  /// Reactive version of [search]: re-emits when the `entities` table changes
  /// or the query is updated.
  Stream<List<StoredEntity>> watchSearch(String rawQuery) {
    final ftsQuery = _toFtsQuery(rawQuery);
    if (ftsQuery.isEmpty) {
      return Stream.value(const []);
    }
    return customSelect(
      '''
      SELECT e.data, e.type
      FROM ${AppDatabase.entitySearchTable}
      JOIN entities AS e ON e.id = ${AppDatabase.entitySearchTable}.entityId
        AND e.type = ${AppDatabase.entitySearchTable}.type
      WHERE ${AppDatabase.entitySearchTable} MATCH ?
        AND e.deleted = 0
      ORDER BY ${AppDatabase.entitySearchTable}.rank
      ''',
      variables: [Variable(ftsQuery)],
    ).watch().map((rows) => rows.map((row) {
          final type = EntityType.values.byName(row.read<String>('type'));
          final data =
              jsonDecode(row.read<String>('data')) as Map<String, dynamic>;
          return codecFor<StoredEntity>(type).fromJson(data);
        }).toList());
  }

  // --------------------------------------------------------------------------
  // Internals
  // --------------------------------------------------------------------------

  T _decode<T extends StoredEntity>(EntityType type, Entity row,
      [EntityCodec<T>? codec]) {
    final data = jsonDecode(row.data) as Map<String, dynamic>;
    return (codec ?? codecFor<T>(type)).fromJson(data);
  }

  Future<void> _indexForSearch(
      String id, EntityType type, String content) async {
    await customStatement(
      'DELETE FROM ${AppDatabase.entitySearchTable} WHERE entityId = ?',
      [id],
    );
    if (content.trim().isEmpty) return;
    await customStatement(
      'INSERT INTO ${AppDatabase.entitySearchTable}(content, entityId, type) '
      'VALUES (?, ?, ?)',
      [content, id, type.name],
    );
  }

  /// Turns user input into a safe FTS5 MATCH expression.
  ///
  /// Each word becomes a prefix term (`foo*`), words are AND-combined, and
  /// punctuation/operators are stripped so the user cannot inject FTS query
  /// syntax.
  String _toFtsQuery(String raw) {
    final words = raw
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'[^\p{L}\p{N}_]', unicode: true), ''))
        .where((w) => w.isNotEmpty)
        .map((w) => '$w*')
        .toList();
    return words.join(' ');
  }
}
