import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/character.dart';
import '../../core/models/character_version.dart';
import '../../core/models/entity_type.dart';
import '../../core/models/item.dart';
import '../../core/models/location.dart';
import '../../core/models/organization.dart';
import '../../core/models/species.dart';
import '../../core/models/story.dart';
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
  }
}

/// Soft-deletes the entity with [id] through its typed repository provider.
Future<void> deleteEntity(WidgetRef ref, EntityType type, String id) async {
  switch (type) {
    case EntityType.character:
      await ref.read(characterRepositoryProvider).delete(id);
    case EntityType.characterVersion:
      await ref.read(characterVersionRepositoryProvider).delete(id);
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
  }
}
