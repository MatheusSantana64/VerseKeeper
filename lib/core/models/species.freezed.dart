// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Species {

 String get id; String get name; String? get universeId; String? get description; String? get notes; String? get coverImageId; List<String> get imageIds; List<String> get tags; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesCopyWith<Species> get copyWith => _$SpeciesCopyWithImpl<Species>(this as Species, _$identity);

  /// Serializes this Species to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Species&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,universeId,description,notes,coverImageId,const DeepCollectionEquality().hash(imageIds),const DeepCollectionEquality().hash(tags),createdAt,updatedAt);

@override
String toString() {
  return 'Species(id: $id, name: $name, universeId: $universeId, description: $description, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SpeciesCopyWith<$Res>  {
  factory $SpeciesCopyWith(Species value, $Res Function(Species) _then) = _$SpeciesCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? universeId, String? description, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SpeciesCopyWithImpl<$Res>
    implements $SpeciesCopyWith<$Res> {
  _$SpeciesCopyWithImpl(this._self, this._then);

  final Species _self;
  final $Res Function(Species) _then;

/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? universeId = freezed,Object? description = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Species].
extension SpeciesPatterns on Species {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Species value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Species() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Species value)  $default,){
final _that = this;
switch (_that) {
case _Species():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Species value)?  $default,){
final _that = this;
switch (_that) {
case _Species() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? universeId,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Species() when $default != null:
return $default(_that.id,_that.name,_that.universeId,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? universeId,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Species():
return $default(_that.id,_that.name,_that.universeId,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? universeId,  String? description,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Species() when $default != null:
return $default(_that.id,_that.name,_that.universeId,_that.description,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Species extends Species {
  const _Species({required this.id, required this.name, this.universeId, this.description, this.notes, this.coverImageId, final  List<String> imageIds = const <String>[], final  List<String> tags = const <String>[], required this.createdAt, required this.updatedAt}): _imageIds = imageIds,_tags = tags,super._();
  factory _Species.fromJson(Map<String, dynamic> json) => _$SpeciesFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? universeId;
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

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesCopyWith<_Species> get copyWith => __$SpeciesCopyWithImpl<_Species>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeciesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Species&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,universeId,description,notes,coverImageId,const DeepCollectionEquality().hash(_imageIds),const DeepCollectionEquality().hash(_tags),createdAt,updatedAt);

@override
String toString() {
  return 'Species(id: $id, name: $name, universeId: $universeId, description: $description, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SpeciesCopyWith<$Res> implements $SpeciesCopyWith<$Res> {
  factory _$SpeciesCopyWith(_Species value, $Res Function(_Species) _then) = __$SpeciesCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? universeId, String? description, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SpeciesCopyWithImpl<$Res>
    implements _$SpeciesCopyWith<$Res> {
  __$SpeciesCopyWithImpl(this._self, this._then);

  final _Species _self;
  final $Res Function(_Species) _then;

/// Create a copy of Species
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? universeId = freezed,Object? description = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Species(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
