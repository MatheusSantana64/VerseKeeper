import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/utils/base32.dart';

void main() {
  group('base32Encode', () {
    test('RFC 4648 test vectors', () {
      expect(base32Encode(utf8.encode('f')), 'MY');
      expect(base32Encode(utf8.encode('fo')), 'MZXQ');
      expect(base32Encode(utf8.encode('foo')), 'MZXW6');
      expect(base32Encode(utf8.encode('foob')), 'MZXW6YQ');
      expect(base32Encode(utf8.encode('fooba')), 'MZXW6YTB');
      expect(base32Encode(utf8.encode('foobar')), 'MZXW6YTBOI');
    });

    test('empty input', () {
      expect(base32Encode(const []), '');
    });
  });

  group('base32Decode', () {
    test('round trips arbitrary bytes', () {
      final random = Random(42);
      for (var length = 0; length <= 64; length++) {
        final bytes =
            List<int>.generate(length, (_) => random.nextInt(256));
        expect(base32Decode(base32Encode(bytes)), bytes);
      }
    });

    test('accepts lowercase, dashes and padding', () {
      expect(base32Decode('mzxw6ytboi'), utf8.encode('foobar'));
      expect(base32Decode('MZXW6YTBOI====='), utf8.encode('foobar'));
    });

    test('rejects invalid characters', () {
      expect(() => base32Decode('MZXW61'), throwsFormatException);
    });
  });
}
