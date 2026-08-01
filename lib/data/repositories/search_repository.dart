import '../../core/models/stored_entity.dart';
import '../local/entities_dao.dart';

/// Cross-entity full-text search.
///
/// Separated from [EntityRepository] because search spans all entity types
/// rather than one.
abstract interface class SearchRepository {
  /// One-shot ranked search across all entity types.
  Future<List<StoredEntity>> search(String query);

  /// Reactive search: re-emits when the query changes or local data changes.
  Stream<List<StoredEntity>> watchSearch(String query);
}

/// FTS5-backed [SearchRepository] over the local database.
class LocalSearchRepository implements SearchRepository {
  LocalSearchRepository(this._dao);

  final EntitiesDao _dao;

  @override
  Future<List<StoredEntity>> search(String query) => _dao.search(query);

  @override
  Stream<List<StoredEntity>> watchSearch(String query) =>
      _dao.watchSearch(query);
}
