import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../app_shell/app_drawer.dart';
import 'entity_display.dart';
import 'entity_image_providers.dart';
import 'entity_library_providers.dart';
import 'entity_type_config.dart';

/// Browsable list of all entities of one [type].
class EntityListScreen extends ConsumerWidget {
  const EntityListScreen({super.key, required this.type});

  final EntityType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = configOf(type);
    final entities = ref.watch(entityListProvider(type));
    final universes = type == EntityType.character
        ? ref.watch(entityListProvider(EntityType.universe))
        : null;
    final universeById = universes == null
        ? const <String, StoredEntity>{}
        : {
            for (final universe in universes.value ?? const <StoredEntity>[])
              universe.id: universe,
          };

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? BackButton(onPressed: () => context.pop())
            : null,
        title: Text(config.label),
        actions: [
          if (type == EntityType.character)
            IconButton(
              tooltip: 'Relationship graph',
              icon: const Icon(Icons.hub_outlined),
              onPressed: () => context.push('/graph'),
            ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/library/${type.name}/new'),
        tooltip: 'New ${config.singular.toLowerCase()}',
        child: const Icon(Icons.add),
      ),
      body: entities.when(
        data: (list) => list.isEmpty
            ? _EmptyState(type: type)
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final entity = list[index];
                  return type == EntityType.character
                      ? _CharacterListTile(
                          entity: entity,
                          universeById: universeById,
                        )
                      : _EntityTile(entity: entity);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load: $error')),
      ),
    );
  }
}

class _EntityTile extends StatelessWidget {
  const _EntityTile({required this.entity});

  final StoredEntity entity;

  @override
  Widget build(BuildContext context) {
    final config = configOf(entity.entityType);
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(config.icon),
      title: Text(displayNameOf(entity)),
      subtitle: previewOf(entity) == null
          ? null
          : Text(
              previewOf(entity)!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () =>
          context.push('/library/${entity.entityType.name}/${entity.id}'),
      shape: Border(
        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
    );
  }
}

/// Rich tile for a character: shows every non-empty field, with long-form
/// text truncated to a few lines.
class _CharacterListTile extends StatelessWidget {
  const _CharacterListTile({
    required this.entity,
    required this.universeById,
  });

  final StoredEntity entity;
  final Map<String, StoredEntity> universeById;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final json = entity.toJson();
    final config = configOf(entity.entityType);

    String? stringField(String key) {
      final value = json[key];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    String? listField(String key) {
      final value = json[key];
      if (value is! List || value.isEmpty) return null;
      return value.map((item) => item.toString()).join(', ');
    }

    String? universeField() {
      final value = json['universeIds'];
      if (value is! List || value.isEmpty) return null;
      final names = [
        for (final id in value)
          universeById[id] == null ? id.toString() : displayNameOf(universeById[id]!),
      ];
      return names.join(', ');
    }

    Widget row(String label, String? value, {int maxLines = 2}) {
      if (value == null || value.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
              TextSpan(text: value, style: theme.textTheme.bodySmall),
            ],
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.push('/library/${entity.entityType.name}/${entity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CoverImage(
                    imageId: json['coverImageId'] as String?,
                    size: 40,
                    borderRadius: 20,
                    icon: config.icon,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayNameOf(entity),
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              row('Profession', stringField('profession')),
              row('Age', stringField('age')),
              row('Race', stringField('race')),
              row('Faction', stringField('faction')),
              row('Aliases', listField('aliases')),
              row('Universes', universeField()),
              row('Tags', listField('tags')),
              row('Description', stringField('description'), maxLines: 3),
              row('Personality', stringField('personality')),
              row('Appearance', stringField('appearance')),
              row('Notes', stringField('notes')),
              row('Speech style', stringField('speechStyle')),
              row('AI prompt', stringField('aiPrompt')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type});

  final EntityType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = configOf(type);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(config.icon, size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'No ${config.label.toLowerCase()} yet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first ${config.singular.toLowerCase()} to get '
              'started.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push('/library/${type.name}/new'),
              icon: const Icon(Icons.add),
              label: Text('New ${config.singular.toLowerCase()}'),
            ),
          ],
        ),
      ),
    );
  }
}
