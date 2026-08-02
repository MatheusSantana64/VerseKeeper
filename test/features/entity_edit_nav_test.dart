import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('tapping Edit on a character detail opens the edit form',
      (tester) async {
    final character = Character(
      id: 'char-1',
      name: 'Haru',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    final database = await seededDatabase([character]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(
      database,
      initialLocation: '/library/character/char-1',
    ));
    await tester.pumpAndSettle();

    expect(find.text('Haru'), findsWidgets);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Edit Character'), findsOneWidget);
    expect(find.text('Haru'), findsWidgets);
    expect(find.text('Name'), findsWidgets);

    await unmountTestApp(tester);
  });
}
