import 'package:freezed_annotation/freezed_annotation.dart';

import 'story_appearance.dart';

part 'story.freezed.dart';
part 'story.g.dart';

/// A story (or story fragment) set in a universe.
///
/// Characters appear in a story through [StoryAppearance], which optionally
/// pins a specific character version/incarnation.
@freezed
abstract class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    String? universeId,
    String? summary,
    String? notes,
    String? coverImageId,
    @Default(<String>[]) List<String> imageIds,
    @Default(<String>[]) List<String> tags,

    /// Genre/hardcoded tone hints, e.g. "romance", "dark fantasy".
    @Default(<String>[]) List<String> genres,

    /// Free form publication/status label (draft, finished, ...).
    String? status,

    /// The characters (and optionally which incarnation) that appear.
    @Default(<StoryAppearance>[]) List<StoryAppearance> appearances,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
