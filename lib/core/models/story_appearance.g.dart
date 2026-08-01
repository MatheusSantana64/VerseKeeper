// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_appearance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryAppearance _$StoryAppearanceFromJson(Map<String, dynamic> json) =>
    _StoryAppearance(
      characterId: json['characterId'] as String,
      versionId: json['versionId'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$StoryAppearanceToJson(_StoryAppearance instance) =>
    <String, dynamic>{
      'characterId': instance.characterId,
      'versionId': instance.versionId,
      'role': instance.role,
    };
