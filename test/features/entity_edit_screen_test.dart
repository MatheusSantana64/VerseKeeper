import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';

import '../support/app_harness.dart';

void main() {
  Finder nameField() => find.widgetWithText(TextFormField, 'Name');

  testWidgets('creates a character through the form', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final database = await seededDatabase([]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/new'),
    );
    await tester.pumpAndSettle();

    await tester.enterText(nameField(), 'Haru');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Notes'),
      'Swordfighter of the north.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    expect(find.text('Swordfighter of the north.'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('edits an existing character and persists the change',
      (tester) async {
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      personality: 'Calm and precise.',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 2),
    );
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru/edit'),
    );
    await tester.pumpAndSettle();

    await tester.enterText(nameField(), 'Haru v2');
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Haru v2'), findsWidgets);

    await unmountTestApp(tester);
  });

  testWidgets('deletes an entity after confirmation', (tester) async {
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 2),
    );
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('No characters yet'), findsOneWidget);
    expect(find.text('Haru'), findsNothing);

    await unmountTestApp(tester);
  });
}
