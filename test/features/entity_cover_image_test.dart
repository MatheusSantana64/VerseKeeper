import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/images/cover_image_picker.dart';
import 'package:versekeeper/core/images/image_store.dart';
import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/data/local/entities_dao.dart';
import 'package:versekeeper/features/entity/entity_image_providers.dart';

import '../support/app_harness.dart';

class _FakeCoverImagePicker implements CoverImagePicker {
  final Uint8List bytes;
  _FakeCoverImagePicker(this.bytes);

  @override
  Future<Uint8List?> pick() async => bytes;
}

class _FakeImageStore extends ImageStore {
  final Map<String, Uint8List> files = {};
  final List<String> saved = [];
  final List<String> deleted = [];
  int _seq = 0;

  @override
  Future<String> saveImage(String id, Uint8List bytes) async {
    final fileName = 'cover_${_seq++}.png';
    files[fileName] = bytes;
    saved.add(fileName);
    return fileName;
  }

  @override
  Future<String?> pathFor(String fileName) async => null;

  @override
  Future<void> deleteImage(String fileName) async {
    files.remove(fileName);
    deleted.add(fileName);
  }
}

void main() {
  testWidgets('create form picks, persists, and displays the main photo',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final database = await seededDatabase([]);
    addTearDown(database.close);
    final store = _FakeImageStore();

    await tester.pumpWidget(buildTestApp(
      database,
      initialLocation: '/library/character/new',
      overrides: [
        imageStoreProvider.overrideWithValue(store),
        coverImagePickerProvider
            .overrideWithValue(_FakeCoverImagePicker(Uint8List.fromList([1]))),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Haru');

    await tester.tap(find.widgetWithText(TextButton, 'Add photo'));
    await tester.pumpAndSettle();

    // Picker output was handed to the store, and the form switched to
    // change/remove.
    expect(store.saved, hasLength(1));
    expect(store.files, hasLength(1));
    expect(find.widgetWithText(TextButton, 'Change photo'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Remove'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    // Saved with the stored file name as coverImageId.
    final dao = EntitiesDao(database);
    final haru = (await dao.getAll<Character>(EntityType.character)).single;
    expect(haru.name, 'Haru');
    expect(haru.coverImageId, store.saved.single);

    // Detail shows the character.
    expect(find.text('Haru'), findsWidgets);

    await unmountTestApp(tester);
  });

  testWidgets('removing the photo clears it and deletes the stored file',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final database = await seededDatabase([]);
    addTearDown(database.close);
    final store = _FakeImageStore();

    await tester.pumpWidget(buildTestApp(
      database,
      initialLocation: '/library/character/new',
      overrides: [
        imageStoreProvider.overrideWithValue(store),
        coverImagePickerProvider
            .overrideWithValue(_FakeCoverImagePicker(Uint8List.fromList([1]))),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Haru');

    await tester.tap(find.widgetWithText(TextButton, 'Add photo'));
    await tester.pumpAndSettle();
    expect(store.saved, hasLength(1));

    await tester.tap(find.widgetWithText(TextButton, 'Remove'));
    await tester.pumpAndSettle();

    // Stored file deleted, map cleared, and the form reverts to "Add photo".
    expect(store.deleted, store.saved);
    expect(store.files, isEmpty);
    expect(find.widgetWithText(TextButton, 'Add photo'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
