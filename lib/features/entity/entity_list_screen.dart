import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../app_shell/app_drawer.dart';
import 'character_layout.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? BackButton(onPressed: () => context.pop())
            : null,
        title: Text(config.label),
        actions: [
          if (type == EntityType.character) ...[
            IconButton(
              tooltip: 'Layout',
              icon: const Icon(Icons.grid_view_rounded),
              onPressed: () => showCharacterLayoutDialog(context, ref),
            ),
            IconButton(
              tooltip: 'Relationship graph',
              icon: const Icon(Icons.hub_outlined),
              onPressed: () => context.push('/graph'),
            ),
          ],
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/library/${type.name}/new'),
        tooltip: 'New ${config.singular.toLowerCase()}',
        child: const Icon(Icons.add),
      ),
      body: entities.when(
        data: (list) {
          if (list.isEmpty) return _EmptyState(type: type);
          if (type == EntityType.character) {
            return _CharacterBody(
              list: list,
              layout: ref.watch(characterLayoutProvider),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final entity = list[index];
              return _EntityTile(entity: entity);
            },
          );
        },
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

/// Renders character cards in the chosen layout, each at the configured card
/// size and font size.
class _CharacterBody extends StatelessWidget {
  const _CharacterBody({required this.list, required this.layout});

  final List<StoredEntity> list;
  final CharacterLayout layout;

  @override
  Widget build(BuildContext context) {
    const gap = 8.0;
    const sidePadding = 12.0;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(sidePadding, 8, sidePadding, 88),
      child: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (var i = 0; i < list.length; i++)
            SizedBox(
              key: ValueKey('characterCard_$i'),
              width: layout.cardWidth.toDouble(),
              height: layout.cardHeight.toDouble(),
              child: switch (layout.type) {
                CharacterLayoutType.compact =>
                  _CompactCharacterCard(entity: list[i], layout: layout),
                CharacterLayoutType.portrait =>
                  _PortraitCharacterCard(entity: list[i], layout: layout),
                CharacterLayoutType.gallery =>
                  _GalleryCharacterCard(entity: list[i], layout: layout),
              },
            ),
        ],
      ),
    );
  }
}

String? _stringField(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is String && value.trim().isNotEmpty ? value.trim() : null;
}

/// Compact card for a character: photo on the left (not cropped to a
/// circle), then a "Name (ageyo) - profession" title and the description
/// below.
class _CompactCharacterCard extends StatelessWidget {
  const _CompactCharacterCard({required this.entity, required this.layout});

  final StoredEntity entity;
  final CharacterLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final json = entity.toJson();
    final config = configOf(entity.entityType);

    final age = _stringField(json, 'age');
    final profession = _stringField(json, 'profession');
    final description = _stringField(json, 'description');

    final title = StringBuffer(displayNameOf(entity));
    if (age != null) title.write(' (${age}yo)');
    if (profession != null) title.write(' - $profession');

    final titleStyle =
        theme.textTheme.titleMedium?.copyWith(fontSize: layout.fontSize + 2.0);
    final bodyStyle =
        theme.textTheme.bodySmall?.copyWith(fontSize: layout.fontSize - 1.0);

    return Card(
      key: const ValueKey('compactCharacterCard'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            context.push('/library/${entity.entityType.name}/${entity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Flexible(
                child: CoverImage(
                  imageId: json['coverImageId'] as String?,
                  fixedHeight: (layout.cardHeight - 12).toDouble(),
                  borderRadius: 8,
                  icon: config.icon,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toString(),
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: bodyStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Portrait card: a taller photo on the left with name, age and profession
/// stacked on the right.
class _PortraitCharacterCard extends StatelessWidget {
  const _PortraitCharacterCard({required this.entity, required this.layout});

  final StoredEntity entity;
  final CharacterLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final json = entity.toJson();
    final config = configOf(entity.entityType);

    final name = displayNameOf(entity);
    final age = _stringField(json, 'age');
    final profession = _stringField(json, 'profession');

    final titleStyle =
        theme.textTheme.titleMedium?.copyWith(fontSize: layout.fontSize + 2.0);
    final bodyStyle =
        theme.textTheme.bodyMedium?.copyWith(fontSize: layout.fontSize.toDouble());

    return Card(
      key: const ValueKey('portraitCharacterCard'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            context.push('/library/${entity.entityType.name}/${entity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: CoverImage(
                  imageId: json['coverImageId'] as String?,
                  fixedHeight: (layout.cardHeight - 12).toDouble(),
                  borderRadius: 8,
                  icon: config.icon,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (age != null) ...[
                      const SizedBox(height: 2),
                      Text(age, style: bodyStyle),
                    ],
                    if (profession != null) ...[
                      const SizedBox(height: 2),
                      Text(profession, style: bodyStyle),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gallery card: a big photo filling the card with the character name below.
class _GalleryCharacterCard extends StatelessWidget {
  const _GalleryCharacterCard({required this.entity, required this.layout});

  final StoredEntity entity;
  final CharacterLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final json = entity.toJson();
    final config = configOf(entity.entityType);

    final titleStyle =
        theme.textTheme.titleMedium?.copyWith(fontSize: layout.fontSize + 2.0);

    return Card(
      key: const ValueKey('galleryCharacterCard'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            context.push('/library/${entity.entityType.name}/${entity.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CoverImage(
                imageId: json['coverImageId'] as String?,
                fill: true,
                borderRadius: 0,
                icon: config.icon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                displayNameOf(entity),
                style: titleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
