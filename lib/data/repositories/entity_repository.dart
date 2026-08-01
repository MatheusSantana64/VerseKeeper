import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../local/entities_dao.dart';

/// Persistence contract for a single entity type.
///
/// Features depend on this interface (via a Riverpod provider) and never talk
/// to drift or SQL directly. This is deliberately sync-agnostic: when the sync
/// engine lands, it will be wired *behind* this interface (e.g. local write +
/// outbox enqueue) without changing feature code.
///
/// Implementations:
///  * [LocalEntityRepository] — backed by the local drift database.
abstract interface class EntityRepository<T extends StoredEntity> {
  /// Reactive list of non-deleted entities, newest first.
  Stream<List<T>> watchAll();

  /// Reactive single entity; emits `null` while missing or deleted.
  Stream<T?> watchById(String id);

  /// One-shot read of a single non-deleted entity, or `null`.
  Future<T?> getById(String id);

  /// Inserts or replaces [entity]. The entity is persisted exactly as given;
  /// callers own id/timestamps (e.g. stamp `createdAt`/`updatedAt` before
  /// calling).
  Future<void> save(T entity);

  /// Soft-deletes the entity (tombstone) so the future sync engine can
  /// propagate the removal.
  Future<void> delete(String id);

  /// Number of non-deleted entities.
  Future<int> count();
}

/// Local-database backed [EntityRepository] for one [EntityType].
class LocalEntityRepository<T extends StoredEntity>
    implements EntityRepository<T> {
  LocalEntityRepository(this._dao, this._type);

  final EntitiesDao _dao;
  final EntityType _type;

  @override
  Stream<List<T>> watchAll() => _dao.watchAll<T>(_type);

  @override
  Stream<T?> watchById(String id) => _dao.watchById<T>(_type, id);

  @override
  Future<T?> getById(String id) => _dao.getById<T>(_type, id);

  @override
  Future<void> save(T entity) => _dao.upsert(entity);

  @override
  Future<void> delete(String id) => _dao.softDelete(_type, id);

  @override
  Future<int> count() => _dao.count(_type);
}
