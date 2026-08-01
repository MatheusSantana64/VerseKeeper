// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'universe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Universe _$UniverseFromJson(Map<String, dynamic> json) => _Universe(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  coverImageId: json['coverImageId'] as String?,
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  characterIds:
      (json['characterIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  storyIds:
      (json['storyIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  locationIds:
      (json['locationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  organizationIds:
      (json['organizationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  itemIds:
      (json['itemIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  speciesIds:
      (json['speciesIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  timelineEventIds:
      (json['timelineEventIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UniverseToJson(_Universe instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'notes': instance.notes,
  'coverImageId': instance.coverImageId,
  'imageIds': instance.imageIds,
  'tags': instance.tags,
  'characterIds': instance.characterIds,
  'storyIds': instance.storyIds,
  'locationIds': instance.locationIds,
  'organizationIds': instance.organizationIds,
  'itemIds': instance.itemIds,
  'speciesIds': instance.speciesIds,
  'timelineEventIds': instance.timelineEventIds,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
