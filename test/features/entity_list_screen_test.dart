import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/story.dart';
import 'package:versekeeper/features/entity/entity_image_providers.dart';

import '../support/app_harness.dart';

void main() {
  final haru = Character(
    id: 'char-haru',
    name: 'Haru',
    description: 'Swordfighter of the north.',
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

  testWidgets('character tiles show name, age, profession and description', (tester) async {
    final database = await seededDatabase([
      Character(
        id: 'char-haru',
        name: 'Haru',
        profession: 'Swordfighter',
        age: '34',
        race: 'Human',
        description: 'A tall wanderer with a long and detailed backstory.',
        tags: const ['wanderer'],
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character'),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Haru (34yo) - Swordfighter'),
      findsOneWidget,
    );
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

  testWidgets('default layout uses compact cards at the default size',
      (tester) async {
    final database = await seededDatabase([haru, crown]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/character'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('compactCharacterCard')), findsOneWidget);
    expect(find.byKey(const ValueKey('galleryCharacterCard')), findsNothing);
    final card =
        tester.widget<SizedBox>(find.byKey(const ValueKey('characterCard_0')));
    expect(card.width, closeTo(380, 0.1));
    expect(card.height, closeTo(120, 0.1));

    // Compact defaults to showing the whole photo (aspect-preserving).
    final cover = tester.widget<CoverImage>(find.byType(CoverImage));
    expect(cover.fill, isFalse);
    expect(cover.fixedHeight, closeTo(108, 0.1));

    await unmountTestApp(tester);
  });

  Future<void> pickLayout(WidgetTester tester, String label) async {
    await tester.tap(find.byTooltip('Layout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();
  }

  testWidgets('layout dialog switches between card layouts', (tester) async {
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/character'));
    await tester.pumpAndSettle();

    await pickLayout(tester, 'Portrait');
    expect(find.byKey(const ValueKey('portraitCharacterCard')), findsOneWidget);
    expect(find.byKey(const ValueKey('compactCharacterCard')), findsNothing);

    await pickLayout(tester, 'Gallery');
    expect(find.byKey(const ValueKey('galleryCharacterCard')), findsOneWidget);
    expect(find.byKey(const ValueKey('portraitCharacterCard')), findsNothing);

    await unmountTestApp(tester);
  });

  testWidgets('size and font sliders change the cards', (tester) async {
    final database = await seededDatabase([haru, crown]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/character'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Layout'));
    await tester.pumpAndSettle();

    // Drag each slider to the far right (max values).
    await tester.drag(
      find.byKey(const ValueKey('cardWidthSlider')),
      const Offset(400, 0),
    );
    await tester.drag(
      find.byKey(const ValueKey('cardHeightSlider')),
      const Offset(400, 0),
    );
    await tester.drag(
      find.byKey(const ValueKey('fontSizeSlider')),
      const Offset(400, 0),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();

    final card =
        tester.widget<SizedBox>(find.byKey(const ValueKey('characterCard_0')));
    expect(card.width, closeTo(800, 0.1));
    expect(card.height, closeTo(360, 0.1));

    final title = tester.widget<Text>(find.text('Haru'));
    expect(title.style?.fontSize, closeTo(24, 0.1));

    await unmountTestApp(tester);
  });

  testWidgets('each layout keeps its own size settings', (tester) async {
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/character'));
    await tester.pumpAndSettle();

    // Portrait starts from its own default height.
    await pickLayout(tester, 'Portrait');
    var card = tester
        .widget<SizedBox>(find.byKey(const ValueKey('characterCard_0')));
    expect(card.width, closeTo(380, 0.1));
    expect(card.height, closeTo(160, 0.1));

    // Enlarge the portrait width to the max.
    await tester.tap(find.byTooltip('Layout'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const ValueKey('cardWidthSlider')),
      const Offset(400, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();

    card = tester
        .widget<SizedBox>(find.byKey(const ValueKey('characterCard_0')));
    expect(card.width, closeTo(800, 0.1));

    // Switching back to compact keeps its own (default) size.
    await pickLayout(tester, 'Compact');
    card = tester
        .widget<SizedBox>(find.byKey(const ValueKey('characterCard_0')));
    expect(card.width, closeTo(380, 0.1));
    expect(card.height, closeTo(120, 0.1));

    await unmountTestApp(tester);
  });

  testWidgets('whole-image checkbox toggles the gallery photo fit',
      (tester) async {
    final database = await seededDatabase([haru]);
    addTearDown(database.close);

    await tester.pumpWidget(buildTestApp(database, initialLocation: '/library/character'));
    await tester.pumpAndSettle();

    await pickLayout(tester, 'Gallery');

    // Gallery defaults to cropping the photo to fill the card.
    var image = tester.widget<CoverImage>(find.byType(CoverImage));
    expect(image.fill, isTrue);
    expect(image.fillFit, BoxFit.cover);

    await tester.tap(find.byTooltip('Layout'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('wholeImageCheckbox')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('wholeImageCheckbox')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();

    image = tester.widget<CoverImage>(find.byType(CoverImage));
    expect(image.fill, isTrue);
    expect(image.fillFit, BoxFit.contain);

    await unmountTestApp(tester);
  });
}
