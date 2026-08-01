import 'package:freezed_annotation/freezed_annotation.dart';

part 'universe.freezed.dart';
part 'universe.g.dart';

/// A fictional universe/world that contains stories, characters, locations,
/// organizations, items, species and timeline events.
///
/// Most entities belong to exactly one universe via a `universeId` reference.
/// Characters are the exception: they are global and can appear in many
/// universes through their versions.
@freezed
abstract class Universe with _$Universe {
  const factory Universe({
    required String id,
    required String name,
    String? description,
    String? notes,
    String? coverImageId,
    @Default(<String>[]) List<String> imageIds,
    @Default(<String>[]) List<String> tags,

    /// Convenience reference lists for browsing. These are denormalized;
    /// the referenced entities remain the source of truth.
    @Default(<String>[]) List<String> characterIds,
    @Default(<String>[]) List<String> storyIds,
    @Default(<String>[]) List<String> locationIds,
    @Default(<String>[]) List<String> organizationIds,
    @Default(<String>[]) List<String> itemIds,
    @Default(<String>[]) List<String> speciesIds,
    @Default(<String>[]) List<String> timelineEventIds,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Universe;

  factory Universe.fromJson(Map<String, dynamic> json) =>
      _$UniverseFromJson(json);
}
