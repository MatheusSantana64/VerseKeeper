import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/character_version.dart';
import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/core/models/relationship.dart';
import 'package:versekeeper/core/models/story.dart';
import 'package:versekeeper/core/models/story_appearance.dart';
import 'package:versekeeper/data/local/entities_dao.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('deleting a character cascades to versions and references',
      (tester) async {
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
      relationships: const [
        Relationship(otherCharacterId: 'char-haru', type: RelationshipType.ally),
      ],
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final princess = CharacterVersion(
      id: 'ver-princess',
      characterId: 'char-haru',
      name: 'Princess',
      createdAt: DateTime.utc(2024, 2, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );
    final story = Story(
      id: 'story-crown',
      title: 'Crown of Ashes',
      appearances: const [
        StoryAppearance(characterId: 'char-haru', versionId: 'ver-princess'),
      ],
      createdAt: DateTime.utc(2024, 2, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );
    final database = await seededDatabase([haru, rin, princess, story]);
    addTearDown(database.close);

    await tester.pumpWidget(
      buildTestApp(database, initialLocation: '/library/character/char-haru'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Characters'), findsOneWidget);
    expect(find.text('Haru'), findsNothing);
    expect(find.text('Rin'), findsOneWidget);

    final dao = EntitiesDao(database);
    final characters = await dao.getAll<Character>(EntityType.character);
    expect(characters.map((c) => c.id), ['char-rin']);
    expect(characters.single.relationships, isEmpty);

    final versions =
        await dao.getAll<CharacterVersion>(EntityType.characterVersion);
    expect(versions, isEmpty);

    final stories = await dao.getAll<Story>(EntityType.story);
    expect(stories.single.appearances, isEmpty);

    await unmountTestApp(tester);
  });
}
