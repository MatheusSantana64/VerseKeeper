import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../utils/base32.dart';
import 'encryption_service.dart';
import 'key_storage.dart';

/// [EncryptionService] implementation using AES-256-GCM.
///
/// Design:
///  * A single random 256-bit master key is kept in [KeyStorage] (platform
///    secure storage in production).
///  * Every value is encrypted with a fresh random 96-bit nonce; nonce and the
///    GCM authentication tag are stored alongside the ciphertext so values
///    can be decrypted independently (no key rotation bulk re-encryption
///    needed to read a single field).
///  * The master key can be exported/restored via a base32 [recovery code].
///
/// Ciphertext string format: `v1.<base64url(nonce || ciphertext || tag)>`.
/// The `v1` prefix enables future algorithm migrations without breaking old
/// data.
class AesGcmEncryptionService implements EncryptionService {
  AesGcmEncryptionService(this._keyStorage);

  static const String _versionPrefix = 'v1';
  static const String _keyStorageName = 'encryption.master_key';
  static const String _recoveryCodePrefix = 'VK';
  static const int _keyLengthBytes = 32;
  static const int _nonceLengthBytes = 12;
  static const int _macLengthBytes = 16;

  final KeyStorage _keyStorage;
  final AesGcm _aesGcm = AesGcm.with256bits();
  final Random _random = Random.secure();

  // ------------------------------------------------------------------------
  // EncryptionService
  // ------------------------------------------------------------------------

  @override
  Future<String> encryptString(String plaintext) async {
    final blob = await _encrypt(utf8.encode(plaintext));
    return '$_versionPrefix.${_encodeBlob(blob)}';
  }

  @override
  Future<String> decryptString(String ciphertext) async {
    final blob = await _decrypt(_decodeCiphertext(ciphertext));
    return utf8.decode(blob);
  }

  @override
  Future<Uint8List> encryptBytes(Uint8List plaintext) async {
    final blob = await _encrypt(plaintext);
    return Uint8List.fromList(utf8.encode('$_versionPrefix.${_encodeBlob(blob)}'));
  }

  @override
  Future<Uint8List> decryptBytes(Uint8List ciphertext) async {
    final blob =
        await _decrypt(_decodeCiphertext(utf8.decode(ciphertext)));
    return Uint8List.fromList(blob);
  }

  @override
  Future<bool> hasMasterKey() async =>
      await _keyStorage.read(_keyStorageName) != null;

  @override
  Future<String> generateRecoveryCode() async {
    final keyBytes = await _ensureMasterKey().then((k) => k.extractBytes());
    final checksum = _fnv1a16(keyBytes);
    final payload = <int>[...keyBytes, (checksum >> 8) & 0xff, checksum & 0xff];
    final encoded = base32Encode(payload);
    final grouped = _group(encoded, 5);
    return '$_recoveryCodePrefix-$grouped';
  }

  @override
  Future<void> recoverMasterKey(String recoveryCode) async {
    final normalized = recoveryCode
        .trim()
        .toUpperCase()
        .replaceAll('-', '')
        .replaceAll(' ', '');
    if (!normalized.startsWith(_recoveryCodePrefix)) {
      throw FormatException('Not a valid recovery code.');
    }
    final payload = base32Decode(normalized.substring(_recoveryCodePrefix.length));
    if (payload.length != _keyLengthBytes + 2) {
      throw FormatException('Recovery code has the wrong length.');
    }
    final keyBytes = payload.sublist(0, _keyLengthBytes);
    final expectedChecksum =
        ((payload[_keyLengthBytes] << 8) | payload[_keyLengthBytes + 1]) & 0xffff;
    if (_fnv1a16(keyBytes) != expectedChecksum) {
      throw FormatException('Recovery code checksum mismatch.');
    }
    await _keyStorage.write(_keyStorageName, base64Encode(keyBytes));
  }

  // ------------------------------------------------------------------------
  // Internals
  // ------------------------------------------------------------------------

  Future<SecretKey> _ensureMasterKey() async {
    final stored = await _keyStorage.read(_keyStorageName);
    if (stored != null && stored.isNotEmpty) {
      return SecretKey(base64Decode(stored));
    }
    final key = SecretKey(_randomKeyBytes());
    await _keyStorage.write(_keyStorageName, base64Encode(await key.extractBytes()));
    return key;
  }

  List<int> _randomKeyBytes() =>
      List<int>.generate(_keyLengthBytes, (_) => _random.nextInt(256));

  Future<List<int>> _encrypt(List<int> plaintext) async {
    final box = await _aesGcm.encrypt(
      plaintext,
      secretKey: await _ensureMasterKey(),
    );
    return [...box.nonce, ...box.cipherText, ...box.mac.bytes];
  }

  Future<List<int>> _decrypt(List<int> blob) async {
    if (blob.length < _nonceLengthBytes + _macLengthBytes) {
      throw FormatException('Ciphertext too short.');
    }
    final nonce = blob.sublist(0, _nonceLengthBytes);
    final macStart = blob.length - _macLengthBytes;
    final cipherText = blob.sublist(_nonceLengthBytes, macStart);
    final mac = Mac(blob.sublist(macStart));

    final box = SecretBox(
      cipherText,
      nonce: nonce,
      mac: mac,
    );
    return _aesGcm.decrypt(box, secretKey: await _ensureMasterKey());
  }

  String _encodeBlob(List<int> blob) =>
      base64UrlEncode(blob).replaceAll('=', '');

  List<int> _decodeCiphertext(String ciphertext) {
    final separator = ciphertext.indexOf('.');
    if (separator <= 0 ||
        ciphertext.substring(0, separator) != _versionPrefix) {
      throw FormatException('Unknown ciphertext version prefix.');
    }
    return base64Url.decode(base64Url.normalize(ciphertext.substring(separator + 1)));
  }

  /// 16-bit FNV-1a checksum used to catch transcription errors in recovery
  /// codes before the key is overwritten.
  int _fnv1a16(List<int> bytes) {
    var hash = 0x811c;
    const prime = 0x0101;
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * prime) & 0xffff;
    }
    return hash;
  }

  String _group(String value, int groupSize) {
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i += groupSize) {
      if (i > 0) buffer.write('-');
      buffer.write(value.substring(i, (i + groupSize).clamp(0, value.length)));
    }
    return buffer.toString();
  }
}
