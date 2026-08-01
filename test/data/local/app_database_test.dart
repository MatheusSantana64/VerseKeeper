import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/core/models/story.dart';
import 'package:versekeeper/data/local/app_database.dart';
import 'package:versekeeper/data/local/entities_dao.dart';

void main() {
  late AppDatabase database;
  late EntitiesDao dao;

  final haru = Character(
    id: 'haru-1',
    name: 'Haru',
    aliases: ['Princess'],
    tags: ['core', 'heroine'],
    personality: 'kind and stubborn',
    notes: 'Swordfighter trained in the royal court.',
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 2),
  );

  final story = Story(
    id: 'story-1',
    title: 'Crown of Ashes',
    summary: 'A fallen kingdom and its last princess.',
    tags: ['dark fantasy'],
    createdAt: DateTime.utc(2024, 2, 1),
    updatedAt: DateTime.utc(2024, 2, 2),
  );

  setUp(() {
    database = AppDatabase.forTesting();
    dao = EntitiesDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('CRUD', () {
    test('upsert + getById round trips through json', () async {
      await dao.upsert(haru);
      final restored = await dao.getById<Character>(EntityType.character, haru.id);
      expect(restored, haru);
    });

    test('upsert replaces an existing entity', () async {
      await dao.upsert(haru);
      final updated = haru.copyWith(name: 'Haru (final)', personality: 'wiser');
      await dao.upsert(updated);
      final restored =
          await dao.getById<Character>(EntityType.character, haru.id);
      expect(restored?.name, 'Haru (final)');
      expect(restored?.personality, 'wiser');
    });

    test('getById returns null for missing or deleted entities', () async {
      expect(await dao.getById<Character>(EntityType.character, 'nope'), isNull);
      await dao.upsert(haru);
      await dao.softDelete(EntityType.character, haru.id);
      expect(
        await dao.getById<Character>(EntityType.character, haru.id),
        isNull,
      );
    });

    test('hardDelete removes the row entirely', () async {
      await dao.upsert(haru);
      await dao.hardDelete(EntityType.character, haru.id);
      expect(await dao.count(EntityType.character), 0);
      expect(await dao.search('haru'), isEmpty);
    });

    test('count only counts non-deleted entities', () async {
      await dao.upsert(haru);
      await dao.upsert(story);
      expect(await dao.count(EntityType.character), 1);
      await dao.softDelete(EntityType.character, haru.id);
      expect(await dao.count(EntityType.character), 0);
      expect(await dao.count(EntityType.story), 1);
    });
  });

  group('watchAll', () {
    test('emits lists and excludes soft-deleted rows', () async {
      final stream = dao.watchAll<Character>(EntityType.character);
      final seen = <List<Character>>[];

      final sub = stream.listen(seen.add);
      await pumpEventQueue();
      await dao.upsert(haru);
      await pumpEventQueue();

      final another = haru.copyWith(id: 'haru-2', name: 'Haru 2');
      await dao.upsert(another);
      await pumpEventQueue();

      await dao.softDelete(EntityType.character, haru.id);
      await pumpEventQueue();
      await sub.cancel();

      expect(seen.last.map((c) => c.id).toSet(), {'haru-2'});
    });
  });

  group('search', () {
    test('matches name with prefix', () async {
      await dao.upsert(haru);
      final results = await dao.search('har');
      expect(results.map((e) => e.id), contains(haru.id));
    });

    test('matches aliases, tags and notes', () async {
      await dao.upsert(haru);
      expect((await dao.search('princess')).map((e) => e.id), contains(haru.id));
      expect((await dao.search('heroine')).map((e) => e.id), contains(haru.id));
      expect((await dao.search('sword')).map((e) => e.id), contains(haru.id));
    });

    test('AND-combines multiple terms', () async {
      await dao.upsert(haru);
      await dao.upsert(story);
      expect((await dao.search('har princess')).map((e) => e.id), contains(haru.id));
      expect((await dao.search('har crown')).map((e) => e.id), isNot(contains(haru.id)));
    });

    test('searches across entity types', () async {
      await dao.upsert(haru);
      await dao.upsert(story);
      final results = await dao.search('crown');
      expect(results.single, isA<Story>());
    });

    test('excludes soft-deleted entities', () async {
      await dao.upsert(haru);
      await dao.softDelete(EntityType.character, haru.id);
      expect(await dao.search('haru'), isEmpty);
    });

    test('returns empty for blank or punctuation-only queries', () async {
      await dao.upsert(haru);
      expect(await dao.search(''), isEmpty);
      expect(await dao.search('   !!! ??? '), isEmpty);
    });
  });
}
