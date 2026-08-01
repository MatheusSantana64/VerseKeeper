import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/character.dart';
import '../../core/models/character_version.dart';
import '../../core/models/entity_type.dart';
import '../../core/models/field_definition.dart';
import '../../core/models/item.dart';
import '../../core/models/location.dart';
import '../../core/models/organization.dart';
import '../../core/models/species.dart';
import '../../core/models/story.dart';
import '../../core/models/story_appearance.dart';
import '../../core/models/stored_entity.dart';
import '../../core/models/timeline_event.dart';
import '../../core/models/universe.dart';
import '../../data/repositories/repository_providers.dart';

/// Rebuilds a typed model from its JSON. Unlike the local codecs this lives in
/// features, so screens can stay on the repository layer while still building
/// concrete models to save.
StoredEntity entityFromJson(EntityType type, Map<String, dynamic> json) =>
    switch (type) {
      EntityType.character => Character.fromJson(json),
      EntityType.characterVersion => CharacterVersion.fromJson(json),
      EntityType.story => Story.fromJson(json),
      EntityType.universe => Universe.fromJson(json),
      EntityType.organization => Organization.fromJson(json),
      EntityType.location => Location.fromJson(json),
      EntityType.item => Item.fromJson(json),
      EntityType.species => Species.fromJson(json),
      EntityType.timelineEvent => TimelineEvent.fromJson(json),
      EntityType.fieldDefinition => FieldDefinition.fromJson(json),
    };

/// Saves [entity] through its typed repository provider.
Future<void> saveEntity(WidgetRef ref, StoredEntity entity) async {
  switch (entity.entityType) {
    case EntityType.character:
      await ref.read(characterRepositoryProvider).save(entity as Character);
    case EntityType.characterVersion:
      await ref
          .read(characterVersionRepositoryProvider)
          .save(entity as CharacterVersion);
    case EntityType.story:
      await ref.read(storyRepositoryProvider).save(entity as Story);
    case EntityType.universe:
      await ref.read(universeRepositoryProvider).save(entity as Universe);
    case EntityType.organization:
      await ref.read(organizationRepositoryProvider).save(entity as Organization);
    case EntityType.location:
      await ref.read(locationRepositoryProvider).save(entity as Location);
    case EntityType.item:
      await ref.read(itemRepositoryProvider).save(entity as Item);
    case EntityType.species:
      await ref.read(speciesRepositoryProvider).save(entity as Species);
    case EntityType.timelineEvent:
      await ref.read(timelineEventRepositoryProvider).save(entity as TimelineEvent);
    case EntityType.fieldDefinition:
      await ref
          .read(fieldDefinitionRepositoryProvider)
          .save(entity as FieldDefinition);
  }
}

/// Soft-deletes the entity with [id] through its typed repository provider.
Future<void> deleteEntity(WidgetRef ref, EntityType type, String id) async {
  switch (type) {
    case EntityType.character:
      await ref.read(characterRepositoryProvider).delete(id);
      await _cascadeDeleteCharacter(ref, id);
    case EntityType.characterVersion:
      await ref.read(characterVersionRepositoryProvider).delete(id);
      await _stripVersionFromAppearances(ref, id);
    case EntityType.story:
      await ref.read(storyRepositoryProvider).delete(id);
    case EntityType.universe:
      await ref.read(universeRepositoryProvider).delete(id);
    case EntityType.organization:
      await ref.read(organizationRepositoryProvider).delete(id);
    case EntityType.location:
      await ref.read(locationRepositoryProvider).delete(id);
    case EntityType.item:
      await ref.read(itemRepositoryProvider).delete(id);
    case EntityType.species:
      await ref.read(speciesRepositoryProvider).delete(id);
    case EntityType.timelineEvent:
      await ref.read(timelineEventRepositoryProvider).delete(id);
    case EntityType.fieldDefinition:
      await ref.read(fieldDefinitionRepositoryProvider).delete(id);
      await _stripCustomFieldFromCharacters(ref, id);
  }
}

/// Deletes a character's versions and strips every reference to it from other
/// characters and stories so no dangling ids survive.
Future<void> _cascadeDeleteCharacter(
  WidgetRef ref,
  String characterId,
) async {
  final now = DateTime.now().toUtc();

  final versionRepository = ref.read(characterVersionRepositoryProvider);
  for (final version in await versionRepository.getAll()) {
    if (version.characterId == characterId) {
      await versionRepository.delete(version.id);
    }
  }

  final characterRepository = ref.read(characterRepositoryProvider);
  for (final character in await characterRepository.getAll()) {
    final kept = character.relationships
        .where((relationship) => relationship.otherCharacterId != characterId)
        .toList();
    if (kept.length == character.relationships.length) continue;
    await characterRepository.save(
      character.copyWith(relationships: kept, updatedAt: now),
    );
  }

  final storyRepository = ref.read(storyRepositoryProvider);
  for (final story in await storyRepository.getAll()) {
    final kept = story.appearances
        .where((appearance) => appearance.characterId != characterId)
        .toList();
    if (kept.length == story.appearances.length) continue;
    await storyRepository.save(
      story.copyWith(appearances: kept, updatedAt: now),
    );
  }
}

/// Detaches a deleted version from every story appearance that pinned it, so
/// the appearance falls back to the base character.
Future<void> _stripVersionFromAppearances(
  WidgetRef ref,
  String versionId,
) async {
  final now = DateTime.now().toUtc();
  final storyRepository = ref.read(storyRepositoryProvider);
  for (final story in await storyRepository.getAll()) {
    final appearances = <StoryAppearance>[];
    var changed = false;
    for (final appearance in story.appearances) {
      if (appearance.versionId == versionId) {
        changed = true;
        appearances.add(appearance.copyWith(versionId: null));
      } else {
        appearances.add(appearance);
      }
    }
    if (!changed) continue;
    await storyRepository.save(
      story.copyWith(appearances: appearances, updatedAt: now),
    );
  }
}

/// Removes [definitionId] from every character's `customFields` so no orphaned
/// values survive the deletion of their defining field.
Future<void> _stripCustomFieldFromCharacters(
  WidgetRef ref,
  String definitionId,
) async {
  final repository = ref.read(characterRepositoryProvider);
  final characters = await repository.getAll();
  final now = DateTime.now().toUtc();
  for (final character in characters) {
    if (!character.customFields.containsKey(definitionId)) continue;
    final customFields = Map<String, String>.of(character.customFields)
      ..remove(definitionId);
    await repository.save(
      character.copyWith(customFields: customFields, updatedAt: now),
    );
  }
}
