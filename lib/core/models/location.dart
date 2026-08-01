import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity_type.dart';
import 'stored_entity.dart';

part 'location.freezed.dart';
part 'location.g.dart';

/// A place or location within a universe.
@freezed
abstract class Location with _$Location implements StoredEntity {
  const Location._();

  const factory Location({
    required String id,
    required String name,
    String? universeId,
    String? type,
    String? description,
    String? notes,
    String? coverImageId,
    @Default(<String>[]) List<String> imageIds,
    @Default(<String>[]) List<String> tags,
    String? parentLocationId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  @override
  EntityType get entityType => EntityType.location;
}
