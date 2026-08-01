import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity_type.dart';
import 'stored_entity.dart';

part 'timeline_event.freezed.dart';
part 'timeline_event.g.dart';

/// A point on a universe's timeline.
///
/// Fictional worlds rarely use real-world calendars, so the date is kept as a
/// free-form label (e.g. "Year 117, 3rd Moon") plus a numeric [sortOrder] for
/// deterministic ordering.
@freezed
abstract class TimelineEvent with _$TimelineEvent implements StoredEntity {
  const TimelineEvent._();

  const factory TimelineEvent({
    required String id,
    required String title,
    String? universeId,
    String? dateLabel,
    @Default(0) int sortOrder,
    String? description,
    String? notes,
    @Default(<String>[]) List<String> tags,
    @Default(<String>[]) List<String> involvedCharacterIds,
    @Default(<String>[]) List<String> involvedOrganizationIds,
    @Default(<String>[]) List<String> involvedLocationIds,
    @Default(<String>[]) List<String> relatedEventIds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TimelineEvent;

  factory TimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventFromJson(json);

  @override
  EntityType get entityType => EntityType.timelineEvent;
}
