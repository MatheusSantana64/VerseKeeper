// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldDefinition _$FieldDefinitionFromJson(Map<String, dynamic> json) =>
    _FieldDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FieldDefinitionToJson(_FieldDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
