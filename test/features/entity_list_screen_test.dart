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
    createdAt: DateTime.utc(2024, 2, 1),
    updatedAt: DateTime.utc(2024, 2, 2),
  );

  testWidgets('lists only entities of the selected type', (tester) async {
    final database = await seededDatabase([haru, crown]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/character'));
    await tester.pumpAndSettle();

    expect(find.text('Haru'), findsOneWidget);
    expect(find.textContaining('Swordfighter of the north.'), findsOneWidget);
    expect(find.textContaining('Notes:'), findsOneWidget);
    expect(find.text('Crown of Ashes'), findsNothing);

    await unmountTestApp(tester);
  });

  testWidgets('navigates from the drawer to a story list', (tester) async {
    final database = await seededDatabase([haru, crown]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/story'));
    await tester.pumpAndSettle();

    expect(find.text('Crown of Ashes'), findsOneWidget);
    expect(find.text('Haru'), findsNothing);

    await unmountTestApp(tester);
  });

  testWidgets('drilling into a detail shows a back button that returns',
      (tester) async {
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Haru'));
    await tester.pumpAndSettle();

    final backButton = find.byType(BackButton);
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('Haru'), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);

    await unmountTestApp(tester);
  });

  testWidgets('character tiles show all populated fields', (tester) async {
    final database = await seededDatabase([
      Character(
        id: 'char-haru',
        name: 'Haru',
        profession: 'Swordfighter',
        age: '34',
        race: 'Human',
        faction: 'Northern Alliance',
        description: 'A tall wanderer with a long and detailed backstory.',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Haru'), findsOneWidget);
    expect(find.textContaining('Profession: Swordfighter'), findsOneWidget);
    expect(find.textContaining('Age: 34'), findsOneWidget);
    expect(find.textContaining('Race: Human'), findsOneWidget);
    expect(find.textContaining('Faction: Northern Alliance'), findsOneWidget);
    expect(
      find.textContaining('A tall wanderer with a long and detailed backstory.'),
      findsOneWidget,
    );

    await unmountTestApp(tester);
  });

  testWidgets('shows an empty state for untouched types', (tester) async {
    final database = await seededDatabase([]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/location'));
    await tester.pumpAndSettle();

    expect(find.text('No locations yet'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
