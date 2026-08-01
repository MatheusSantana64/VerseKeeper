import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/relationship.dart';
import '../../core/models/stored_entity.dart';
import '../../core/models/story_appearance.dart';
import '../../core/utils/id_generator.dart';
import '../app_shell/app_drawer.dart';
import 'entity_actions.dart';
import 'entity_display.dart';
import 'entity_form_spec.dart';
import 'entity_library_providers.dart';
import 'entity_type_config.dart';

/// Generic create/edit form for one entity type.
///
/// With a null [id] the screen creates a new entity; otherwise it loads and
/// edits the existing one. Fields come from [entityFormSpecs]; complex nested
/// structures are not editable yet.
class EntityEditScreen extends ConsumerStatefulWidget {
  const EntityEditScreen({super.key, required this.type, this.id});

  final EntityType type;
  final String? id;

  @override
  ConsumerState<EntityEditScreen> createState() => _EntityEditScreenState();
}

class _EntityEditScreenState extends ConsumerState<EntityEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, TextEditingController> _customControllers = {};
  final Map<String, dynamic> _values = {};
  final _idGenerator = const UuidIdGenerator();
  late final String _newId = _idGenerator.newId();

  bool _prefilled = false;
  Map<String, dynamic>? _existingJson;

  bool get _isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    for (final spec in entityFormSpecs[widget.type]!) {
      switch (spec.kind) {
        case FormFieldKind.tags:
        case FormFieldKind.entityPickerMulti:
          _values[spec.key] = const <String>[];
        case FormFieldKind.entityPicker:
          _values[spec.key] = null;
        case FormFieldKind.relationshipList:
        case FormFieldKind.storyAppearanceList:
          _values[spec.key] = const <Map<String, dynamic>>[];
        default:
          _controllers[spec.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final controller in _customControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _prefill(StoredEntity entity) {
    final json = entity.toJson();
    for (final spec in entityFormSpecs[widget.type]!) {
      final raw = json[spec.key];
      switch (spec.kind) {
        case FormFieldKind.text:
        case FormFieldKind.multiline:
        case FormFieldKind.number:
          _controllers[spec.key]?.text = raw?.toString() ?? '';
        case FormFieldKind.tags:
          _values[spec.key] =
              raw is List ? raw.cast<String>() : const <String>[];
        case FormFieldKind.entityPicker:
          _values[spec.key] = raw as String?;
        case FormFieldKind.entityPickerMulti:
          _values[spec.key] =
              raw is List ? raw.cast<String>() : const <String>[];
        case FormFieldKind.relationshipList:
          _values[spec.key] = raw is List
              ? raw.map((r) => (r as Relationship).toJson()).toList()
              : const <Map<String, dynamic>>[];
        case FormFieldKind.storyAppearanceList:
          _values[spec.key] = raw is List
              ? raw.map((a) {
                  if (a is StoryAppearance) return a.toJson();
                  if (a is Map) return Map<String, dynamic>.from(a);
                  return const <String, dynamic>{};
                }).toList()
              : const <Map<String, dynamic>>[];
      }
    }
  }

  Object? _valueFor(FormFieldSpec spec) {
    switch (spec.kind) {
      case FormFieldKind.text:
      case FormFieldKind.multiline:
        final text = _controllers[spec.key]!.text.trim();
        return text.isEmpty ? null : text;
      case FormFieldKind.number:
        final text = _controllers[spec.key]!.text.trim();
        return text.isEmpty ? 0 : int.tryParse(text) ?? 0;
      case FormFieldKind.tags:
        return _values[spec.key] as List<String>? ?? const <String>[];
      case FormFieldKind.entityPicker:
        return _values[spec.key] as String?;
      case FormFieldKind.entityPickerMulti:
        return _values[spec.key] as List<String>? ?? const <String>[];
      case FormFieldKind.relationshipList:
        return _values[spec.key] as List<Map<String, dynamic>>? ??
            const <Map<String, dynamic>>[];
      case FormFieldKind.storyAppearanceList:
        return _values[spec.key] as List<Map<String, dynamic>>? ??
            const <Map<String, dynamic>>[];
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final values = <String, dynamic>{
      for (final spec in entityFormSpecs[widget.type]!)
        spec.key: _valueFor(spec),
    };
    if (widget.type == EntityType.character) {
      values['customFields'] = <String, String>{
        for (final entry in _customControllers.entries)
          if (entry.value.text.trim().isNotEmpty)
            entry.key: entry.value.text.trim(),
      };
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final json = <String, dynamic>{
      ...?_existingJson,
      ...values,
      if (!_isEditing) 'id': _newId,
      'updatedAt': now,
      if (!_isEditing) 'createdAt': now,
    };

    final entity = entityFromJson(widget.type, json);
    await saveEntity(ref, entity);
    if (!mounted) return;
    context.go('/library/${widget.type.name}/${entity.id}');
  }

  @override
  Widget build(BuildContext context) {
    final config = configOf(widget.type);

    if (!_isEditing) {
      return _buildForm(context, config, existing: null);
    }

    final entity =
        ref.watch(entityDetailProvider((type: widget.type, id: widget.id!)));
    return entity.when(
      data: (value) =>
          _buildForm(context, config, existing: value?.toJson()),
      loading: () => Scaffold(
        appBar: AppBar(title: Text('Edit ${config.singular}')),
        drawer: const AppDrawer(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text('Edit ${config.singular}')),
        drawer: const AppDrawer(),
        body: Center(child: Text('Could not load: $error')),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    EntityTypeConfig config, {
    required Map<String, dynamic>? existing,
  }) {
    if (existing != null && !_prefilled) {
      _prefilled = true;
      _existingJson = existing;
      _prefill(entityFromJson(widget.type, existing));
    }

    final specs = entityFormSpecs[widget.type]!;
    final title = _isEditing ? 'Edit ${config.singular}' : 'New ${config.singular}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final spec in specs) _buildField(spec),
                    if (widget.type == EntityType.character)
                      ..._buildCustomFields(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Save changes' : 'Create'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(FormFieldSpec spec) {
    switch (spec.kind) {
      case FormFieldKind.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: _controllers[spec.key],
            decoration: InputDecoration(labelText: spec.label),
            textInputAction: TextInputAction.next,
            validator: _requiredTextValidator(spec),
          ),
        );
      case FormFieldKind.multiline:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: _controllers[spec.key],
            decoration: InputDecoration(labelText: spec.label),
            maxLines: 4,
            validator: _requiredTextValidator(spec),
          ),
        );
      case FormFieldKind.number:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: _controllers[spec.key],
            decoration: InputDecoration(labelText: spec.label),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (spec.required &&
                  (value == null || value.trim().isEmpty)) {
                return 'Required';
              }
              if (value != null &&
                  value.trim().isNotEmpty &&
                  int.tryParse(value.trim()) == null) {
                return 'Enter a whole number';
              }
              return null;
            },
          ),
        );
      case FormFieldKind.tags:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _TagsInput(
            label: spec.label,
            initial: _values[spec.key] as List<String>? ?? const [],
            onChanged: (tags) =>
                setState(() => _values[spec.key] = List.of(tags)),
          ),
        );
      case FormFieldKind.entityPicker:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _EntityPickerField(
            spec: spec,
            selectedId: _values[spec.key] as String?,
            onChanged: (id) => setState(() => _values[spec.key] = id),
          ),
        );
      case FormFieldKind.entityPickerMulti:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _EntityMultiPickerField(
            spec: spec,
            selectedIds: _values[spec.key] as List<String>? ?? const [],
            onChanged: (ids) => setState(() => _values[spec.key] = List.of(ids)),
          ),
        );
      case FormFieldKind.relationshipList:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _RelationshipListEditor(
            relationships:
                _values[spec.key] as List<Map<String, dynamic>>? ?? const [],
            excludeId: widget.id,
            onChanged: (relationships) =>
                setState(() => _values[spec.key] = List.of(relationships)),
          ),
        );
      case FormFieldKind.storyAppearanceList:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _StoryAppearanceListEditor(
            appearances:
                _values[spec.key] as List<Map<String, dynamic>>? ?? const [],
            onChanged: (appearances) =>
                setState(() => _values[spec.key] = List.of(appearances)),
          ),
        );
    }
  }

  /// Renders one editable input per defined custom field, creating and
  /// pre-filling the backing controller lazily from the existing JSON.
  List<Widget> _buildCustomFields() {
    final defs = ref.watch(entityListProvider(EntityType.fieldDefinition));
    return defs.when(
      data: (definitions) {
        _syncCustomControllers(definitions);
        if (definitions.isEmpty) return const <Widget>[];
        final theme = Theme.of(context);
        return [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Row(
              children: [
                Text(
                  'Custom fields',
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => context.go(
                    '/library/${EntityType.fieldDefinition.name}',
                  ),
                  icon: const Icon(Icons.playlist_add, size: 18),
                  label: const Text('Manage'),
                ),
              ],
            ),
          ),
          for (final definition in definitions)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _customControllers[definition.id],
                decoration:
                    InputDecoration(labelText: displayNameOf(definition)),
              ),
            ),
        ];
      },
      loading: () => const <Widget>[],
      error: (error, _) => [
        Text('Could not load custom fields: $error'),
      ],
    );
  }

  void _syncCustomControllers(List<StoredEntity> definitions) {
    final existing = _existingJson?['customFields'];
    for (final definition in definitions) {
      if (_customControllers.containsKey(definition.id)) continue;
      final controller = TextEditingController();
      if (existing is Map) {
        final value = existing[definition.id];
        if (value is String) controller.text = value;
      }
      _customControllers[definition.id] = controller;
    }
  }

  String? Function(String?) _requiredTextValidator(FormFieldSpec spec) {
    return (value) {
      if (spec.required && (value == null || value.trim().isEmpty)) {
        return 'Required';
      }
      return null;
    };
  }
}

/// Chip-based list input for tag-like fields.
class _TagsInput extends StatefulWidget {
  const _TagsInput({
    required this.label,
    required this.initial,
    required this.onChanged,
  });

  final String label;
  final List<String> initial;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_TagsInput> createState() => _TagsInputState();
}

class _TagsInputState extends State<_TagsInput> {
  late final List<String> _tags = List.of(widget.initial);
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty) return;
    if (_tags.contains(tag)) {
      _controller.clear();
      return;
    }
    setState(() {
      _tags.add(tag);
      _controller.clear();
    });
    widget.onChanged(_tags);
  }

  void _remove(String tag) {
    setState(() => _tags.remove(tag));
    widget.onChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tag in _tags)
              InputChip(
                label: Text(tag),
                onDeleted: () => _remove(tag),
              ),
            SizedBox(
              width: 160,
              child: TextField(
                controller: _controller,
                onSubmitted: _add,
                decoration: const InputDecoration(hintText: 'Add…'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Dropdown to pick a referenced entity, with an explicit "(None)" option.
class _EntityPickerField extends ConsumerWidget {
  const _EntityPickerField({
    required this.spec,
    required this.selectedId,
    required this.onChanged,
  });

  final FormFieldSpec spec;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(entityListProvider(spec.referenceType!));

    return candidates.when(
      data: (entities) => DropdownButtonFormField<String>(
        initialValue: selectedId ?? '',
        decoration: InputDecoration(labelText: spec.label),
        items: [
          const DropdownMenuItem<String>(
            value: '',
            child: Text('(None)'),
          ),
          for (final entity in entities)
            DropdownMenuItem<String>(
              value: entity.id,
              child: Text(displayNameOf(entity), overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (value) =>
            onChanged((value == null || value.isEmpty) ? null : value),
        validator: spec.required
            ? (value) =>
                (value == null || value.isEmpty) ? 'Required' : null
            : null,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text('Could not load options: $error'),
    );
  }
}

/// Filter-chip multi-select for list-valued entity references.
class _EntityMultiPickerField extends ConsumerWidget {
  const _EntityMultiPickerField({
    required this.spec,
    required this.selectedIds,
    required this.onChanged,
  });

  final FormFieldSpec spec;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final candidates = ref.watch(entityListProvider(spec.referenceType!));

    return candidates.when(
      data: (entities) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spec.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          if (entities.isEmpty)
            Text(
              'No ${configOf(spec.referenceType!).label.toLowerCase()} yet',
              style: theme.textTheme.bodySmall,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entity in entities)
                  FilterChip(
                    label: Text(displayNameOf(entity)),
                    selected: selectedIds.contains(entity.id),
                    onSelected: (selected) {
                      final next = List.of(selectedIds);
                      selected ? next.add(entity.id) : next.remove(entity.id);
                      onChanged(next);
                    },
                  ),
              ],
            ),
        ],
      ),
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text('Could not load options: $error'),
    );
  }
}

/// Draft state for one relationship row in the character form.
class _RelationshipDraft {
  _RelationshipDraft({
    this.otherCharacterId,
    this.type = RelationshipType.friend,
    String? customLabel,
    String? notes,
  })  : customLabelController = TextEditingController(text: customLabel),
        notesController = TextEditingController(text: notes);

  String? otherCharacterId;
  RelationshipType type;
  final TextEditingController customLabelController;
  final TextEditingController notesController;

  Map<String, dynamic> toJson() => {
        'otherCharacterId': otherCharacterId,
        'type': type.name,
        if (customLabelController.text.trim().isNotEmpty)
          'customLabel': customLabelController.text.trim(),
        if (notesController.text.trim().isNotEmpty)
          'notes': notesController.text.trim(),
      };

  void dispose() {
    customLabelController.dispose();
    notesController.dispose();
  }
}

/// Editable list of [Relationship]s (nested editor for the character form).
class _RelationshipListEditor extends ConsumerStatefulWidget {
  const _RelationshipListEditor({
    required this.relationships,
    required this.excludeId,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> relationships;
  final String? excludeId;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  @override
  ConsumerState<_RelationshipListEditor> createState() =>
      _RelationshipListEditorState();
}

class _RelationshipListEditorState
    extends ConsumerState<_RelationshipListEditor> {
  late final List<_RelationshipDraft> _drafts;

  @override
  void initState() {
    super.initState();
    _drafts = widget.relationships
        .map((json) => _RelationshipDraft(
              otherCharacterId: json['otherCharacterId'] as String?,
              type: RelationshipType.values.byName(json['type'] as String),
              customLabel: json['customLabel'] as String?,
              notes: json['notes'] as String?,
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  void _sync() {
    widget.onChanged([
      for (final draft in _drafts)
        if (draft.otherCharacterId != null) draft.toJson(),
    ]);
  }

  void _add() {
    setState(() => _drafts.add(_RelationshipDraft()));
    _sync();
  }

  void _remove(int index) {
    _drafts.removeAt(index).dispose();
    setState(() {});
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final candidates = ref.watch(entityListProvider(EntityType.character));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationships',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        candidates.when(
          data: (characters) {
            if (_drafts.isEmpty && characters.isEmpty) {
              return Text(
                'No other characters yet',
                style: theme.textTheme.bodySmall,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < _drafts.length; index++)
                  _RelationshipTile(
                    draft: _drafts[index],
                    characters: characters,
                    excludeId: widget.excludeId,
                    onChanged: () => setState(_sync),
                    onRemove: () => _remove(index),
                  ),
                OutlinedButton.icon(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                  label: const Text('Add relationship'),
                ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('Could not load characters: $error'),
        ),
      ],
    );
  }
}

/// One editable relationship row.
class _RelationshipTile extends StatelessWidget {
  const _RelationshipTile({
    required this.draft,
    required this.characters,
    required this.excludeId,
    required this.onChanged,
    required this.onRemove,
  });

  final _RelationshipDraft draft;
  final List<StoredEntity> characters;
  final String? excludeId;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final options =
        characters.where((character) => character.id != excludeId).toList();
    final selectedTarget =
        options.any((character) => character.id == draft.otherCharacterId)
            ? draft.otherCharacterId
            : '';
    final typeValue = draft.type.name;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedTarget,
                    decoration: const InputDecoration(labelText: 'Character'),
                    items: [
                      const DropdownMenuItem<String>(
                        value: '',
                        child: Text('(Choose character)'),
                      ),
                      for (final character in options)
                        DropdownMenuItem<String>(
                          value: character.id,
                          child: Text(
                            displayNameOf(character),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      draft.otherCharacterId =
                          (value == null || value.isEmpty) ? null : value;
                      onChanged();
                    },
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                  tooltip: 'Remove relationship',
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              initialValue: typeValue,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final type in RelationshipType.values)
                  DropdownMenuItem<String>(
                    value: type.name,
                    child: Text(prettyLabel(type.name)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  draft.type = RelationshipType.values.byName(value);
                  onChanged();
                }
              },
            ),
            if (draft.type == RelationshipType.custom)
              TextField(
                controller: draft.customLabelController,
                decoration: const InputDecoration(labelText: 'Label'),
                onChanged: (_) => onChanged(),
              ),
            TextField(
              controller: draft.notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 2,
              onChanged: (_) => onChanged(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draft state for one story-appearance row in the story form.
class _AppearanceDraft {
  _AppearanceDraft({this.characterId, this.versionId, String? role})
      : roleController = TextEditingController(text: role);

  String? characterId;
  String? versionId;
  final TextEditingController roleController;

  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        if (versionId != null) 'versionId': versionId,
        if (roleController.text.trim().isNotEmpty)
          'role': roleController.text.trim(),
      };

  void dispose() {
    roleController.dispose();
  }
}

/// Editable list of [StoryAppearance]s (story casting) for the story form.
class _StoryAppearanceListEditor extends ConsumerStatefulWidget {
  const _StoryAppearanceListEditor({
    required this.appearances,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> appearances;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  @override
  ConsumerState<_StoryAppearanceListEditor> createState() =>
      _StoryAppearanceListEditorState();
}

class _StoryAppearanceListEditorState
    extends ConsumerState<_StoryAppearanceListEditor> {
  late final List<_AppearanceDraft> _drafts;

  @override
  void initState() {
    super.initState();
    _drafts = widget.appearances
        .map((json) => _AppearanceDraft(
              characterId: json['characterId'] as String?,
              versionId: json['versionId'] as String?,
              role: json['role'] as String?,
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  void _sync() {
    widget.onChanged([
      for (final draft in _drafts)
        if (draft.characterId != null) draft.toJson(),
    ]);
  }

  void _add() {
    setState(() => _drafts.add(_AppearanceDraft()));
    _sync();
  }

  void _remove(int index) {
    _drafts.removeAt(index).dispose();
    setState(() {});
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final characters = ref.watch(entityListProvider(EntityType.character));
    final versions = ref.watch(entityListProvider(EntityType.characterVersion));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearances',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        characters.when(
          data: (candidates) {
            if (_drafts.isEmpty && candidates.isEmpty) {
              return Text(
                'No characters yet',
                style: theme.textTheme.bodySmall,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < _drafts.length; index++)
                  _AppearanceTile(
                    draft: _drafts[index],
                    characters: candidates,
                    versions: versions.value ?? const <StoredEntity>[],
                    onChanged: () => setState(_sync),
                    onRemove: () => _remove(index),
                  ),
                OutlinedButton.icon(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                  label: const Text('Add appearance'),
                ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('Could not load characters: $error'),
        ),
      ],
    );
  }
}

/// One editable story-appearance row.
class _AppearanceTile extends StatelessWidget {
  const _AppearanceTile({
    required this.draft,
    required this.characters,
    required this.versions,
    required this.onChanged,
    required this.onRemove,
  });

  final _AppearanceDraft draft;
  final List<StoredEntity> characters;
  final List<StoredEntity> versions;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  List<StoredEntity> _versionsFor(String? characterId) => [
        for (final version in versions)
          if (version.toJson()['characterId'] == characterId) version,
      ];

  @override
  Widget build(BuildContext context) {
    final selectedCharacter =
        characters.any((c) => c.id == draft.characterId) ? draft.characterId : '';
    final characterVersions = _versionsFor(draft.characterId);
    final selectedVersion =
        characterVersions.any((v) => v.id == draft.versionId)
            ? draft.versionId
            : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedCharacter,
                    decoration:
                        const InputDecoration(labelText: 'Character'),
                    items: [
                      const DropdownMenuItem<String>(
                        value: '',
                        child: Text('(Choose character)'),
                      ),
                      for (final character in characters)
                        DropdownMenuItem<String>(
                          value: character.id,
                          child: Text(
                            displayNameOf(character),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      draft.characterId =
                          (value == null || value.isEmpty) ? null : value;
                      draft.versionId = null;
                      onChanged();
                    },
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                  tooltip: 'Remove appearance',
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedVersion,
              decoration: const InputDecoration(labelText: 'Version'),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('(Default)'),
                ),
                for (final version in characterVersions)
                  DropdownMenuItem<String>(
                    value: version.id,
                    child: Text(
                      displayNameOf(version),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                draft.versionId =
                    (value == null || value.isEmpty) ? null : value;
                onChanged();
              },
            ),
            TextField(
              controller: draft.roleController,
              decoration: const InputDecoration(labelText: 'Role'),
              onChanged: (_) => onChanged(),
            ),
          ],
        ),
      ),
    );
  }
}
