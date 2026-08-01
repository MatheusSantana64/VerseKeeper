import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// A single row in the document-store `entities` table.
///
/// Every persisted entity lives here as:
///  * `data`   — the full entity JSON (produced by the model codecs),
///  * `type`   — the entity type, stored as its enum *name* (reorder-safe),
///  * `name`   — denormalized display name for list previews/filtering,
///  * `updatedAt` / `createdAt` — timestamps (also used by sync),
///  * `deleted` — soft-delete tombstone so sync can propagate removals.
///
/// Whole-document semantics intentionally match Firestore: an upsert replaces
/// the entire document, and sync is last-write-wins per entity.
class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get data => text()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'CHECK (length(type) > 0)',
      ];
}

/// The local SQLite database (drift).
///
/// App (Windows/Android) connection comes from `driftDatabase`, which picks
/// `getApplicationDocumentsDirectory()/versekeeper.sqlite` and bundles the
/// native sqlite3 library. Tests construct the database with an in-memory
/// [NativeDatabase].
@DriftDatabase(tables: [Entities])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory database for tests. Requires a native sqlite3 library, which
  /// `package:sqlite3` (v3) bundles via Dart native assets.
  AppDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(_createSearchIndex);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// FTS5 virtual table powering full-text search over the searchable
  /// plaintext of every entity. Drift has no FTS5 DSL, so it is created and
  /// maintained with raw SQL from the DAO.
  static const String entitySearchTable = 'entity_search';

  static const String _createSearchIndex = '''
CREATE VIRTUAL TABLE IF NOT EXISTS $entitySearchTable USING fts5(
  content,
  entityId UNINDEXED,
  type UNINDEXED,
  tokenize = 'unicode61'
)''';

  static QueryExecutor _openConnection() => driftDatabase(name: 'versekeeper');
}
