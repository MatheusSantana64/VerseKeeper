import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/character_version.dart';
import 'package:versekeeper/core/models/relationship.dart';

void main() {
  final base = Character(
    id: 'haru',
    name: 'Haru',
    aliases: ['H'],
    tags: ['core'],
    personality: 'kind',
    appearance: 'tall',
    notes: 'base notes',
    speechStyle: 'soft',
    aiPrompt: 'core prompt',
    versionIds: ['v1'],
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 1),
  );

  group('Character JSON', () {
    test('round trips through json', () {
      final restored = Character.fromJson(base.toJson());
      expect(restored, base);
    });

    test('fromJson fills list defaults', () {
      final restored = Character.fromJson({
        'id': 'x',
        'name': 'X',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      });
      expect(restored.aliases, isEmpty);
      expect(restored.tags, isEmpty);
      expect(restored.relationships, isEmpty);
    });
  });

  group('Character.resolve', () {
    test('overrides explicit fields and inherits null ones', () {
      final version = CharacterVersion(
        id: 'v1',
        characterId: 'haru',
        name: 'Princess',
        personality: 'noble',
        storyIds: ['s1'],
        createdAt: DateTime.utc(2024, 2, 1),
        updatedAt: DateTime.utc(2024, 2, 1),
      );

      final resolved = base.resolve(version);

      expect(resolved.name, 'Princess');
      expect(resolved.personality, 'noble');
      expect(resolved.appearance, 'tall');
      expect(resolved.notes, 'base notes');
      expect(resolved.aiPrompt, 'core prompt');
      expect(resolved.storyIds, ['s1']);
      expect(resolved.tags, ['core']);
    });

    test('inherits base image ids when version has none', () {
      final baseWithImages = base.copyWith(imageIds: ['img1']);
      final version = CharacterVersion(
        id: 'v1',
        characterId: 'haru',
        name: 'Princess',
        createdAt: DateTime.utc(2024, 2, 1),
        updatedAt: DateTime.utc(2024, 2, 1),
      );

      expect(baseWithImages.resolve(version).imageIds, ['img1']);
    });
  });

  group('Relationship', () {
    test('stores directional relationship with json round trip', () {
      const rel = Relationship(
        otherCharacterId: 'other',
        type: RelationshipType.mentor,
        notes: 'taught swordsmanship',
      );
      final restored = Relationship.fromJson(rel.toJson());
      expect(restored, rel);
    });

    test('inverse mapping is symmetric', () {
      expect(RelationshipType.mentor.inverse, RelationshipType.student);
      expect(RelationshipType.student.inverse, RelationshipType.mentor);
      expect(RelationshipType.parent.inverse, RelationshipType.child);
      expect(RelationshipType.spouse.inverse, RelationshipType.spouse);
    });
  });
}
