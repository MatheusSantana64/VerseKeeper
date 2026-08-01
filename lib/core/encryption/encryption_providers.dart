import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/id_generator.dart';
import 'aes_gcm_encryption_service.dart';
import 'encryption_service.dart';
import 'key_storage.dart';

/// Injectable [IdGenerator].
final idGeneratorProvider = Provider<IdGenerator>((ref) {
  return const UuidIdGenerator();
});

/// Key storage backed by platform secure storage (Keystore / DPAPI).
final keyStorageProvider = Provider<KeyStorage>((ref) {
  return const SecureStorageKeyStorage(FlutterSecureStorage());
});

/// The app-wide [EncryptionService].
///
/// Override in tests: `encryptionServiceProvider.overrideWithValue(fake)`.
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return AesGcmEncryptionService(ref.watch(keyStorageProvider));
});
