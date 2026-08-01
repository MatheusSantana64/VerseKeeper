import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  testWidgets('renders the dashboard with library counts', (tester) async {
    final database = await seededDatabase([]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database));
    await tester.pumpAndSettle();

    expect(find.text('Your library'), findsOneWidget);
    expect(find.text('Characters'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('VerseKeeper'), findsWidgets);
    expect(
      find.text('First run: encryption will be provisioned on first save'),
      findsOneWidget,
    );

    await unmountTestApp(tester);
  });
}
