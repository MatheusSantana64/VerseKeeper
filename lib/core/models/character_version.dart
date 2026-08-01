import 'package:freezed_annotation/freezed_annotation.dart';

import 'relationship.dart';

part 'character_version.freezed.dart';
part 'character_version.g.dart';

/// A single incarnation of a [Character] within a specific context (usually a
/// universe), e.g. "Haru (Princess)" vs "Haru (FBI Agent)".
///
/// To avoid duplicating the base character's data, every version follows an
/// *inherit + override* rule: a `null` value (or empty list) for an inherited
/// field means "use the base character's value". Only fields that actually
/// differ for this incarnation should be populated.
@freezed
abstract class CharacterVersion with _$CharacterVersion {
  const CharacterVersion._();

  const factory CharacterVersion({
    /// Stable unique identifier.
    required String id,

    /// Id of the base character this version belongs to.
    required String characterId,

    /// Id of the universe this incarnation lives in, if any.
    String? universeId,

    /// Incarnation name, e.g. "Princess" or "FBI Agent".
    required String name,

    /// Display avatar for this incarnation.
    String? coverImageId,

    /// Gallery images specific to this incarnation (empty = inherit).
    @Default(<String>[]) List<String> imageIds,

    /// `null` = inherit from the base character.
    String? personality,

    /// `null` = inherit from the base character.
    String? appearance,

    /// `null` = inherit from the base character.
    String? notes,

    /// `null` = inherit from the base character.
    String? speechStyle,

    /// `null` = inherit from the base character.
    String? aiPrompt,

    /// Tags specific to this incarnation (empty = inherit).
    @Default(<String>[]) List<String> tags,

    /// Stories this incarnation specifically appears in.
    @Default(<String>[]) List<String> storyIds,

    /// Relationships specific to this incarnation.
    @Default(<Relationship>[]) List<Relationship> relationships,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CharacterVersion;

  factory CharacterVersion.fromJson(Map<String, dynamic> json) =>
      _$CharacterVersionFromJson(json);
}
