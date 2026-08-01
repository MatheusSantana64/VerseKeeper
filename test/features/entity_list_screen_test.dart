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
    expect(find.text('Swordfighter of the north.'), findsOneWidget);
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

  testWidgets('shows an empty state for untouched types', (tester) async {
    final database = await seededDatabase([]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/location'));
    await tester.pumpAndSettle();

    expect(find.text('No locations yet'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
