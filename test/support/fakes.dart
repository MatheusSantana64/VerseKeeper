import 'package:versekeeper/core/encryption/key_storage.dart';

/// In-memory [KeyStorage] for tests.
class InMemoryKeyStorage implements KeyStorage {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}
