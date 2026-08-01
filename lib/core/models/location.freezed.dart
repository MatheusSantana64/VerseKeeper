// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Location {

 String get id; String get name; String? get universeId; String? get type; String? get description; String? get notes; String? get coverImageId; List<String> get imageIds; List<String> get tags; String? get parentLocationId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.parentLocationId, parentLocationId) || other.parentLocationId == parentLocationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,universeId,type,description,notes,coverImageId,const DeepCollectionEquality().hash(imageIds),const DeepCollectionEquality().hash(tags),parentLocationId,createdAt,updatedAt);

@override
String toString() {
  return 'Location(id: $id, name: $name, universeId: $universeId, type: $type, description: $description, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, parentLocationId: $parentLocationId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? universeId, String? type, String? description, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, String? parentLocationId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? universeId = freezed,Object? type = freezed,Object? description = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? parentLocationId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,parentLocationId: freezed == parentLocationId ? _self.parentLocationId : parentLocationId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? universeId,  String? type,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  String? parentLocationId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.name,_that.universeId,_that.type,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.parentLocationId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? universeId,  String? type,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  String? parentLocationId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.id,_that.name,_that.universeId,_that.type,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.parentLocationId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? universeId,  String? type,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  String? parentLocationId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.name,_that.universeId,_that.type,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.parentLocationId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location extends Location {
  const _Location({required this.id, required this.name, this.universeId, this.type, this.description, this.notes, this.coverImageId, final  List<String> imageIds = const <String>[], final  List<String> tags = const <String>[], this.parentLocationId, required this.createdAt, required this.updatedAt}): _imageIds = imageIds,_tags = tags,super._();
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? universeId;
@override final  String? type;
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

@override final  String? parentLocationId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.parentLocationId, parentLocationId) || other.parentLocationId == parentLocationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,universeId,type,description,notes,coverImageId,const DeepCollectionEquality().hash(_imageIds),const DeepCollectionEquality().hash(_tags),parentLocationId,createdAt,updatedAt);

@override
String toString() {
  return 'Location(id: $id, name: $name, universeId: $universeId, type: $type, description: $description, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, parentLocationId: $parentLocationId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? universeId, String? type, String? description, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, String? parentLocationId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? universeId = freezed,Object? type = freezed,Object? description = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? parentLocationId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Location(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,parentLocationId: freezed == parentLocationId ? _self.parentLocationId : parentLocationId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
