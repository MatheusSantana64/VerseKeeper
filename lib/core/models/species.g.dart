// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Species _$SpeciesFromJson(Map<String, dynamic> json) => _Species(
  id: json['id'] as String,
  name: json['name'] as String,
  universeId: json['universeId'] as String?,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  coverImageId: json['coverImageId'] as String?,
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SpeciesToJson(_Species instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'universeId': instance.universeId,
  'description': instance.description,
  'notes': instance.notes,
  'coverImageId': instance.coverImageId,
  'imageIds': instance.imageIds,
  'tags': instance.tags,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
