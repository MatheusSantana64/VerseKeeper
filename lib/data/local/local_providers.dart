import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'entities_dao.dart';

/// The app-wide local database. Opened lazily on first read; closed when the
/// provider is disposed. Override in tests with an in-memory database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

/// Type-safe DAO over the local database.
final entitiesDaoProvider = Provider<EntitiesDao>((ref) {
  return EntitiesDao(ref.watch(databaseProvider));
});
