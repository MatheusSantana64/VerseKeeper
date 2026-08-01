import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/encryption/encryption_providers.dart';

/// Temporary landing screen.
///
/// Replaced by a real dashboard (and go_router shell) in the UI phase. For
/// now it surfaces whether the encryption key is provisioned, which is the
/// first real dependency of the app.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasKey = ref.watch(_hasMasterKeyProvider);

    final Widget statusWidget;
    if (hasKey.isLoading) {
      statusWidget = const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    } else if (hasKey.hasError) {
      statusWidget = Text(
        'Encryption not ready.',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    } else {
      statusWidget = Text(
        hasKey.value == true
            ? 'Encryption ready'
            : 'First run: encryption will be provisioned on first save',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('VerseKeeper')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_stories_outlined, size: 72),
            const SizedBox(height: 16),
            Text(
              'Welcome to VerseKeeper',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            statusWidget,
          ],
        ),
      ),
    );
  }
}

final _hasMasterKeyProvider = FutureProvider<bool>((ref) {
  return ref.watch(encryptionServiceProvider).hasMasterKey();
});
