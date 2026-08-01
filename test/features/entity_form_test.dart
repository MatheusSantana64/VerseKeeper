import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/character_version.dart';
import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/core/models/story.dart';
import 'package:versekeeper/core/models/timeline_event.dart';
import 'package:versekeeper/features/entity/entity_form_spec.dart';
import 'package:versekeeper/features/entity/entity_actions.dart';

void main() {
  test('every entity type has a form spec with a required display-name field',
      () {
    for (final type in EntityType.values) {
      final specs = entityFormSpecs[type];
      expect(specs, isNotNull, reason: 'missing form spec for $type');
      final hasRequiredName = specs!.any(
        (spec) => spec.required && spec.kind == FormFieldKind.text,
      );
      expect(hasRequiredName, isTrue,
          reason: 'no required text display-name field for $type');
    }
  });

  group('entityFromJson builds valid models from minimal create JSON', () {
    String iso(int year, int month, int day) =>
        DateTime.utc(year, month, day).toIso8601String();

    test('character fills list defaults', () {
      final entity = entityFromJson(EntityType.character, {
        'id': 'c1',
        'name': 'Haru',
        'createdAt': iso(2024, 1, 1),
        'updatedAt': iso(2024, 1, 2),
      }) as Character;
      expect(entity.name, 'Haru');
      expect(entity.aliases, isEmpty);
      expect(entity.tags, isEmpty);
      expect(entity.relationships, isEmpty);
      expect(entity.universeIds, isEmpty);
    });

    test('character version requires a character reference', () {
      final entity = entityFromJson(EntityType.characterVersion, {
        'id': 'v1',
        'characterId': 'c1',
        'name': 'Princess',
        'createdAt': iso(2024, 1, 3),
        'updatedAt': iso(2024, 1, 3),
      }) as CharacterVersion;
      expect(entity.characterId, 'c1');
      expect(entity.name, 'Princess');
      expect(entity.personality, isNull);
      expect(entity.tags, isEmpty);
    });

    test('story uses title', () {
      final entity = entityFromJson(EntityType.story, {
        'id': 's1',
        'title': 'Crown of Ashes',
        'createdAt': iso(2024, 2, 1),
        'updatedAt': iso(2024, 2, 2),
      }) as Story;
      expect(entity.title, 'Crown of Ashes');
      expect(entity.genres, isEmpty);
      expect(entity.appearances, isEmpty);
    });

    test('timeline event defaults sort order to zero', () {
      final entity = entityFromJson(EntityType.timelineEvent, {
        'id': 't1',
        'title': 'Fall of the capital',
        'createdAt': iso(2024, 3, 1),
        'updatedAt': iso(2024, 3, 1),
      }) as TimelineEvent;
      expect(entity.title, 'Fall of the capital');
      expect(entity.sortOrder, 0);
    });

    test('universe builds from name only', () {
      final entity =
          entityFromJson(EntityType.universe, {
            'id': 'u1',
            'name': 'Eryndor',
            'createdAt': iso(2024, 4, 1),
            'updatedAt': iso(2024, 4, 1),
          });
      expect(entity.entityType, EntityType.universe);
      expect(entity.toJson()['name'], 'Eryndor');
      expect(entity.toJson()['characterIds'], isEmpty);
    });
  });
}
