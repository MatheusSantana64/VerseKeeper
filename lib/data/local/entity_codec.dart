import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';

/// Knows how to (de)serialize one [EntityType] to/from its persisted JSON
/// shape, plus derive the denormalized display name and searchable text used
/// by the local database.
///
/// One implementation per entity type; see [entityCodecs] for the registry.
abstract interface class EntityCodec<T extends StoredEntity> {
  /// The entity type this codec handles.
  EntityType get type;

  /// Rebuilds a domain model from its stored JSON.
  T fromJson(Map<String, dynamic> json);

  /// Human readable name for list previews (e.g. `Character.name` or
  /// `Story.title`). Denormalized into the `entities` table.
  String nameOf(T entity);

  /// Concatenated plaintext used for the FTS5 search index. Only fields the
  /// user would expect to search should be included.
  String searchTextOf(T entity);
}

/// Convenience base class with shared helpers for the concrete codecs.
abstract class BaseEntityCodec<T extends StoredEntity>
    implements EntityCodec<T> {
  const BaseEntityCodec();

  /// Joins searchable parts, dropping `null`/empty values.
  String joinText(Iterable<Object?> parts) => parts
      .where((p) => p != null && p.toString().isNotEmpty)
      .map((p) => p.toString())
      .join(' ');
}
