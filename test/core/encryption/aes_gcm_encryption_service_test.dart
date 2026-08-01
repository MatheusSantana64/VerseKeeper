import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/encryption/aes_gcm_encryption_service.dart';

import '../../support/fakes.dart';

void main() {
  late InMemoryKeyStorage storage;
  late AesGcmEncryptionService service;

  setUp(() {
    storage = InMemoryKeyStorage();
    service = AesGcmEncryptionService(storage);
  });

  group('string encryption', () {
    test('round trips', () async {
      const plaintext = 'this is a secret story note';
      final ciphertext = await service.encryptString(plaintext);
      expect(ciphertext, startsWith('v1.'));
      expect(ciphertext, isNot(contains('secret')));
      expect(await service.decryptString(ciphertext), plaintext);
    });

    test('uses a fresh nonce per call (no two ciphertexts equal)', () async {
      final a = await service.encryptString('same input');
      final b = await service.encryptString('same input');
      expect(a, isNot(b));
      expect(await service.decryptString(a), await service.decryptString(b));
    });

    test('rejects a tampered blob', () async {
      final ciphertext = await service.encryptString('hello');
      final parts = ciphertext.split('.');
      final data = base64Url.decode(base64Url.normalize(parts[1]));
      data[data.length - 1] ^= 0x01; // flip a mac byte
      final tampered = '${parts[0]}.${base64Url.encode(data).replaceAll('=', '')}';
      await expectLater(service.decryptString(tampered), throwsA(anything));
    });

    test('rejects an unknown version prefix', () async {
      await expectLater(
        service.decryptString('v9.MAY1'),
        throwsFormatException,
      );
    });
  });

  group('byte encryption', () {
    test('round trips arbitrary bytes', () async {
      final data = Uint8List.fromList(List.generate(256, (i) => i));
      final blob = await service.encryptBytes(data);
      expect(await service.decryptBytes(blob), data);
    });
  });

  group('master key persistence', () {
    test('reuses the same key across instances', () async {
      final first = await service.encryptString('persist me');
      final second = AesGcmEncryptionService(storage);
      expect(await second.decryptString(first), 'persist me');
      expect(await second.hasMasterKey(), isTrue);
    });
  });

  group('recovery code', () {
    test('can restore the master key into a fresh install', () async {
      final ciphertext = await service.encryptString('precious data');
      final code = await service.generateRecoveryCode();

      final freshStorage = InMemoryKeyStorage();
      final freshService = AesGcmEncryptionService(freshStorage);
      expect(await freshService.hasMasterKey(), isFalse);

      await freshService.recoverMasterKey(code);
      expect(await freshService.hasMasterKey(), isTrue);
      expect(await freshService.decryptString(ciphertext), 'precious data');
    });

    test('is tolerant of formatting (lowercase, dashes, spaces)', () async {
      final code = await service.generateRecoveryCode();
      final messy = code.toLowerCase().replaceAll('-', ' ');
      final freshService =
          AesGcmEncryptionService(InMemoryKeyStorage());
      await freshService.recoverMasterKey(messy);
      expect(await freshService.hasMasterKey(), isTrue);
    });

    test('rejects a code with a corrupt checksum', () async {
      final code = await service.generateRecoveryCode();
      final lastChar = code.substring(code.length - 1);
      final replacement = lastChar == 'A' ? 'B' : 'A';
      final corrupt = code.substring(0, code.length - 1) + replacement;
      await expectLater(
        service.recoverMasterKey(corrupt),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
