import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/story.dart';

import '../support/app_harness.dart';

void main() {
  final haru = Character(
    id: 'char-haru',
    name: 'Haru',
    notes: 'Swordfighter of the north.',
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 2),
  );
  final crown = Story(
    id: 'story-crown',
    title: 'Crown of Ashes',
    summary: 'A royal tragedy in three acts.',
    createdAt: DateTime.utc(2024, 2, 1),
    updatedAt: DateTime.utc(2024, 2, 2),
  );

  testWidgets('search finds matches across entity types', (tester) async {
    final database = await seededDatabase([haru, crown]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'sword');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Haru'), findsOneWidget);
    expect(find.text('Crown of Ashes'), findsNothing);

    await tester.enterText(find.byType(TextField), 'crown');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Crown of Ashes'), findsOneWidget);
    expect(find.text('Haru'), findsNothing);

    await unmountTestApp(tester);
  });

  testWidgets('search groups results by type with a count', (tester) async {
    final emberHaru = Character(
      id: 'char-ember',
      name: 'Haru',
      notes: 'Carries the ember blade.',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 2),
    );
    final emberStory = Story(
      id: 'story-ember',
      title: 'Ember Crown',
      summary: 'A tale of ember and ash.',
      createdAt: DateTime.utc(2024, 2, 1),
      updatedAt: DateTime.utc(2024, 2, 2),
    );
    final database = await seededDatabase([emberHaru, emberStory]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'ember');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('2 results'), findsOneWidget);
    expect(find.text('Characters'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Haru'), findsOneWidget);
    expect(find.text('Ember Crown'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('search shows a hint before a query is typed', (tester) async {
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/search'));
    await tester.pumpAndSettle();

    expect(find.text('Type to search your entire library.'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
