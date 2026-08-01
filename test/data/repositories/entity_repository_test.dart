import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/core/models/story.dart';
import 'package:versekeeper/data/local/app_database.dart';
import 'package:versekeeper/data/local/entities_dao.dart';
import 'package:versekeeper/data/repositories/entity_repository.dart';
import 'package:versekeeper/data/repositories/search_repository.dart';

void main() {
  late AppDatabase database;
  late EntitiesDao dao;
  late EntityRepository<Character> characters;
  late SearchRepository search;

  final haru = Character(
    id: 'haru-1',
    name: 'Haru',
    aliases: ['Princess'],
    notes: 'Swordfighter.',
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 2),
  );

  setUp(() {
    database = AppDatabase.forTesting();
    dao = EntitiesDao(database);
    characters = LocalEntityRepository<Character>(dao, EntityType.character);
    search = LocalSearchRepository(dao);
  });

  tearDown(() async {
    await database.close();
  });

  group('EntityRepository', () {
    test('save + getById round trips a character', () async {
      await characters.save(haru);
      expect(await characters.getById(haru.id), haru);
    });

    test('save replaces existing data', () async {
      await characters.save(haru);
      await characters.save(haru.copyWith(name: 'Haru (v2)'));
      expect((await characters.getById(haru.id))?.name, 'Haru (v2)');
    });

    test('count reflects saves and deletions', () async {
      expect(await characters.count(), 0);
      await characters.save(haru);
      expect(await characters.count(), 1);
      await characters.delete(haru.id);
      expect(await characters.count(), 0);
    });

    test('delete tombstones: getById and watchAll exclude it', () async {
      await characters.save(haru);
      await characters.delete(haru.id);
      expect(await characters.getById(haru.id), isNull);

      final list = await characters.watchAll().first;
      expect(list, isEmpty);
    });

    test('watchAll emits saved entities', () async {
      final stream = characters.watchAll();
      final seen = <List<Character>>[];
      final sub = stream.listen(seen.add);
      await pumpEventQueue();
      await characters.save(haru);
      await pumpEventQueue();
      await sub.cancel();
      expect(seen.last.map((c) => c.id), contains(haru.id));
    });

    test('watchById emits the entity then null after delete', () async {
      final stream = characters.watchById(haru.id);
      final seen = <Character?>[];
      final sub = stream.listen(seen.add);
      await pumpEventQueue();
      await characters.save(haru);
      await pumpEventQueue();
      await characters.delete(haru.id);
      await pumpEventQueue();
      await sub.cancel();
      expect(seen, contains(haru));
      expect(seen.last, isNull);
    });
  });

  group('SearchRepository', () {
    test('search finds entities across types', () async {
      await characters.save(haru);
      await dao.upsert(
        Story(
          id: 'story-1',
          title: 'Crown of Ashes',
          createdAt: DateTime.utc(2024, 2, 1),
          updatedAt: DateTime.utc(2024, 2, 2),
        ),
      );

      final results = await search.search('sword');
      expect(results.single, isA<Character>());

      final crowns = await search.search('crown');
      expect(crowns.single, isA<Story>());
    });

    test('watchSearch emits empty for blank queries', () async {
      await characters.save(haru);
      expect(await search.watchSearch('').first, isEmpty);
    });
  });
}
