import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/relationship.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('graph renders characters and navigates on tap', (tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      relationships: const [
        Relationship(otherCharacterId: 'char-rin', type: RelationshipType.mentor),
      ],
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final rin = Character(
      id: 'char-rin',
      name: 'Rin',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final database = await seededDatabase([haru, rin]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/graph'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Relationship graph'), findsOneWidget);
    expect(find.text('Haru'), findsOneWidget);
    expect(find.text('Rin'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    await tester.tap(find.text('Haru'));
    await tester.pumpAndSettle();

    expect(find.text('Character'), findsOneWidget);

    await unmountTestApp(tester);
  });

  testWidgets('graph shows an empty hint when nothing is connected',
      (tester) async {
    final database = await seededDatabase([
      Character(
        id: 'char-haru',
        name: 'Haru',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      ),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/graph'),
    );
    await tester.pumpAndSettle();

    expect(find.text('No relationships yet'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
