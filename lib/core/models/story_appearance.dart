import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_appearance.freezed.dart';
part 'story_appearance.g.dart';

/// A character's appearance inside a story.
///
/// Allows pinning which incarnation ([CharacterVersion]) of a character
/// appears in a given story, plus an optional in-story label/role.
@freezed
abstract class StoryAppearance with _$StoryAppearance {
  const factory StoryAppearance({
    required String characterId,

    /// Optional: the specific incarnation used in this story.
    String? versionId,

    /// Optional role/label within the story, e.g. "antagonist".
    String? role,
  }) = _StoryAppearance;

  factory StoryAppearance.fromJson(Map<String, dynamic> json) =>
      _$StoryAppearanceFromJson(json);
}
