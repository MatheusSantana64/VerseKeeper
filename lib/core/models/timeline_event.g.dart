// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineEvent _$TimelineEventFromJson(Map<String, dynamic> json) =>
    _TimelineEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      universeId: json['universeId'] as String?,
      dateLabel: json['dateLabel'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      involvedCharacterIds:
          (json['involvedCharacterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      involvedOrganizationIds:
          (json['involvedOrganizationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      involvedLocationIds:
          (json['involvedLocationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      relatedEventIds:
          (json['relatedEventIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TimelineEventToJson(_TimelineEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'universeId': instance.universeId,
      'dateLabel': instance.dateLabel,
      'sortOrder': instance.sortOrder,
      'description': instance.description,
      'notes': instance.notes,
      'tags': instance.tags,
      'involvedCharacterIds': instance.involvedCharacterIds,
      'involvedOrganizationIds': instance.involvedOrganizationIds,
      'involvedLocationIds': instance.involvedLocationIds,
      'relatedEventIds': instance.relatedEventIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
