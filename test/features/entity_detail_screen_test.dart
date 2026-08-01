import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('shows entity fields on the detail screen', (tester) async {
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      aliases: ['The North Wind'],
      personality: 'Calm and precise.',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 2),
    );
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Haru'), findsWidgets);
    expect(find.text('Personality'), findsOneWidget);
    expect(find.text('Calm and precise.'), findsOneWidget);
    expect(find.text('The North Wind'), findsOneWidget);
    expect(find.text('Character'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('shows a not-found state for unknown ids', (tester) async {
    final database = await seededDatabase([]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/nope'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Not found or deleted'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
