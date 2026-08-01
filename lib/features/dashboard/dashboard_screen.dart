import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/encryption/encryption_providers.dart';
import '../../core/models/entity_type.dart';
import '../app_shell/app_drawer.dart';
import '../entity/entity_library_providers.dart';
import '../entity/entity_type_config.dart';

/// Landing screen: encryption status + per-type library counts.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasKey = ref.watch(_hasMasterKeyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('VerseKeeper')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (hasKey.hasValue)
            _EncryptionBanner(hasMasterKey: hasKey.value == true)
          else if (hasKey.hasError)
            const _EncryptionBanner(hasMasterKey: false),
          Text(
            'Your library',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final type in primaryEntityTypes)
                _EntityCountCard(
                  type: type,
                  count: ref.watch(entityCountProvider(type)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EncryptionBanner extends StatelessWidget {
  const _EncryptionBanner({required this.hasMasterKey});

  final bool hasMasterKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = hasMasterKey
        ? null
        : theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4);
    final text = hasMasterKey
        ? 'Encryption ready'
        : 'First run: encryption will be provisioned on first save';
    return Card(
      color: style,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          hasMasterKey ? Icons.lock_outline : Icons.lock_open_outlined,
        ),
        title: Text(text, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}

class _EntityCountCard extends StatelessWidget {
  const _EntityCountCard({required this.type, required this.count});

  final EntityType type;
  final AsyncValue<int> count;

  @override
  Widget build(BuildContext context) {
    final config = configOf(type);
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go('/library/${type.name}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(config.icon, color: theme.colorScheme.primary),
                    const Spacer(),
                    Text(
                      count.value?.toString() ?? '…',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(config.label, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _hasMasterKeyProvider = FutureProvider<bool>((ref) {
  return ref.watch(encryptionServiceProvider).hasMasterKey();
});
