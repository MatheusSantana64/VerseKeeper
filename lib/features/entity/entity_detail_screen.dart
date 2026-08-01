import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../app_shell/app_drawer.dart';
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

class _EntityDetailBody extends StatelessWidget {
  const _EntityDetailBody({required this.entity});

  final StoredEntity entity;

  @override
  Widget build(BuildContext context) {
    final config = configOf(entity.entityType);
    final theme = Theme.of(context);
    final json = entity.toJson();

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
          if (_isFieldVisible(entry.key, entry.value))
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

  bool _isFieldVisible(String key, Object? value) {
    if (_skipKeys.contains(key)) return false;
    return formatValue(value).isNotEmpty;
  }
}
