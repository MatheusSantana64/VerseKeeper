import 'dart:typed_data';

/// Abstraction over all content encryption.
///
/// The rest of the app (repositories, sync engine) must go through this
/// interface so that:
///   * encryption/decryption is never scattered through the codebase,
///   * the implementation (algorithm, key derivation) can be swapped or
///     versioned without touching callers,
///   * tests can substitute a fake.
///
/// All methods return values that are safe to persist or transmit. Callers
/// treat the returned strings as opaque blobs.
abstract interface class EncryptionService {
  /// Encrypts a UTF-8 string into an opaque, versioned blob.
  Future<String> encryptString(String plaintext);

  /// Decrypts a blob previously produced by [encryptString].
  Future<String> decryptString(String ciphertext);

  /// Encrypts arbitrary bytes (e.g. an image) into an opaque blob.
  Future<Uint8List> encryptBytes(Uint8List plaintext);

  /// Decrypts a blob previously produced by [encryptBytes].
  Future<Uint8List> decryptBytes(Uint8List ciphertext);

  /// Whether a master key already exists for this installation.
  Future<bool> hasMasterKey();

  /// Generates a human-transcribable recovery code for the current master key.
  ///
  /// The recovery code encodes the master key and is the only way to restore
  /// data after a reinstall or if secure storage is wiped. Print it once and
  /// keep it somewhere safe.
  Future<String> generateRecoveryCode();

  /// Replaces the current master key with the one encoded in [recoveryCode].
  ///
  /// Throws [FormatException] if the code is malformed or its checksum fails.
  Future<void> recoverMasterKey(String recoveryCode);
}
