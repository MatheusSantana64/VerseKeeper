import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity_type.dart';
import 'stored_entity.dart';

part 'field_definition.freezed.dart';
part 'field_definition.g.dart';

/// Defines one user-created custom field that appears on every entity of the
/// same type (currently characters).
///
/// The definition is global; individual entities store their own value under
/// this definition's id in `Character.customFields`. Definitions are
/// immutable-lite: renaming one leaves existing values intact because values
/// are keyed by id, not name.
@freezed
abstract class FieldDefinition with _$FieldDefinition implements StoredEntity {
  const FieldDefinition._();

  const factory FieldDefinition({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FieldDefinition;

  factory FieldDefinition.fromJson(Map<String, dynamic> json) =>
      _$FieldDefinitionFromJson(json);

  @override
  EntityType get entityType => EntityType.fieldDefinition;
}
