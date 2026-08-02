import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/images/image_store.dart';
import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/features/entity/entity_image_providers.dart';

import '../support/app_harness.dart';

/// 1x1 transparent PNG.
const _kTransparentPng = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

class _PathImageStore extends ImageStore {
  final String path;
  _PathImageStore(this.path);

  @override
  Future<String> saveImage(String id, List<int> bytes) async => '';

  @override
  Future<String?> pathFor(String fileName) async => path;

  @override
  Future<void> deleteImage(String fileName) async {}
}

void main() {
  testWidgets('preview opens a fullscreen zoomable dialog and closes',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    late String imagePath;
    await tester.runAsync(() async {
      final directory = await Directory.systemTemp.createTemp('cover_preview');
      final file = File('${directory.path}/cover.png');
      await file.writeAsBytes(_kTransparentPng);
      imagePath = file.path;
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showCoverImagePreview(context, imagePath),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(InteractiveViewer), findsNothing);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets('only cards with a photo wire a tap to open the preview',
      (tester) async {
    final database = await seededDatabase([
      Character(
        id: 'char-haru',
        name: 'Haru',
        coverImageId: 'cover.png',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
      Character(
        id: 'char-yuki',
        name: 'Yuki',
        createdAt: DateTime.utc(2024, 1, 3),
        updatedAt: DateTime.utc(2024, 1, 4),
      ),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(
      database,
      initialLocation: '/library/character',
      overrides: [
        imageStoreProvider.overrideWithValue(_PathImageStore('C:/fake/cover.png')),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CoverImage), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(CoverImage),
        matching: find.byType(GestureDetector),
      ),
      findsOneWidget,
    );

    await unmountTestApp(tester);
  });
}
