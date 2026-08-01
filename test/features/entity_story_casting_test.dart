import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/character_version.dart';
import 'package:versekeeper/core/models/story.dart';
import 'package:versekeeper/core/models/story_appearance.dart';

import '../support/app_harness.dart';

void main() {
  Character rin() => Character(
        id: 'char-rin',
        name: 'Rin',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      );

  CharacterVersion princessVersion() => CharacterVersion(
        id: 'ver-princess',
        characterId: 'char-rin',
        name: 'Princess',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      );

  testWidgets('creates a story with a pinned character appearance',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final database = await seededDatabase([rin(), princessVersion()]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/story/new'),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Crown of Ashes',
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add appearance'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rin').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Princess').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Role'),
      'antagonist',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    expect(find.text('Crown of Ashes'), findsWidgets);
    expect(find.text('Appearances'), findsOneWidget);
    expect(find.textContaining('Rin'), findsWidgets);
    expect(find.textContaining('Princess'), findsWidgets);
    expect(find.textContaining('antagonist'), findsWidgets);

    await unmountTestApp(tester);
  });

  testWidgets('character detail lists the stories it appears in',
      (tester) async {
    final story = Story(
      id: 'story-crown',
      title: 'Crown of Ashes',
      appearances: const [
        StoryAppearance(characterId: 'char-rin', role: 'antagonist'),
      ],
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final database = await seededDatabase([rin(), story]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-rin'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Crown of Ashes'), findsWidgets);

    await unmountTestApp(tester);
  });
}
