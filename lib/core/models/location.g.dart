// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: json['id'] as String,
  name: json['name'] as String,
  universeId: json['universeId'] as String?,
  type: json['type'] as String?,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  coverImageId: json['coverImageId'] as String?,
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  parentLocationId: json['parentLocationId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'universeId': instance.universeId,
  'type': instance.type,
  'description': instance.description,
  'notes': instance.notes,
  'coverImageId': instance.coverImageId,
  'imageIds': instance.imageIds,
  'tags': instance.tags,
  'parentLocationId': instance.parentLocationId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
