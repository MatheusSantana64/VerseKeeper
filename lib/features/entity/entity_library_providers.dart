import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../../data/repositories/repository_providers.dart';

/// Reactive list of all non-deleted entities of [type], newest first.
final entityListProvider =
    StreamProvider.family<List<StoredEntity>, EntityType>(
  (ref, type) => _watchAll(ref, type),
);

/// Number of non-deleted entities of [type].
final entityCountProvider = FutureProvider.family<int, EntityType>(
  (ref, type) => _count(ref, type),
);

/// Identifies a single entity for reactive reads.
typedef EntityKey = ({EntityType type, String id});

/// Reactive single entity; emits `null` while missing or deleted.
final entityDetailProvider = StreamProvider.family<StoredEntity?, EntityKey>(
  (ref, key) => _watchById(ref, key.type, key.id),
);

Stream<List<StoredEntity>> _watchAll(Ref ref, EntityType type) => switch (type) {
      EntityType.character => ref.watch(characterRepositoryProvider).watchAll(),
      EntityType.characterVersion =>
        ref.watch(characterVersionRepositoryProvider).watchAll(),
      EntityType.story => ref.watch(storyRepositoryProvider).watchAll(),
      EntityType.universe => ref.watch(universeRepositoryProvider).watchAll(),
      EntityType.organization =>
        ref.watch(organizationRepositoryProvider).watchAll(),
      EntityType.location => ref.watch(locationRepositoryProvider).watchAll(),
      EntityType.item => ref.watch(itemRepositoryProvider).watchAll(),
      EntityType.species => ref.watch(speciesRepositoryProvider).watchAll(),
      EntityType.timelineEvent =>
        ref.watch(timelineEventRepositoryProvider).watchAll(),
      EntityType.fieldDefinition =>
        ref.watch(fieldDefinitionRepositoryProvider).watchAll(),
    };

Future<int> _count(Ref ref, EntityType type) => switch (type) {
      EntityType.character => ref.watch(characterRepositoryProvider).count(),
      EntityType.characterVersion =>
        ref.watch(characterVersionRepositoryProvider).count(),
      EntityType.story => ref.watch(storyRepositoryProvider).count(),
      EntityType.universe => ref.watch(universeRepositoryProvider).count(),
      EntityType.organization =>
        ref.watch(organizationRepositoryProvider).count(),
      EntityType.location => ref.watch(locationRepositoryProvider).count(),
      EntityType.item => ref.watch(itemRepositoryProvider).count(),
      EntityType.species => ref.watch(speciesRepositoryProvider).count(),
      EntityType.timelineEvent =>
        ref.watch(timelineEventRepositoryProvider).count(),
      EntityType.fieldDefinition =>
        ref.watch(fieldDefinitionRepositoryProvider).count(),
    };

Stream<StoredEntity?> _watchById(Ref ref, EntityType type, String id) =>
    switch (type) {
      EntityType.character =>
        ref.watch(characterRepositoryProvider).watchById(id),
      EntityType.characterVersion =>
        ref.watch(characterVersionRepositoryProvider).watchById(id),
      EntityType.story => ref.watch(storyRepositoryProvider).watchById(id),
      EntityType.universe => ref.watch(universeRepositoryProvider).watchById(id),
      EntityType.organization =>
        ref.watch(organizationRepositoryProvider).watchById(id),
      EntityType.location => ref.watch(locationRepositoryProvider).watchById(id),
      EntityType.item => ref.watch(itemRepositoryProvider).watchById(id),
      EntityType.species => ref.watch(speciesRepositoryProvider).watchById(id),
      EntityType.timelineEvent =>
        ref.watch(timelineEventRepositoryProvider).watchById(id),
      EntityType.fieldDefinition =>
        ref.watch(fieldDefinitionRepositoryProvider).watchById(id),
    };
