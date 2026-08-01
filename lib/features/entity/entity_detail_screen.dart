import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/relationship.dart';
import '../../core/models/stored_entity.dart';
import '../app_shell/app_drawer.dart';
import 'entity_actions.dart';
import 'entity_display.dart';
import 'entity_library_providers.dart';
import 'entity_type_config.dart';

const _skipKeys = {'id', 'createdAt', 'updatedAt', 'entityType', 'name', 'title'};

/// Read-only detail view for a single entity.
class EntityDetailScreen extends ConsumerWidget {
  const EntityDetailScreen({super.key, required this.type, required this.id});

  final EntityType type;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = configOf(type);
    final entity = ref.watch(entityDetailProvider((type: type, id: id)));

    return Scaffold(
      appBar: AppBar(
        title: Text(entity.value == null
            ? config.singular
            : displayNameOf(entity.value!)),
        actions: entity.value == null
            ? null
            : [
                if (type == EntityType.character)
                  IconButton(
                    tooltip: 'Manage character fields',
                    icon: const Icon(Icons.playlist_add),
                    onPressed: () =>
                        context.go('/library/${EntityType.fieldDefinition.name}'),
                  ),
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.go('/library/$type/${entity.value!.id}/edit'),
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
      ),
      drawer: const AppDrawer(),
      body: entity.when(
        data: (value) =>
            value == null ? const _NotFound() : _EntityDetailBody(entity: value),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load: $error')),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete entity?'),
        content: const Text(
          'This removes the entity from your library. This action cannot be '
          'undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await deleteEntity(ref, type, id);
    if (context.mounted) context.go('/library/${type.name}');
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Not found or deleted',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _EntityDetailBody extends ConsumerWidget {
  const _EntityDetailBody({required this.entity});

  final StoredEntity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = configOf(entity.entityType);
    final theme = Theme.of(context);
    final json = entity.toJson();
    final isCharacter = entity.entityType == EntityType.character;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(config.icon, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayNameOf(entity),
                    style: theme.textTheme.headlineSmall,
                  ),
                  Text(
                    config.singular,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        for (final entry in json.entries)
          if (_isFieldVisible(entry.key, entry.value, isCharacter))
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prettyLabel(entry.key),
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    formatValue(entry.value),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
        if (isCharacter) ..._characterSections(context, ref, theme, json),
        const SizedBox(height: 16),
        Text(
          'Created ${formatValue(json['createdAt'])}\n'
          'Updated ${formatValue(json['updatedAt'])}',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.outline),
        ),
      ],
    );
  }

  bool _isFieldVisible(String key, Object? value, bool isCharacter) {
    if (_skipKeys.contains(key)) return false;
    if (isCharacter && (key == 'customFields' || key == 'relationships')) {
      return false;
    }
    return formatValue(value).isNotEmpty;
  }

  List<Widget> _characterSections(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Map<String, dynamic> json,
  ) {
    return [
      if (json['relationships'] is List &&
          (json['relationships'] as List).isNotEmpty) ...[
        const SizedBox(height: 8),
        Text('Relationships', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ..._relationshipTiles(ref, theme, json['relationships'] as List),
      ],
      if (json['customFields'] is Map &&
          (json['customFields'] as Map).isNotEmpty) ...[
        const SizedBox(height: 8),
        Text('Custom fields', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ..._customFieldTiles(ref, theme, json['customFields'] as Map),
      ],
    ];
  }

  List<Widget> _relationshipTiles(
    WidgetRef ref,
    ThemeData theme,
    List<dynamic> relationships,
  ) {
    final characters = ref.watch(entityListProvider(EntityType.character));
    final byId = {
      for (final character in characters.value ?? const <StoredEntity>[])
        character.id: character,
    };
    final tiles = <Widget>[];
    for (final rel in relationships) {
      if (rel is Relationship) {
        tiles.add(_RelationshipDetailTile(
          targetId: rel.otherCharacterId,
          typeName: rel.type.name,
          customLabel: rel.customLabel,
          notes: rel.notes,
          byId: byId,
        ));
      } else if (rel is Map) {
        tiles.add(_RelationshipDetailTile(
          targetId: rel['otherCharacterId'] as String?,
          typeName: rel['type']?.toString(),
          customLabel: rel['customLabel'] as String?,
          notes: rel['notes'] as String?,
          byId: byId,
        ));
      }
    }
    return tiles;
  }

  List<Widget> _customFieldTiles(
    WidgetRef ref,
    ThemeData theme,
    Map<dynamic, dynamic> customFields,
  ) {
    final defs = ref.watch(entityListProvider(EntityType.fieldDefinition));
    final namesById = {
      for (final definition in defs.value ?? const <StoredEntity>[])
        definition.id: displayNameOf(definition),
    };
    return [
      for (final entry in customFields.entries)
        if (entry.value is String && (entry.value as String).trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namesById[entry.key] ?? entry.key.toString(),
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  (entry.value as String).trim(),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
    ];
  }
}

class _RelationshipDetailTile extends StatelessWidget {
  const _RelationshipDetailTile({
    required this.targetId,
    required this.typeName,
    required this.customLabel,
    required this.notes,
    required this.byId,
  });

  final String? targetId;
  final String? typeName;
  final String? customLabel;
  final String? notes;
  final Map<String, StoredEntity> byId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = targetId == null ? null : byId[targetId];
    final targetName =
        target == null ? (targetId ?? '?') : displayNameOf(target);
    final typeLabel = typeName ?? '';
    final effectiveType =
        typeLabel.isEmpty ? 'relationship' : prettyLabel(typeLabel);
    final lines = [
      '$effectiveType · $targetName',
      if (customLabel != null && customLabel!.trim().isNotEmpty) customLabel!,
      if (notes != null && notes!.trim().isNotEmpty) notes!,
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.people_outline, size: 20, color: theme.colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              lines.join('\n'),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
