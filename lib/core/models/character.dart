import 'package:freezed_annotation/freezed_annotation.dart';

import 'character_version.dart';
import 'relationship.dart';

part 'character.freezed.dart';
part 'character.g.dart';

/// The canonical identity of a character (e.g. "Haru").
///
/// A [Character] holds information that is stable across all of its
/// incarnations. Universe-specific details live in [CharacterVersion]s, which
/// inherit from and override this base.
///
/// Fields that are commonly per-version (personality, appearance, notes,
/// speech style, AI prompt) are nullable here because a base character may
/// leave them to its versions.
@freezed
abstract class Character with _$Character {
  const Character._();

  const factory Character({
    /// Stable unique identifier. Never changes after creation.
    required String id,

    /// Primary display name, e.g. "Haru".
    required String name,

    /// Alternate names / nicknames.
    @Default(<String>[]) List<String> aliases,

    /// User-assigned tags, used for filtering and search. Plaintext metadata.
    @Default(<String>[]) List<String> tags,

    /// Universes this character appears in (a character is reused across
    /// universes, unlike most other entities which belong to one).
    @Default(<String>[]) List<String> universeIds,

    /// Cover image file id (see the local image store).
    String? coverImageId,

    /// Additional gallery image file ids.
    @Default(<String>[]) List<String> imageIds,

    /// Stable core personality. Per-version details override via versions.
    String? personality,

    /// Stable core appearance.
    String? appearance,

    /// Free-form notes about the character.
    String? notes,

    /// How the character tends to speak.
    String? speechStyle,

    /// Prompt template used when generating this character with AI.
    String? aiPrompt,

    /// Stories this character appears in (denormalized convenience list).
    @Default(<String>[]) List<String> storyIds,

    /// All versions (incarnations) of this character.
    @Default(<String>[]) List<String> versionIds,

    /// Relationships from this character to others. See [Relationship].
    @Default(<Relationship>[]) List<Relationship> relationships,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  /// Resolves this character with a [version]'s overrides applied.
  ///
  /// Fields explicitly set on the version win; `null` version fields inherit
  /// from the base character. Returns a fully populated snapshot that is safe
  /// to render. The returned object keeps this character's id/name and the
  /// version's id for display purposes.
  CharacterVersion resolve(CharacterVersion version) {
    return CharacterVersion(
      id: version.id,
      characterId: id,
      universeId: version.universeId,
      name: version.name,
      coverImageId: version.coverImageId ?? coverImageId,
      imageIds: version.imageIds.isNotEmpty ? version.imageIds : imageIds,
      personality: version.personality ?? personality,
      appearance: version.appearance ?? appearance,
      notes: version.notes ?? notes,
      speechStyle: version.speechStyle ?? speechStyle,
      aiPrompt: version.aiPrompt ?? aiPrompt,
      tags: version.tags.isNotEmpty ? version.tags : tags,
      storyIds: version.storyIds.isNotEmpty ? version.storyIds : storyIds,
      relationships:
          version.relationships.isNotEmpty ? version.relationships : relationships,
      createdAt: version.createdAt,
      updatedAt: version.updatedAt,
    );
  }
}
