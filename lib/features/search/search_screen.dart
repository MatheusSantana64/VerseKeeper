import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/stored_entity.dart';
import '../../data/repositories/repository_providers.dart';
import '../app_shell/app_drawer.dart';
import '../entity/entity_display.dart';
import '../entity/entity_type_config.dart';

/// Cross-entity full-text search screen.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search characters, stories, places…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? _Hint(text: 'Type to search your entire library.')
                : results.when(
                    data: (list) => list.isEmpty
                        ? const _Hint(text: 'No matches found.')
                        : _ResultsList(results: list),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        Center(child: Text('Search failed: $error')),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Debounced cross-entity search results for [query].
final searchResultsProvider = StreamProvider.autoDispose
    .family<List<StoredEntity>, String>((ref, query) {
  return ref.watch(searchRepositoryProvider).watchSearch(query);
});

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results});

  final List<StoredEntity> results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byType = <EntityType, List<StoredEntity>>{};
    for (final entity in results) {
      byType.putIfAbsent(entity.entityType, () => []).add(entity);
    }
    final groups = byType.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            '${results.length} ${results.length == 1 ? 'result' : 'results'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: groups.fold<int>(0, (sum, g) => sum + g.value.length + 1),
            itemBuilder: (context, index) {
              for (final group in groups) {
                final header = 1;
                final sectionLength = group.value.length + header;
                if (index < sectionLength) {
                  if (index == 0) {
                    return _TypeHeader(type: group.key);
                  }
                  return _ResultTile(entity: group.value[index - 1]);
                }
                index -= sectionLength;
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _TypeHeader extends StatelessWidget {
  const _TypeHeader({required this.type});

  final EntityType type;

  @override
  Widget build(BuildContext context) {
    final config = configOf(type);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Icon(config.icon, size: 18, color: theme.colorScheme.outline),
          const SizedBox(width: 8),
          Text(
            config.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.entity});

  final StoredEntity entity;

  @override
  Widget build(BuildContext context) {
    final config = configOf(entity.entityType);
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(config.icon),
      title: Text(displayNameOf(entity)),
      subtitle: previewOf(entity) == null
          ? Text(config.singular)
          : Text(previewOf(entity)!, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        config.singular,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
      ),
      onTap: () =>
          context.go('/library/${entity.entityType.name}/${entity.id}'),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
