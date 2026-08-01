import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/character.dart';
import '../../core/models/character_version.dart';
import '../../core/models/entity_type.dart';
import '../../core/models/item.dart';
import '../../core/models/location.dart';
import '../../core/models/organization.dart';
import '../../core/models/species.dart';
import '../../core/models/story.dart';
import '../../core/models/timeline_event.dart';
import '../../core/models/universe.dart';
import '../local/local_providers.dart';
import 'entity_repository.dart';
import 'search_repository.dart';

/// Typed repository for each persisted entity type. Features depend on these,
/// never on the DAO.
final characterRepositoryProvider =
    Provider<EntityRepository<Character>>((ref) {
  return LocalEntityRepository<Character>(
    ref.watch(entitiesDaoProvider),
    EntityType.character,
  );
});

final characterVersionRepositoryProvider =
    Provider<EntityRepository<CharacterVersion>>((ref) {
  return LocalEntityRepository<CharacterVersion>(
    ref.watch(entitiesDaoProvider),
    EntityType.characterVersion,
  );
});

final universeRepositoryProvider = Provider<EntityRepository<Universe>>((ref) {
  return LocalEntityRepository<Universe>(
    ref.watch(entitiesDaoProvider),
    EntityType.universe,
  );
});

final storyRepositoryProvider = Provider<EntityRepository<Story>>((ref) {
  return LocalEntityRepository<Story>(
    ref.watch(entitiesDaoProvider),
    EntityType.story,
  );
});

final organizationRepositoryProvider =
    Provider<EntityRepository<Organization>>((ref) {
  return LocalEntityRepository<Organization>(
    ref.watch(entitiesDaoProvider),
    EntityType.organization,
  );
});

final locationRepositoryProvider = Provider<EntityRepository<Location>>((ref) {
  return LocalEntityRepository<Location>(
    ref.watch(entitiesDaoProvider),
    EntityType.location,
  );
});

final itemRepositoryProvider = Provider<EntityRepository<Item>>((ref) {
  return LocalEntityRepository<Item>(
    ref.watch(entitiesDaoProvider),
    EntityType.item,
  );
});

final speciesRepositoryProvider = Provider<EntityRepository<Species>>((ref) {
  return LocalEntityRepository<Species>(
    ref.watch(entitiesDaoProvider),
    EntityType.species,
  );
});

final timelineEventRepositoryProvider =
    Provider<EntityRepository<TimelineEvent>>((ref) {
  return LocalEntityRepository<TimelineEvent>(
    ref.watch(entitiesDaoProvider),
    EntityType.timelineEvent,
  );
});

/// Cross-entity full-text search.
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return LocalSearchRepository(ref.watch(entitiesDaoProvider));
});
