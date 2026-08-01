import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

/// The kind of relationship one character has with another.
///
/// A relationship is directional: it is stored once on the *owner*
/// character. The reverse direction is derived by the graph layer via
/// [inverse], so it is never duplicated in storage.
enum RelationshipType {
  parent,
  child,
  sibling,
  grandparent,
  grandchild,
  spouse,
  partner,
  friend,
  rival,
  enemy,
  mentor,
  student,
  employer,
  employee,
  organizationMember,
  ally,
  neutral,
  custom;

  /// The relationship type a [Relationship] of this type implies when viewed
  /// from the other character's side.
  RelationshipType get inverse => switch (this) {
        RelationshipType.parent => RelationshipType.child,
        RelationshipType.child => RelationshipType.parent,
        RelationshipType.sibling => RelationshipType.sibling,
        RelationshipType.grandparent => RelationshipType.grandchild,
        RelationshipType.grandchild => RelationshipType.grandparent,
        RelationshipType.spouse => RelationshipType.spouse,
        RelationshipType.partner => RelationshipType.partner,
        RelationshipType.friend => RelationshipType.friend,
        RelationshipType.rival => RelationshipType.rival,
        RelationshipType.enemy => RelationshipType.enemy,
        RelationshipType.mentor => RelationshipType.student,
        RelationshipType.student => RelationshipType.mentor,
        RelationshipType.employer => RelationshipType.employee,
        RelationshipType.employee => RelationshipType.employer,
        RelationshipType.organizationMember => RelationshipType.organizationMember,
        RelationshipType.ally => RelationshipType.ally,
        RelationshipType.neutral => RelationshipType.neutral,
        RelationshipType.custom => RelationshipType.custom,
      };
}

/// A directed link from an owning character to another character.
///
/// Stored as a list on the owning character (see
/// `Character.relationships`). Generic enough to be rendered as an edge in a
/// future relationship graph.
@freezed
abstract class Relationship with _$Relationship {
  const factory Relationship({
    /// The character this relationship points to.
    required String otherCharacterId,

    /// The kind of relationship.
    required RelationshipType type,

    /// Free text label used when [type] is [RelationshipType.custom].
    String? customLabel,

    /// Optional notes about the relationship.
    String? notes,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}
