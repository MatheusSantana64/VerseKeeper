import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/character.dart';
import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/core/models/field_definition.dart';
import 'package:versekeeper/data/local/app_database.dart';
import 'package:versekeeper/data/local/entities_dao.dart';

void main() {
  test('stripping a custom field removes its value from all characters', () async {
    final database = AppDatabase.forTesting();
    addTearDown(database.close);
    final dao = EntitiesDao(database);

    final definition = FieldDefinition(
      id: 'def-birthplace',
      name: 'Birthplace',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final haru = Character(
      id: 'char-haru',
      name: 'Haru',
      customFields: {'def-birthplace': 'Eryndor', 'other': 'keep me'},
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    final rin = Character(
      id: 'char-rin',
      name: 'Rin',
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    await dao.upsert(definition);
    await dao.upsert(haru);
    await dao.upsert(rin);

    final characters = await dao.watchAll<Character>(EntityType.character).first;
    final stripped = characters.map((c) {
      final fields = Map<String, String>.of(c.customFields)..remove('def-birthplace');
      return c.copyWith(customFields: fields);
    }).toList();
    for (final c in stripped) {
      await dao.upsert(c);
    }

    final reloaded = await dao.getById<Character>(EntityType.character, 'char-haru');
    expect(reloaded!.customFields, {'other': 'keep me'});
  });
}
