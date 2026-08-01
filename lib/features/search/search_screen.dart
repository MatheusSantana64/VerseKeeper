import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) => _ResultTile(
                              entity: list[index],
                            ),
                          ),
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
