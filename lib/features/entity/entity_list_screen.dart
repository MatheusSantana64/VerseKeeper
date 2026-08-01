import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../app_shell/app_drawer.dart';
import 'entity_display.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(config.label)),
      drawer: const AppDrawer(),
      body: entities.when(
        data: (list) => list.isEmpty
            ? _EmptyState(config: config)
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    _EntityTile(entity: list[index]),
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
          context.go('/library/${entity.entityType.name}/${entity.id}'),
      shape: Border(
        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.config});

  final EntityTypeConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              'This library is empty. Editing will arrive in a later '
              'version.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
