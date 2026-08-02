import '../../core/models/entity_type.dart';

/// The kind of widget used to edit a field's value.
enum FormFieldKind {
  /// Single-line text.
  text,

  /// Multi-line text.
  multiline,

  /// Free-form list of short strings, edited as chips.
  tags,

  /// Integer number.
  number,

  /// Reference to another entity, picked from a dropdown.
  entityPicker,

  /// Reference to several other entities, picked with filter chips.
  entityPickerMulti,

  /// Nested list of [Relationship]s to other entities.
  relationshipList,

  /// Nested list of [StoryAppearance]s (story casting: character + optional
  /// version + role).
  storyAppearanceList,
}

/// Defines one editable field of an entity type.
///
/// The key matches the JSON field name in the model so values can be read from
/// and written back to `toJson()`. Complex nested structures (relationships,
/// story appearances, version management) are not spec-driven but have their
/// own editors; the character main photo is a dedicated field rendered by
/// `_CoverImageField` in the edit screen and is not part of this spec.
class FormFieldSpec {
  const FormFieldSpec({
    required this.key,
    required this.label,
    required this.kind,
    this.required = false,
    this.referenceType,
  }) : assert(kind != FormFieldKind.entityPicker || referenceType != null),
      assert(kind != FormFieldKind.entityPickerMulti || referenceType != null);

  /// JSON field name in the model.
  final String key;

  /// Human-readable label.
  final String label;

  final FormFieldKind kind;

  /// Must be non-empty (text) / non-null (picker).
  final bool required;

  /// For [FormFieldKind.entityPicker]: the type of the referenced entity.
  final EntityType? referenceType;
}

/// Editable fields per entity type.
const Map<EntityType, List<FormFieldSpec>> entityFormSpecs = {
  EntityType.character: [
    FormFieldSpec(key: 'name', label: 'Name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(key: 'aliases', label: 'Aliases', kind: FormFieldKind.tags),
    FormFieldSpec(key: 'profession', label: 'Profession', kind: FormFieldKind.text),
    FormFieldSpec(key: 'age', label: 'Age', kind: FormFieldKind.text),
    FormFieldSpec(key: 'race', label: 'Race', kind: FormFieldKind.text),
    FormFieldSpec(key: 'faction', label: 'Faction', kind: FormFieldKind.text),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'personality', label: 'Personality', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'appearance', label: 'Appearance', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'speechStyle', label: 'Speech style', kind: FormFieldKind.text),
    FormFieldSpec(key: 'aiPrompt', label: 'AI prompt', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
    FormFieldSpec(
      key: 'universeIds',
      label: 'Universes',
      kind: FormFieldKind.entityPickerMulti,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'relationships', label: 'Relationships', kind: FormFieldKind.relationshipList),
  ],
  EntityType.characterVersion: [
    FormFieldSpec(
      key: 'characterId',
      label: 'Character',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.character,
      required: true,
    ),
    FormFieldSpec(key: 'name', label: 'Version name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'personality', label: 'Personality (override)', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'appearance', label: 'Appearance (override)', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes (override)', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'speechStyle', label: 'Speech style (override)', kind: FormFieldKind.text),
    FormFieldSpec(key: 'aiPrompt', label: 'AI prompt (override)', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags (override)', kind: FormFieldKind.tags),
  ],
  EntityType.story: [
    FormFieldSpec(key: 'title', label: 'Title', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'summary', label: 'Summary', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'genres', label: 'Genres', kind: FormFieldKind.tags),
    FormFieldSpec(key: 'status', label: 'Status', kind: FormFieldKind.text),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
    FormFieldSpec(key: 'appearances', label: 'Appearances', kind: FormFieldKind.storyAppearanceList),
  ],
  EntityType.universe: [
    FormFieldSpec(key: 'name', label: 'Name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
  ],
  EntityType.organization: [
    FormFieldSpec(key: 'name', label: 'Name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
  ],
  EntityType.location: [
    FormFieldSpec(key: 'name', label: 'Name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'type', label: 'Type', kind: FormFieldKind.text),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
  ],
  EntityType.item: [
    FormFieldSpec(key: 'name', label: 'Name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'type', label: 'Type', kind: FormFieldKind.text),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
  ],
  EntityType.species: [
    FormFieldSpec(key: 'name', label: 'Name', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
  ],
  EntityType.timelineEvent: [
    FormFieldSpec(key: 'title', label: 'Title', kind: FormFieldKind.text, required: true),
    FormFieldSpec(
      key: 'universeId',
      label: 'Universe',
      kind: FormFieldKind.entityPicker,
      referenceType: EntityType.universe,
    ),
    FormFieldSpec(key: 'dateLabel', label: 'Date label', kind: FormFieldKind.text),
    FormFieldSpec(key: 'sortOrder', label: 'Sort order', kind: FormFieldKind.number),
    FormFieldSpec(key: 'description', label: 'Description', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'notes', label: 'Notes', kind: FormFieldKind.multiline),
    FormFieldSpec(key: 'tags', label: 'Tags', kind: FormFieldKind.tags),
  ],
  EntityType.fieldDefinition: [
    FormFieldSpec(key: 'name', label: 'Field name', kind: FormFieldKind.text, required: true),
  ],
};
