// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimelineEvent {

 String get id; String get title; String? get universeId; String? get dateLabel; int get sortOrder; String? get description; String? get notes; List<String> get tags; List<String> get involvedCharacterIds; List<String> get involvedOrganizationIds; List<String> get involvedLocationIds; List<String> get relatedEventIds; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEventCopyWith<TimelineEvent> get copyWith => _$TimelineEventCopyWithImpl<TimelineEvent>(this as TimelineEvent, _$identity);

  /// Serializes this TimelineEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.involvedCharacterIds, involvedCharacterIds)&&const DeepCollectionEquality().equals(other.involvedOrganizationIds, involvedOrganizationIds)&&const DeepCollectionEquality().equals(other.involvedLocationIds, involvedLocationIds)&&const DeepCollectionEquality().equals(other.relatedEventIds, relatedEventIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,universeId,dateLabel,sortOrder,description,notes,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(involvedCharacterIds),const DeepCollectionEquality().hash(involvedOrganizationIds),const DeepCollectionEquality().hash(involvedLocationIds),const DeepCollectionEquality().hash(relatedEventIds),createdAt,updatedAt);

@override
String toString() {
  return 'TimelineEvent(id: $id, title: $title, universeId: $universeId, dateLabel: $dateLabel, sortOrder: $sortOrder, description: $description, notes: $notes, tags: $tags, involvedCharacterIds: $involvedCharacterIds, involvedOrganizationIds: $involvedOrganizationIds, involvedLocationIds: $involvedLocationIds, relatedEventIds: $relatedEventIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TimelineEventCopyWith<$Res>  {
  factory $TimelineEventCopyWith(TimelineEvent value, $Res Function(TimelineEvent) _then) = _$TimelineEventCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? universeId, String? dateLabel, int sortOrder, String? description, String? notes, List<String> tags, List<String> involvedCharacterIds, List<String> involvedOrganizationIds, List<String> involvedLocationIds, List<String> relatedEventIds, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TimelineEventCopyWithImpl<$Res>
    implements $TimelineEventCopyWith<$Res> {
  _$TimelineEventCopyWithImpl(this._self, this._then);

  final TimelineEvent _self;
  final $Res Function(TimelineEvent) _then;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? universeId = freezed,Object? dateLabel = freezed,Object? sortOrder = null,Object? description = freezed,Object? notes = freezed,Object? tags = null,Object? involvedCharacterIds = null,Object? involvedOrganizationIds = null,Object? involvedLocationIds = null,Object? relatedEventIds = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,dateLabel: freezed == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,involvedCharacterIds: null == involvedCharacterIds ? _self.involvedCharacterIds : involvedCharacterIds // ignore: cast_nullable_to_non_nullable
as List<String>,involvedOrganizationIds: null == involvedOrganizationIds ? _self.involvedOrganizationIds : involvedOrganizationIds // ignore: cast_nullable_to_non_nullable
as List<String>,involvedLocationIds: null == involvedLocationIds ? _self.involvedLocationIds : involvedLocationIds // ignore: cast_nullable_to_non_nullable
as List<String>,relatedEventIds: null == relatedEventIds ? _self.relatedEventIds : relatedEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineEvent].
extension TimelineEventPatterns on TimelineEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineEvent value)  $default,){
final _that = this;
switch (_that) {
case _TimelineEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? universeId,  String? dateLabel,  int sortOrder,  String? description,  String? notes,  List<String> tags,  List<String> involvedCharacterIds,  List<String> involvedOrganizationIds,  List<String> involvedLocationIds,  List<String> relatedEventIds,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that.id,_that.title,_that.universeId,_that.dateLabel,_that.sortOrder,_that.description,_that.notes,_that.tags,_that.involvedCharacterIds,_that.involvedOrganizationIds,_that.involvedLocationIds,_that.relatedEventIds,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? universeId,  String? dateLabel,  int sortOrder,  String? description,  String? notes,  List<String> tags,  List<String> involvedCharacterIds,  List<String> involvedOrganizationIds,  List<String> involvedLocationIds,  List<String> relatedEventIds,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TimelineEvent():
return $default(_that.id,_that.title,_that.universeId,_that.dateLabel,_that.sortOrder,_that.description,_that.notes,_that.tags,_that.involvedCharacterIds,_that.involvedOrganizationIds,_that.involvedLocationIds,_that.relatedEventIds,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? universeId,  String? dateLabel,  int sortOrder,  String? description,  String? notes,  List<String> tags,  List<String> involvedCharacterIds,  List<String> involvedOrganizationIds,  List<String> involvedLocationIds,  List<String> relatedEventIds,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that.id,_that.title,_that.universeId,_that.dateLabel,_that.sortOrder,_that.description,_that.notes,_that.tags,_that.involvedCharacterIds,_that.involvedOrganizationIds,_that.involvedLocationIds,_that.relatedEventIds,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimelineEvent extends TimelineEvent {
  const _TimelineEvent({required this.id, required this.title, this.universeId, this.dateLabel, this.sortOrder = 0, this.description, this.notes, final  List<String> tags = const <String>[], final  List<String> involvedCharacterIds = const <String>[], final  List<String> involvedOrganizationIds = const <String>[], final  List<String> involvedLocationIds = const <String>[], final  List<String> relatedEventIds = const <String>[], required this.createdAt, required this.updatedAt}): _tags = tags,_involvedCharacterIds = involvedCharacterIds,_involvedOrganizationIds = involvedOrganizationIds,_involvedLocationIds = involvedLocationIds,_relatedEventIds = relatedEventIds,super._();
  factory _TimelineEvent.fromJson(Map<String, dynamic> json) => _$TimelineEventFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? universeId;
@override final  String? dateLabel;
@override@JsonKey() final  int sortOrder;
@override final  String? description;
@override final  String? notes;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<String> _involvedCharacterIds;
@override@JsonKey() List<String> get involvedCharacterIds {
  if (_involvedCharacterIds is EqualUnmodifiableListView) return _involvedCharacterIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_involvedCharacterIds);
}

 final  List<String> _involvedOrganizationIds;
@override@JsonKey() List<String> get involvedOrganizationIds {
  if (_involvedOrganizationIds is EqualUnmodifiableListView) return _involvedOrganizationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_involvedOrganizationIds);
}

 final  List<String> _involvedLocationIds;
@override@JsonKey() List<String> get involvedLocationIds {
  if (_involvedLocationIds is EqualUnmodifiableListView) return _involvedLocationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_involvedLocationIds);
}

 final  List<String> _relatedEventIds;
@override@JsonKey() List<String> get relatedEventIds {
  if (_relatedEventIds is EqualUnmodifiableListView) return _relatedEventIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedEventIds);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineEventCopyWith<_TimelineEvent> get copyWith => __$TimelineEventCopyWithImpl<_TimelineEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._involvedCharacterIds, _involvedCharacterIds)&&const DeepCollectionEquality().equals(other._involvedOrganizationIds, _involvedOrganizationIds)&&const DeepCollectionEquality().equals(other._involvedLocationIds, _involvedLocationIds)&&const DeepCollectionEquality().equals(other._relatedEventIds, _relatedEventIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,universeId,dateLabel,sortOrder,description,notes,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_involvedCharacterIds),const DeepCollectionEquality().hash(_involvedOrganizationIds),const DeepCollectionEquality().hash(_involvedLocationIds),const DeepCollectionEquality().hash(_relatedEventIds),createdAt,updatedAt);

@override
String toString() {
  return 'TimelineEvent(id: $id, title: $title, universeId: $universeId, dateLabel: $dateLabel, sortOrder: $sortOrder, description: $description, notes: $notes, tags: $tags, involvedCharacterIds: $involvedCharacterIds, involvedOrganizationIds: $involvedOrganizationIds, involvedLocationIds: $involvedLocationIds, relatedEventIds: $relatedEventIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TimelineEventCopyWith<$Res> implements $TimelineEventCopyWith<$Res> {
  factory _$TimelineEventCopyWith(_TimelineEvent value, $Res Function(_TimelineEvent) _then) = __$TimelineEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? universeId, String? dateLabel, int sortOrder, String? description, String? notes, List<String> tags, List<String> involvedCharacterIds, List<String> involvedOrganizationIds, List<String> involvedLocationIds, List<String> relatedEventIds, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TimelineEventCopyWithImpl<$Res>
    implements _$TimelineEventCopyWith<$Res> {
  __$TimelineEventCopyWithImpl(this._self, this._then);

  final _TimelineEvent _self;
  final $Res Function(_TimelineEvent) _then;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? universeId = freezed,Object? dateLabel = freezed,Object? sortOrder = null,Object? description = freezed,Object? notes = freezed,Object? tags = null,Object? involvedCharacterIds = null,Object? involvedOrganizationIds = null,Object? involvedLocationIds = null,Object? relatedEventIds = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TimelineEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,dateLabel: freezed == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,involvedCharacterIds: null == involvedCharacterIds ? _self._involvedCharacterIds : involvedCharacterIds // ignore: cast_nullable_to_non_nullable
as List<String>,involvedOrganizationIds: null == involvedOrganizationIds ? _self._involvedOrganizationIds : involvedOrganizationIds // ignore: cast_nullable_to_non_nullable
as List<String>,involvedLocationIds: null == involvedLocationIds ? _self._involvedLocationIds : involvedLocationIds // ignore: cast_nullable_to_non_nullable
as List<String>,relatedEventIds: null == relatedEventIds ? _self._relatedEventIds : relatedEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
