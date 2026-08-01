import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/relationship.dart';

import '../support/app_harness.dart';

void main() {
  Character haru({List<Relationship> relationships = const []}) => Character(
        id: 'char-haru',
        name: 'Haru',
        relationships: relationships,
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      );

  testWidgets('tapping a relationship tile opens the target character',
      (tester) async {
    final database = await seededDatabase([
      haru(relationships: const [
        Relationship(otherCharacterId: 'char-rin', type: RelationshipType.mentor),
      ]),
      Character(
        id: 'char-rin',
        name: 'Rin',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      ),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rin'), findsOneWidget);
    await tester.tap(find.text('Rin'));
    await tester.pumpAndSettle();

    expect(find.text('Haru'), findsNothing);
    expect(find.text('Relationships'), findsNothing);

    await unmountTestApp(tester);
  });

  testWidgets('a reference to a deleted character shows a placeholder',
      (tester) async {
    final database = await seededDatabase([
      haru(relationships: const [
        Relationship(
          otherCharacterId: 'char-gone',
          type: RelationshipType.ally,
        ),
      ]),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    expect(find.text('(deleted)'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
