import 'package:flutter/material.dart';

import '../../core/models/entity_type.dart';

/// Presentation metadata for a routable/browsable entity type.
class EntityTypeConfig {
  const EntityTypeConfig({
    required this.label,
    required this.singular,
    required this.icon,
  });

  /// Plural display label, e.g. "Characters".
  final String label;

  /// Singular display label, e.g. "Character".
  final String singular;

  /// Leading icon for lists, cards and drawer entries.
  final IconData icon;
}

const Map<EntityType, EntityTypeConfig> entityTypeConfigs = {
  EntityType.character: EntityTypeConfig(
    label: 'Characters',
    singular: 'Character',
    icon: Icons.person_outline,
  ),
  EntityType.characterVersion: EntityTypeConfig(
    label: 'Versions',
    singular: 'Character version',
    icon: Icons.person_search_outlined,
  ),
  EntityType.story: EntityTypeConfig(
    label: 'Stories',
    singular: 'Story',
    icon: Icons.menu_book_outlined,
  ),
  EntityType.universe: EntityTypeConfig(
    label: 'Universes',
    singular: 'Universe',
    icon: Icons.public,
  ),
  EntityType.organization: EntityTypeConfig(
    label: 'Organizations',
    singular: 'Organization',
    icon: Icons.apartment_outlined,
  ),
  EntityType.location: EntityTypeConfig(
    label: 'Locations',
    singular: 'Location',
    icon: Icons.place_outlined,
  ),
  EntityType.item: EntityTypeConfig(
    label: 'Items',
    singular: 'Item',
    icon: Icons.category_outlined,
  ),
  EntityType.species: EntityTypeConfig(
    label: 'Species',
    singular: 'Species',
    icon: Icons.pets_outlined,
  ),
  EntityType.timelineEvent: EntityTypeConfig(
    label: 'Timeline',
    singular: 'Timeline event',
    icon: Icons.schedule_outlined,
  ),
};

/// Types promoted to first-class navigation/dashboard destinations.
///
/// Character versions are managed from their owning character, so they stay
/// routable and searchable but are not surfaced in the drawer or dashboard.
const List<EntityType> primaryEntityTypes = [
  EntityType.character,
  EntityType.story,
  EntityType.universe,
  EntityType.organization,
  EntityType.location,
  EntityType.item,
  EntityType.species,
  EntityType.timelineEvent,
];

/// Presentation metadata for [type]. Every [EntityType] has a config entry.
EntityTypeConfig configOf(EntityType type) => entityTypeConfigs[type]!;
