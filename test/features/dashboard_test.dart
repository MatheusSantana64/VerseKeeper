import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('dashboard lists recently updated entities', (tester) async {
    final database = await seededDatabase([
      Character(
        id: 'char-haru',
        name: 'Haru',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 5),
      ),
      Character(
        id: 'char-rin',
        name: 'Rin',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 10),
      ),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database));
    await tester.pumpAndSettle();

    expect(find.text('Recently updated'), findsOneWidget);
    expect(find.text('Haru'), findsOneWidget);
    expect(find.text('Rin'), findsOneWidget);

    await unmountTestApp(tester);
  });
}
