import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/character.dart';
import '../../core/models/character_version.dart';
import '../../core/models/entity_type.dart';
import '../../core/models/relationship.dart';
import '../../core/models/stored_entity.dart';
import '../../core/models/story_appearance.dart';
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
    final isFieldDefinition = type == EntityType.fieldDefinition;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete entity?'),
        content: Text(
          isFieldDefinition
              ? 'This removes the custom field definition and its values from '
                    'every character. This action cannot be undone.'
              : 'This removes the entity from your library. This action cannot '
                    'be undone.',
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
    final isStory = entity.entityType == EntityType.story;

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
          if (_isFieldVisible(entry.key, entry.value, isCharacter, isStory))
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
        if (isStory) ..._storySections(context, ref, theme, json),
        if (entity.entityType == EntityType.characterVersion)
          ..._versionResolvedSection(context, ref, theme, entity),
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

  bool _isFieldVisible(
    String key,
    Object? value,
    bool isCharacter,
    bool isStory,
  ) {
    if (_skipKeys.contains(key)) return false;
    if (isCharacter && (key == 'customFields' || key == 'relationships')) {
      return false;
    }
    if (isStory && key == 'appearances') return false;
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
        ..._relationshipTiles(context, ref, json['relationships'] as List),
      ],
      if (json['customFields'] is Map &&
          (json['customFields'] as Map).isNotEmpty) ...[
        const SizedBox(height: 8),
        Text('Custom fields', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ..._customFieldTiles(ref, theme, json['customFields'] as Map),
      ],
      ..._characterStorySection(context, ref, theme),
      ..._characterVersionsSection(context, ref, theme),
    ];
  }

  List<Widget> _characterVersionsSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final versions = ref.watch(entityListProvider(EntityType.characterVersion));
    final universes = ref.watch(entityListProvider(EntityType.universe));
    final universeById = {
      for (final universe in universes.value ?? const <StoredEntity>[])
        universe.id: universe,
    };
    final mine = [
      for (final version in versions.value ?? const <StoredEntity>[])
        if (version.toJson()['characterId'] == entity.id) version,
    ];
    return [
      const SizedBox(height: 8),
      Row(
        children: [
          Text('Versions', style: theme.textTheme.titleSmall),
          const Spacer(),
          TextButton.icon(
            onPressed: () => context.go(
              '/library/${EntityType.characterVersion.name}/new'
              '?characterId=${entity.id}',
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New version'),
          ),
        ],
      ),
      if (mine.isEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'No versions yet',
            style: theme.textTheme.bodySmall,
          ),
        )
      else
        for (final version in mine)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(configOf(EntityType.characterVersion).icon),
            title: Text(displayNameOf(version)),
            subtitle: _versionSubtitle(version, universeById),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                context.go('/library/characterVersion/${version.id}'),
          ),
    ];
  }

  Text? _versionSubtitle(
    StoredEntity version,
    Map<String, StoredEntity> universeById,
  ) {
    final universeId = version.toJson()['universeId'];
    final universe = universeId is String ? universeById[universeId] : null;
    if (universe == null) return null;
    return Text(displayNameOf(universe));
  }

  List<Widget> _versionResolvedSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    StoredEntity versionEntity,
  ) {
    final version = versionEntity as CharacterVersion;
    final base = ref.watch(
      entityDetailProvider((type: EntityType.character, id: version.characterId)),
    );
    return [
      const SizedBox(height: 8),
      base.when(
        data: (value) => value == null
            ? const SizedBox.shrink()
            : ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(configOf(EntityType.character).icon),
                title: Text('Base character: ${displayNameOf(value)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.go('/library/character/${value.id}'),
              ),
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Could not load base character: $error'),
      ),
      const SizedBox(height: 8),
      Text('Resolved snapshot', style: theme.textTheme.titleSmall),
      const SizedBox(height: 4),
      base.when(
        data: (value) {
          if (value == null) {
            return Text(
              'Base character not found.',
              style: theme.textTheme.bodySmall,
            );
          }
          final resolved = (value as Character).resolve(version);
          final rows = [
            'Name: ${resolved.name}',
            if (resolved.personality != null)
              'Personality: ${resolved.personality}',
            if (resolved.appearance != null)
              'Appearance: ${resolved.appearance}',
            if (resolved.notes != null) 'Notes: ${resolved.notes}',
            if (resolved.speechStyle != null)
              'Speech style: ${resolved.speechStyle}',
            if (resolved.aiPrompt != null) 'AI prompt: ${resolved.aiPrompt}',
            if (resolved.tags.isNotEmpty) 'Tags: ${resolved.tags.join(', ')}',
            if (resolved.relationships.isNotEmpty)
              'Relationships: ${resolved.relationships.length}',
          ];
          return SelectableText(
            rows.join('\n'),
            style: theme.textTheme.bodyMedium,
          );
        },
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Could not load base character: $error'),
      ),
    ];
  }

  List<Widget> _characterStorySection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final stories = ref.watch(entityListProvider(EntityType.story));
    final mine = [
      for (final story in stories.value ?? const <StoredEntity>[])
        if (_storyHasCharacter(story, entity.id)) story,
    ];
    if (mine.isEmpty) return const [];
    return [
      const SizedBox(height: 8),
      Text('Stories', style: theme.textTheme.titleSmall),
      const SizedBox(height: 4),
      for (final story in mine)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(configOf(EntityType.story).icon),
          title: Text(displayNameOf(story)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/library/story/${story.id}'),
        ),
    ];
  }

  bool _storyHasCharacter(StoredEntity story, String characterId) {
    final appearances = story.toJson()['appearances'];
    if (appearances is! List) return false;
    for (final appearance in appearances) {
      if (appearance is StoryAppearance &&
          appearance.characterId == characterId) {
        return true;
      }
      if (appearance is Map && appearance['characterId'] == characterId) {
        return true;
      }
    }
    return false;
  }

  List<Widget> _storySections(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Map<String, dynamic> json,
  ) {
    final appearances = json['appearances'];
    if (appearances is! List || appearances.isEmpty) return const [];
    return [
      const SizedBox(height: 8),
      Text('Appearances', style: theme.textTheme.titleSmall),
      const SizedBox(height: 8),
      ..._appearanceTiles(context, ref, theme, appearances),
    ];
  }

  List<Widget> _appearanceTiles(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    List<dynamic> appearances,
  ) {
    final characters = ref.watch(entityListProvider(EntityType.character));
    final charById = {
      for (final character in characters.value ?? const <StoredEntity>[])
        character.id: character,
    };
    final versions = ref.watch(entityListProvider(EntityType.characterVersion));
    final versionById = {
      for (final version in versions.value ?? const <StoredEntity>[])
        version.id: version,
    };
    final tiles = <Widget>[];
    for (final appearance in appearances) {
      final characterId = appearance is StoryAppearance
          ? appearance.characterId
          : (appearance is Map ? appearance['characterId'] : null);
      final versionId = appearance is StoryAppearance
          ? appearance.versionId
          : (appearance is Map ? appearance['versionId'] : null);
      final role = appearance is StoryAppearance
          ? appearance.role
          : (appearance is Map ? appearance['role'] : null);
      final character =
          characterId is String ? charById[characterId] : null;
      final characterName = character == null
          ? (characterId is String ? '(deleted)' : '?')
          : displayNameOf(character);
      final version = versionId is String ? versionById[versionId] : null;
      final subtitleLines = [
        if (version != null) displayNameOf(version),
        if (role is String && role.trim().isNotEmpty) role,
      ];
      tiles.add(ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.theater_comedy_outlined,
            color: theme.colorScheme.outline),
        title: Text(characterName),
        subtitle: subtitleLines.isEmpty ? null : Text(subtitleLines.join('\n')),
        trailing: const Icon(Icons.chevron_right),
        onTap: character != null
            ? () => context.go('/library/character/${character.id}')
            : version != null
                ? () =>
                    context.go('/library/characterVersion/${version.id}')
                : null,
      ));
    }
    return tiles;
  }

  List<Widget> _relationshipTiles(
    BuildContext context,
    WidgetRef ref,
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
    final targetName = target == null
        ? (targetId == null ? '?' : '(deleted)')
        : displayNameOf(target);
    final typeLabel = typeName ?? '';
    final effectiveType =
        typeLabel.isEmpty ? 'relationship' : prettyLabel(typeLabel);
    final subtitleLines = [
      effectiveType,
      if (customLabel != null && customLabel!.trim().isNotEmpty) customLabel!,
      if (notes != null && notes!.trim().isNotEmpty) notes!,
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.people_outline, color: theme.colorScheme.outline),
      title: Text(targetName),
      subtitle: subtitleLines.isEmpty ? null : Text(subtitleLines.join('\n')),
      trailing: const Icon(Icons.chevron_right),
      onTap: target == null
          ? null
          : () => context.go('/library/character/${target.id}'),
    );
  }
}
