import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:versekeeper/app.dart';
import 'package:versekeeper/core/encryption/encryption_providers.dart';

import 'support/fakes.dart';

void main() {
  testWidgets('renders the home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyStorageProvider.overrideWithValue(InMemoryKeyStorage()),
        ],
        child: const VerseKeeperApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to VerseKeeper'), findsOneWidget);
  });
}
