// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CharacterVersion _$CharacterVersionFromJson(
  Map<String, dynamic> json,
) => _CharacterVersion(
  id: json['id'] as String,
  characterId: json['characterId'] as String,
  universeId: json['universeId'] as String?,
  name: json['name'] as String,
  coverImageId: json['coverImageId'] as String?,
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  personality: json['personality'] as String?,
  appearance: json['appearance'] as String?,
  notes: json['notes'] as String?,
  speechStyle: json['speechStyle'] as String?,
  aiPrompt: json['aiPrompt'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  storyIds:
      (json['storyIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  relationships:
      (json['relationships'] as List<dynamic>?)
          ?.map((e) => Relationship.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Relationship>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CharacterVersionToJson(_CharacterVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'characterId': instance.characterId,
      'universeId': instance.universeId,
      'name': instance.name,
      'coverImageId': instance.coverImageId,
      'imageIds': instance.imageIds,
      'personality': instance.personality,
      'appearance': instance.appearance,
      'notes': instance.notes,
      'speechStyle': instance.speechStyle,
      'aiPrompt': instance.aiPrompt,
      'tags': instance.tags,
      'storyIds': instance.storyIds,
      'relationships': instance.relationships,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
