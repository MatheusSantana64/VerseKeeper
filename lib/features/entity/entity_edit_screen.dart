import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
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
      if (spec.kind == FormFieldKind.tags ||
          spec.kind == FormFieldKind.entityPicker ||
          spec.kind == FormFieldKind.entityPickerMulti) {
        _values[spec.key] = spec.kind == FormFieldKind.tags ||
                spec.kind == FormFieldKind.entityPickerMulti
            ? const <String>[]
            : null;
      } else {
        _controllers[spec.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
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
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final values = <String, dynamic>{
      for (final spec in entityFormSpecs[widget.type]!)
        spec.key: _valueFor(spec),
    };
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
