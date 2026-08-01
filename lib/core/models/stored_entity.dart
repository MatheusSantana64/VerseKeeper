import 'entity_type.dart';

/// Contract implemented by every top-level, persistable entity.
///
/// Lets the local storage and sync layers work with any entity through a
/// common shape (id, timestamps, type, JSON) without knowing the concrete
/// model class.
abstract interface class StoredEntity {
  String get id;

  DateTime get createdAt;

  DateTime get updatedAt;

  /// Which [EntityType] this entity is. Used by the storage/sync layers to
  /// find the matching codec and collection.
  EntityType get entityType;

  /// Full JSON representation of the entity (freezed/json_serializable).
  Map<String, dynamic> toJson();
}
