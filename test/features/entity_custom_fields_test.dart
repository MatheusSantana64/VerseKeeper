import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/field_definition.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets(
      'character form renders custom fields and persists a relationship',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final birthplace = FieldDefinition(
      id: 'def-birthplace',
      name: 'Birthplace',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final rin = Character(
      id: 'char-rin',
      name: 'Rin',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final database = await seededDatabase([birthplace, rin]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/new'),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Haru',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Birthplace'),
      'Eryndor',
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add relationship'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rin').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mentor').last);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    expect(find.text('Birthplace'), findsOneWidget);
    expect(find.text('Eryndor'), findsOneWidget);
    expect(find.text('Rin'), findsOneWidget);
    expect(find.text('Mentor'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('editing a character pre-fills existing custom field values',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final birthplace = FieldDefinition(
      id: 'def-birthplace',
      name: 'Birthplace',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      customFields: {'def-birthplace': 'Eryndor'},
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 2),
    );
    final database = await seededDatabase([birthplace, haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(
        database,
        initialLocation: '/library/character/char-haru/edit',
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Birthplace'),
      ).controller!.text,
      'Eryndor',
    );

    await unmountTestApp(tester);
  });

  testWidgets('deleting a field definition strips its values from characters',
      (tester) async {
    final birthplace = FieldDefinition(
      id: 'def-birthplace',
      name: 'Birthplace',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      customFields: {'def-birthplace': 'Eryndor'},
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final database = await seededDatabase([birthplace, haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(
        database,
        initialLocation: '/library/fieldDefinition/def-birthplace',
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Birthplace'), findsNothing);
    expect(find.text('Eryndor'), findsNothing);

    await unmountTestApp(tester);
  });
}
