import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:versekeeper/core/images/image_store.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('cover_image_store_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  test('saves, resolves, and deletes cover images', () async {
    final store = ImageStore(overrideDirectory: tempDir);

    final name = await store.saveImage('abc', Uint8List.fromList([1, 2, 3]));
    expect(name, 'abc.png');

    final path = await store.pathFor('abc.png');
    expect(path, isNotNull);
    expect(File(path!).readAsBytesSync(), [1, 2, 3]);

    expect(await store.pathFor('missing.png'), isNull);

    await store.deleteImage('abc.png');
    expect(await store.pathFor('abc.png'), isNull);
  });

  test('deleteImage is a no-op for missing files', () async {
    final store = ImageStore(overrideDirectory: tempDir);
    await store.deleteImage('never-was.png');
    expect(await store.pathFor('never-was.png'), isNull);
  });
}
