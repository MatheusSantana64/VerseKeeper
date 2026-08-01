import 'package:flutter_test/flutter_test.dart';

import 'package:versekeeper/core/models/entity_type.dart';
import 'package:versekeeper/core/models/field_definition.dart';

void main() {
  group('FieldDefinition', () {
    test('is a StoredEntity of type fieldDefinition', () {
      final definition = FieldDefinition(
        id: 'def-1',
        name: 'Birthplace',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      );
      expect(definition.entityType, EntityType.fieldDefinition);
      expect(definition.toJson()['name'], 'Birthplace');
    });

    test('round trips through json', () {
      final definition = FieldDefinition(
        id: 'def-1',
        name: 'Birthplace',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      );
      final restored = FieldDefinition.fromJson(definition.toJson());
      expect(restored, definition);
    });
  });
}
