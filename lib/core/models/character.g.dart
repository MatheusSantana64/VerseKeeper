// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Character _$CharacterFromJson(Map<String, dynamic> json) => _Character(
  id: json['id'] as String,
  name: json['name'] as String,
  profession: json['profession'] as String?,
  age: json['age'] as String?,
  race: json['race'] as String?,
  faction: json['faction'] as String?,
  description: json['description'] as String?,
  customFields:
      (json['customFields'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  universeIds:
      (json['universeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  coverImageId: json['coverImageId'] as String?,
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  personality: json['personality'] as String?,
  appearance: json['appearance'] as String?,
  notes: json['notes'] as String?,
  speechStyle: json['speechStyle'] as String?,
  aiPrompt: json['aiPrompt'] as String?,
  storyIds:
      (json['storyIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  versionIds:
      (json['versionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  relationships:
      (json['relationships'] as List<dynamic>?)
          ?.map((e) => Relationship.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Relationship>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CharacterToJson(_Character instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profession': instance.profession,
      'age': instance.age,
      'race': instance.race,
      'faction': instance.faction,
      'description': instance.description,
      'customFields': instance.customFields,
      'aliases': instance.aliases,
      'tags': instance.tags,
      'universeIds': instance.universeIds,
      'coverImageId': instance.coverImageId,
      'imageIds': instance.imageIds,
      'personality': instance.personality,
      'appearance': instance.appearance,
      'notes': instance.notes,
      'speechStyle': instance.speechStyle,
      'aiPrompt': instance.aiPrompt,
      'storyIds': instance.storyIds,
      'versionIds': instance.versionIds,
      'relationships': instance.relationships,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
