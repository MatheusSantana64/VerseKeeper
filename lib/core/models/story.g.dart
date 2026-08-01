// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Story _$StoryFromJson(Map<String, dynamic> json) => _Story(
  id: json['id'] as String,
  title: json['title'] as String,
  universeId: json['universeId'] as String?,
  summary: json['summary'] as String?,
  notes: json['notes'] as String?,
  coverImageId: json['coverImageId'] as String?,
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status: json['status'] as String?,
  appearances:
      (json['appearances'] as List<dynamic>?)
          ?.map((e) => StoryAppearance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StoryAppearance>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StoryToJson(_Story instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'universeId': instance.universeId,
  'summary': instance.summary,
  'notes': instance.notes,
  'coverImageId': instance.coverImageId,
  'imageIds': instance.imageIds,
  'tags': instance.tags,
  'genres': instance.genres,
  'status': instance.status,
  'appearances': instance.appearances,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
