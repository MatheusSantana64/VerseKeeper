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
import 'entity_codec.dart';

class CharacterCodec extends BaseEntityCodec<Character> {
  const CharacterCodec();

  @override
  EntityType get type => EntityType.character;

  @override
  Character fromJson(Map<String, dynamic> json) => Character.fromJson(json);

  @override
  String nameOf(Character e) => e.name;

  @override
  String searchTextOf(Character e) => joinText([
        e.name,
        ...e.aliases,
        ...e.tags,
        e.personality,
        e.appearance,
        e.notes,
        e.speechStyle,
        e.aiPrompt,
      ]);
}

class CharacterVersionCodec extends BaseEntityCodec<CharacterVersion> {
  const CharacterVersionCodec();

  @override
  EntityType get type => EntityType.characterVersion;

  @override
  CharacterVersion fromJson(Map<String, dynamic> json) =>
      CharacterVersion.fromJson(json);

  @override
  String nameOf(CharacterVersion e) => e.name;

  @override
  String searchTextOf(CharacterVersion e) => joinText([
        e.name,
        ...e.tags,
        e.personality,
        e.appearance,
        e.notes,
        e.speechStyle,
        e.aiPrompt,
      ]);
}

class UniverseCodec extends BaseEntityCodec<Universe> {
  const UniverseCodec();

  @override
  EntityType get type => EntityType.universe;

  @override
  Universe fromJson(Map<String, dynamic> json) => Universe.fromJson(json);

  @override
  String nameOf(Universe e) => e.name;

  @override
  String searchTextOf(Universe e) =>
      joinText([e.name, e.description, e.notes, ...e.tags]);
}

class StoryCodec extends BaseEntityCodec<Story> {
  const StoryCodec();

  @override
  EntityType get type => EntityType.story;

  @override
  Story fromJson(Map<String, dynamic> json) => Story.fromJson(json);

  @override
  String nameOf(Story e) => e.title;

  @override
  String searchTextOf(Story e) =>
      joinText([e.title, e.summary, e.notes, ...e.tags, ...e.genres]);
}

class OrganizationCodec extends BaseEntityCodec<Organization> {
  const OrganizationCodec();

  @override
  EntityType get type => EntityType.organization;

  @override
  Organization fromJson(Map<String, dynamic> json) =>
      Organization.fromJson(json);

  @override
  String nameOf(Organization e) => e.name;

  @override
  String searchTextOf(Organization e) =>
      joinText([e.name, e.description, e.notes, ...e.tags]);
}

class LocationCodec extends BaseEntityCodec<Location> {
  const LocationCodec();

  @override
  EntityType get type => EntityType.location;

  @override
  Location fromJson(Map<String, dynamic> json) => Location.fromJson(json);

  @override
  String nameOf(Location e) => e.name;

  @override
  String searchTextOf(Location e) =>
      joinText([e.name, e.type, e.description, e.notes, ...e.tags]);
}

class ItemCodec extends BaseEntityCodec<Item> {
  const ItemCodec();

  @override
  EntityType get type => EntityType.item;

  @override
  Item fromJson(Map<String, dynamic> json) => Item.fromJson(json);

  @override
  String nameOf(Item e) => e.name;

  @override
  String searchTextOf(Item e) =>
      joinText([e.name, e.type, e.description, e.notes, ...e.tags]);
}

class SpeciesCodec extends BaseEntityCodec<Species> {
  const SpeciesCodec();

  @override
  EntityType get type => EntityType.species;

  @override
  Species fromJson(Map<String, dynamic> json) => Species.fromJson(json);

  @override
  String nameOf(Species e) => e.name;

  @override
  String searchTextOf(Species e) =>
      joinText([e.name, e.description, e.notes, ...e.tags]);
}

class TimelineEventCodec extends BaseEntityCodec<TimelineEvent> {
  const TimelineEventCodec();

  @override
  EntityType get type => EntityType.timelineEvent;

  @override
  TimelineEvent fromJson(Map<String, dynamic> json) =>
      TimelineEvent.fromJson(json);

  @override
  String nameOf(TimelineEvent e) => e.title;

  @override
  String searchTextOf(TimelineEvent e) =>
      joinText([e.title, e.dateLabel, e.description, e.notes, ...e.tags]);
}

/// Registry mapping every persisted [EntityType] to its codec.
///
/// Adding a new entity type requires a new codec here and an entry in this
/// map (mirrors the collection-name entry in `EntityType.collectionName`).
final Map<EntityType, EntityCodec> entityCodecs = {
  EntityType.character: CharacterCodec(),
  EntityType.characterVersion: CharacterVersionCodec(),
  EntityType.universe: UniverseCodec(),
  EntityType.story: StoryCodec(),
  EntityType.organization: OrganizationCodec(),
  EntityType.location: LocationCodec(),
  EntityType.item: ItemCodec(),
  EntityType.species: SpeciesCodec(),
  EntityType.timelineEvent: TimelineEventCodec(),
};

/// Type-safe accessor for [entityCodecs].
EntityCodec<T> codecFor<T extends StoredEntity>(EntityType type) =>
    entityCodecs[type]! as EntityCodec<T>;
