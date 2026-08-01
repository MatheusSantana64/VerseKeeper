/// RFC 4648 Base32 encoding without padding.
///
/// Used to make encryption recovery codes easy to transcribe: base32 avoids
/// ambiguous characters and is case-insensitive.
library;

const String _base32Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

/// Encodes [bytes] to base32 (no padding).
String base32Encode(List<int> bytes) {
  final buffer = StringBuffer();
  var accumulator = 0;
  var bitCount = 0;

  for (final byte in bytes) {
    accumulator = (accumulator << 8) | (byte & 0xff);
    bitCount += 8;
    while (bitCount >= 5) {
      bitCount -= 5;
      buffer.write(_base32Alphabet[(accumulator >> bitCount) & 0x1f]);
    }
  }
  if (bitCount > 0) {
    buffer.write(_base32Alphabet[(accumulator << (5 - bitCount)) & 0x1f]);
  }
  return buffer.toString();
}

/// Decodes a base32 string (padding optional, case-insensitive) to bytes.
///
/// Throws [FormatException] on invalid input.
List<int> base32Decode(String input) {
  final clean = input
      .toUpperCase()
      .replaceAll('-', '')
      .replaceAll(' ', '')
      .replaceAll('=', '');

  final buffer = <int>[];
  var accumulator = 0;
  var bitCount = 0;

  for (final rune in clean.runes) {
    final char = String.fromCharCode(rune);
    final value = _base32Alphabet.indexOf(char);
    if (value < 0) {
      throw FormatException('Invalid base32 character: "$char"');
    }
    accumulator = (accumulator << 5) | value;
    bitCount += 5;
    if (bitCount >= 8) {
      bitCount -= 8;
      buffer.add((accumulator >> bitCount) & 0xff);
    }
  }
  return buffer;
}
