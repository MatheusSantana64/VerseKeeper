import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Minimal key/value storage for secrets such as the encryption master key.
///
/// Abstracted so the encryption service can run in tests (in-memory) and in
/// production (platform secure storage) without knowing which backend it uses.
abstract interface class KeyStorage {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

/// Production backend backed by `flutter_secure_storage`.
///
/// On Android values are protected by the Keystore; on Windows by DPAPI.
class SecureStorageKeyStorage implements KeyStorage {
  const SecureStorageKeyStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
