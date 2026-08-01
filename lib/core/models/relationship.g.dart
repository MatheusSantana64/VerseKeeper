// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Relationship _$RelationshipFromJson(Map<String, dynamic> json) =>
    _Relationship(
      otherCharacterId: json['otherCharacterId'] as String,
      type: $enumDecode(_$RelationshipTypeEnumMap, json['type']),
      customLabel: json['customLabel'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RelationshipToJson(_Relationship instance) =>
    <String, dynamic>{
      'otherCharacterId': instance.otherCharacterId,
      'type': _$RelationshipTypeEnumMap[instance.type]!,
      'customLabel': instance.customLabel,
      'notes': instance.notes,
    };

const _$RelationshipTypeEnumMap = {
  RelationshipType.parent: 'parent',
  RelationshipType.child: 'child',
  RelationshipType.sibling: 'sibling',
  RelationshipType.grandparent: 'grandparent',
  RelationshipType.grandchild: 'grandchild',
  RelationshipType.spouse: 'spouse',
  RelationshipType.partner: 'partner',
  RelationshipType.friend: 'friend',
  RelationshipType.rival: 'rival',
  RelationshipType.enemy: 'enemy',
  RelationshipType.mentor: 'mentor',
  RelationshipType.student: 'student',
  RelationshipType.employer: 'employer',
  RelationshipType.employee: 'employee',
  RelationshipType.organizationMember: 'organizationMember',
  RelationshipType.ally: 'ally',
  RelationshipType.neutral: 'neutral',
  RelationshipType.custom: 'custom',
};
