import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity_type.dart';
import 'stored_entity.dart';

part 'item.freezed.dart';
part 'item.g.dart';

/// An object, artifact or item within a universe.
@freezed
abstract class Item with _$Item implements StoredEntity {
  const Item._();

  const factory Item({
    required String id,
    required String name,
    String? universeId,
    String? type,
    String? description,
    String? notes,
    String? coverImageId,
    @Default(<String>[]) List<String> imageIds,
    @Default(<String>[]) List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  @override
  EntityType get entityType => EntityType.item;
}
