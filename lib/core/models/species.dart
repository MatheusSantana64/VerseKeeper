import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity_type.dart';
import 'stored_entity.dart';

part 'species.freezed.dart';
part 'species.g.dart';

/// A species or race within a universe.
@freezed
abstract class Species with _$Species implements StoredEntity {
  const Species._();

  const factory Species({
    required String id,
    required String name,
    String? universeId,
    String? description,
    String? notes,
    String? coverImageId,
    @Default(<String>[]) List<String> imageIds,
    @Default(<String>[]) List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Species;

  factory Species.fromJson(Map<String, dynamic> json) => _$SpeciesFromJson(json);

  @override
  EntityType get entityType => EntityType.species;
}
