// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'universe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Universe {

 String get id; String get name; String? get description; String? get notes; String? get coverImageId; List<String> get imageIds; List<String> get tags;/// Convenience reference lists for browsing. These are denormalized;
/// the referenced entities remain the source of truth.
 List<String> get characterIds; List<String> get storyIds; List<String> get locationIds; List<String> get organizationIds; List<String> get itemIds; List<String> get speciesIds; List<String> get timelineEventIds; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Universe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniverseCopyWith<Universe> get copyWith => _$UniverseCopyWithImpl<Universe>(this as Universe, _$identity);

  /// Serializes this Universe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Universe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.characterIds, characterIds)&&const DeepCollectionEquality().equals(other.storyIds, storyIds)&&const DeepCollectionEquality().equals(other.locationIds, locationIds)&&const DeepCollectionEquality().equals(other.organizationIds, organizationIds)&&const DeepCollectionEquality().equals(other.itemIds, itemIds)&&const DeepCollectionEquality().equals(other.speciesIds, speciesIds)&&const DeepCollectionEquality().equals(other.timelineEventIds, timelineEventIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,notes,coverImageId,const DeepCollectionEquality().hash(imageIds),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(characterIds),const DeepCollectionEquality().hash(storyIds),const DeepCollectionEquality().hash(locationIds),const DeepCollectionEquality().hash(organizationIds),const DeepCollectionEquality().hash(itemIds),const DeepCollectionEquality().hash(speciesIds),const DeepCollectionEquality().hash(timelineEventIds),createdAt,updatedAt);

@override
String toString() {
  return 'Universe(id: $id, name: $name, description: $description, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, characterIds: $characterIds, storyIds: $storyIds, locationIds: $locationIds, organizationIds: $organizationIds, itemIds: $itemIds, speciesIds: $speciesIds, timelineEventIds: $timelineEventIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UniverseCopyWith<$Res>  {
  factory $UniverseCopyWith(Universe value, $Res Function(Universe) _then) = _$UniverseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, List<String> characterIds, List<String> storyIds, List<String> locationIds, List<String> organizationIds, List<String> itemIds, List<String> speciesIds, List<String> timelineEventIds, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UniverseCopyWithImpl<$Res>
    implements $UniverseCopyWith<$Res> {
  _$UniverseCopyWithImpl(this._self, this._then);

  final Universe _self;
  final $Res Function(Universe) _then;

/// Create a copy of Universe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? characterIds = null,Object? storyIds = null,Object? locationIds = null,Object? organizationIds = null,Object? itemIds = null,Object? speciesIds = null,Object? timelineEventIds = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,characterIds: null == characterIds ? _self.characterIds : characterIds // ignore: cast_nullable_to_non_nullable
as List<String>,storyIds: null == storyIds ? _self.storyIds : storyIds // ignore: cast_nullable_to_non_nullable
as List<String>,locationIds: null == locationIds ? _self.locationIds : locationIds // ignore: cast_nullable_to_non_nullable
as List<String>,organizationIds: null == organizationIds ? _self.organizationIds : organizationIds // ignore: cast_nullable_to_non_nullable
as List<String>,itemIds: null == itemIds ? _self.itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<String>,speciesIds: null == speciesIds ? _self.speciesIds : speciesIds // ignore: cast_nullable_to_non_nullable
as List<String>,timelineEventIds: null == timelineEventIds ? _self.timelineEventIds : timelineEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Universe].
extension UniversePatterns on Universe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Universe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Universe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Universe value)  $default,){
final _that = this;
switch (_that) {
case _Universe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Universe value)?  $default,){
final _that = this;
switch (_that) {
case _Universe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  List<String> characterIds,  List<String> storyIds,  List<String> locationIds,  List<String> organizationIds,  List<String> itemIds,  List<String> speciesIds,  List<String> timelineEventIds,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Universe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.characterIds,_that.storyIds,_that.locationIds,_that.organizationIds,_that.itemIds,_that.speciesIds,_that.timelineEventIds,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  List<String> characterIds,  List<String> storyIds,  List<String> locationIds,  List<String> organizationIds,  List<String> itemIds,  List<String> speciesIds,  List<String> timelineEventIds,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Universe():
return $default(_that.id,_that.name,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.characterIds,_that.storyIds,_that.locationIds,_that.organizationIds,_that.itemIds,_that.speciesIds,_that.timelineEventIds,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  List<String> characterIds,  List<String> storyIds,  List<String> locationIds,  List<String> organizationIds,  List<String> itemIds,  List<String> speciesIds,  List<String> timelineEventIds,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Universe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.characterIds,_that.storyIds,_that.locationIds,_that.organizationIds,_that.itemIds,_that.speciesIds,_that.timelineEventIds,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Universe implements Universe {
  const _Universe({required this.id, required this.name, this.description, this.notes, this.coverImageId, final  List<String> imageIds = const <String>[], final  List<String> tags = const <String>[], final  List<String> characterIds = const <String>[], final  List<String> storyIds = const <String>[], final  List<String> locationIds = const <String>[], final  List<String> organizationIds = const <String>[], final  List<String> itemIds = const <String>[], final  List<String> speciesIds = const <String>[], final  List<String> timelineEventIds = const <String>[], required this.createdAt, required this.updatedAt}): _imageIds = imageIds,_tags = tags,_characterIds = characterIds,_storyIds = storyIds,_locationIds = locationIds,_organizationIds = organizationIds,_itemIds = itemIds,_speciesIds = speciesIds,_timelineEventIds = timelineEventIds;
  factory _Universe.fromJson(Map<String, dynamic> json) => _$UniverseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? notes;
@override final  String? coverImageId;
 final  List<String> _imageIds;
@override@JsonKey() List<String> get imageIds {
  if (_imageIds is EqualUnmodifiableListView) return _imageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageIds);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Convenience reference lists for browsing. These are denormalized;
/// the referenced entities remain the source of truth.
 final  List<String> _characterIds;
/// Convenience reference lists for browsing. These are denormalized;
/// the referenced entities remain the source of truth.
@override@JsonKey() List<String> get characterIds {
  if (_characterIds is EqualUnmodifiableListView) return _characterIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characterIds);
}

 final  List<String> _storyIds;
@override@JsonKey() List<String> get storyIds {
  if (_storyIds is EqualUnmodifiableListView) return _storyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_storyIds);
}

 final  List<String> _locationIds;
@override@JsonKey() List<String> get locationIds {
  if (_locationIds is EqualUnmodifiableListView) return _locationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_locationIds);
}

 final  List<String> _organizationIds;
@override@JsonKey() List<String> get organizationIds {
  if (_organizationIds is EqualUnmodifiableListView) return _organizationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_organizationIds);
}

 final  List<String> _itemIds;
@override@JsonKey() List<String> get itemIds {
  if (_itemIds is EqualUnmodifiableListView) return _itemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemIds);
}

 final  List<String> _speciesIds;
@override@JsonKey() List<String> get speciesIds {
  if (_speciesIds is EqualUnmodifiableListView) return _speciesIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_speciesIds);
}

 final  List<String> _timelineEventIds;
@override@JsonKey() List<String> get timelineEventIds {
  if (_timelineEventIds is EqualUnmodifiableListView) return _timelineEventIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timelineEventIds);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Universe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniverseCopyWith<_Universe> get copyWith => __$UniverseCopyWithImpl<_Universe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniverseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Universe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._characterIds, _characterIds)&&const DeepCollectionEquality().equals(other._storyIds, _storyIds)&&const DeepCollectionEquality().equals(other._locationIds, _locationIds)&&const DeepCollectionEquality().equals(other._organizationIds, _organizationIds)&&const DeepCollectionEquality().equals(other._itemIds, _itemIds)&&const DeepCollectionEquality().equals(other._speciesIds, _speciesIds)&&const DeepCollectionEquality().equals(other._timelineEventIds, _timelineEventIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,notes,coverImageId,const DeepCollectionEquality().hash(_imageIds),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_characterIds),const DeepCollectionEquality().hash(_storyIds),const DeepCollectionEquality().hash(_locationIds),const DeepCollectionEquality().hash(_organizationIds),const DeepCollectionEquality().hash(_itemIds),const DeepCollectionEquality().hash(_speciesIds),const DeepCollectionEquality().hash(_timelineEventIds),createdAt,updatedAt);

@override
String toString() {
  return 'Universe(id: $id, name: $name, description: $description, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, characterIds: $characterIds, storyIds: $storyIds, locationIds: $locationIds, organizationIds: $organizationIds, itemIds: $itemIds, speciesIds: $speciesIds, timelineEventIds: $timelineEventIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UniverseCopyWith<$Res> implements $UniverseCopyWith<$Res> {
  factory _$UniverseCopyWith(_Universe value, $Res Function(_Universe) _then) = __$UniverseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, List<String> characterIds, List<String> storyIds, List<String> locationIds, List<String> organizationIds, List<String> itemIds, List<String> speciesIds, List<String> timelineEventIds, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UniverseCopyWithImpl<$Res>
    implements _$UniverseCopyWith<$Res> {
  __$UniverseCopyWithImpl(this._self, this._then);

  final _Universe _self;
  final $Res Function(_Universe) _then;

/// Create a copy of Universe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? characterIds = null,Object? storyIds = null,Object? locationIds = null,Object? organizationIds = null,Object? itemIds = null,Object? speciesIds = null,Object? timelineEventIds = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Universe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,characterIds: null == characterIds ? _self._characterIds : characterIds // ignore: cast_nullable_to_non_nullable
as List<String>,storyIds: null == storyIds ? _self._storyIds : storyIds // ignore: cast_nullable_to_non_nullable
as List<String>,locationIds: null == locationIds ? _self._locationIds : locationIds // ignore: cast_nullable_to_non_nullable
as List<String>,organizationIds: null == organizationIds ? _self._organizationIds : organizationIds // ignore: cast_nullable_to_non_nullable
as List<String>,itemIds: null == itemIds ? _self._itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<String>,speciesIds: null == speciesIds ? _self._speciesIds : speciesIds // ignore: cast_nullable_to_non_nullable
as List<String>,timelineEventIds: null == timelineEventIds ? _self._timelineEventIds : timelineEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
