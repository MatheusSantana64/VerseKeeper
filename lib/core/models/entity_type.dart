/// Identifies the concrete kind of a worldbuilding entity.
///
/// Used by the sync layer (each type maps to its own Firestore collection),
/// the search index, and by repositories that need to treat entities
/// generically. Adding a new entity type means adding an enum value here and
/// registering a serialization/sync handler for it.
enum EntityType {
  character,
  characterVersion,
  story,
  universe,
  organization,
  location,
  item,
  species,
  timelineEvent;

  /// The name of the Firestore collection backing this entity type.
  ///
  /// Collection names are plural and immutable once deployed, so keep this
  /// stable even if the enum value is renamed.
  String get collectionName => switch (this) {
        EntityType.character => 'characters',
        EntityType.characterVersion => 'character_versions',
        EntityType.story => 'stories',
        EntityType.universe => 'universes',
        EntityType.organization => 'organizations',
        EntityType.location => 'locations',
        EntityType.item => 'items',
        EntityType.species => 'species',
        EntityType.timelineEvent => 'timeline_events',
      };
}
