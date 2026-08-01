import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:versekeeper/app.dart';
import 'package:versekeeper/core/encryption/encryption_providers.dart';
import 'package:versekeeper/core/models/stored_entity.dart';
import 'package:versekeeper/data/local/app_database.dart';
import 'package:versekeeper/data/local/entities_dao.dart';
import 'package:versekeeper/data/local/local_providers.dart';
import 'package:versekeeper/features/router/app_router.dart';

import 'fakes.dart';

/// In-memory database pre-seeded with [entities].
Future<AppDatabase> seededDatabase(List<StoredEntity> entities) async {
  final database = AppDatabase.forTesting();
  final dao = EntitiesDao(database);
  for (final entity in entities) {
    await dao.upsert(entity);
  }
  return database;
}

/// Pumps the full app with a real router (starting at [initialLocation]) and
/// overridden storage/database. Caller owns closing [database].
Widget buildTestApp(AppDatabase database, {String initialLocation = '/'}) {
  return ProviderScope(
    overrides: [
      keyStorageProvider.overrideWithValue(InMemoryKeyStorage()),
      databaseProvider.overrideWithValue(database),
      goRouterProvider
          .overrideWithValue(buildAppRouter(initialLocation: initialLocation)),
    ],
    child: const VerseKeeperApp(),
  );
}

/// Unmounts the app tree and advances the fake clock so drift's
/// stream-cache `Timer.run` fires before the test framework's "no pending
/// timers" invariant check. Call at the end of widget tests that read drift
/// streams.
Future<void> unmountTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

