import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity_type.dart';
import 'stored_entity.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// An organization, faction or group within a universe.
@freezed
abstract class Organization with _$Organization implements StoredEntity {
  const Organization._();

  const factory Organization({
    required String id,
    required String name,
    String? universeId,
    String? description,
    String? notes,
    String? coverImageId,
    @Default(<String>[]) List<String> imageIds,
    @Default(<String>[]) List<String> tags,

    /// Characters who are members of this organization.
    @Default(<String>[]) List<String> memberCharacterIds,

    /// Locations associated with this organization.
    @Default(<String>[]) List<String> locationIds,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  @override
  EntityType get entityType => EntityType.organization;
}
