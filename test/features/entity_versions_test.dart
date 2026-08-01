import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/character_version.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('character detail lists versions and pre-fills a new one',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final princess = CharacterVersion(
      id: 'ver-princess',
      characterId: 'char-haru',
      name: 'Princess',
      createdAt: DateTime.utc(2024, 2, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );
    final database = await seededDatabase([haru, princess]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Versions'), findsOneWidget);
    expect(find.text('Princess'), findsOneWidget);

    await tester.tap(find.text('New version'));
    await tester.pumpAndSettle();

    expect(find.text('New Character version'), findsOneWidget);
    expect(find.text('Haru'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('version form hints at inherited values from the base',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      personality: 'kind',
      notes: 'base notes',
      tags: const ['sword'],
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(
        database,
        initialLocation:
            '/library/characterVersion/new?characterId=char-haru',
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Leave a field empty to inherit it from Haru.'),
      findsOneWidget,
    );
    expect(find.textContaining('Inherits: kind'), findsOneWidget);
    expect(find.textContaining('Inherits: base notes'), findsOneWidget);
    expect(find.textContaining('Inherits: sword'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('editing a version hints at un-overridden inherited values',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      personality: 'kind',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final princess = CharacterVersion(
      id: 'ver-princess',
      characterId: 'char-haru',
      name: 'Princess',
      createdAt: DateTime.utc(2024, 2, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );
    final database = await seededDatabase([haru, princess]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(
        database,
        initialLocation: '/library/characterVersion/ver-princess/edit',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit Character version'), findsOneWidget);
    expect(
      find.text('Leave a field empty to inherit it from Haru.'),
      findsOneWidget,
    );
    expect(find.textContaining('Inherits: kind'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('version detail renders the resolved snapshot from the base',
      (tester) async {
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      personality: 'kind',
      notes: 'base notes',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final princess = CharacterVersion(
      id: 'ver-princess',
      characterId: 'char-haru',
      name: 'Princess',
      personality: 'noble',
      createdAt: DateTime.utc(2024, 2, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );
    final database = await seededDatabase([haru, princess]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(
        database,
        initialLocation: '/library/characterVersion/ver-princess',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Resolved snapshot'), findsOneWidget);
    expect(find.textContaining('Name: Princess'), findsOneWidget);
    expect(find.textContaining('Personality: noble'), findsOneWidget);
    expect(find.textContaining('Notes: base notes'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
