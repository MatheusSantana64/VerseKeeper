// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CharacterVersion {

/// Stable unique identifier.
 String get id;/// Id of the base character this version belongs to.
 String get characterId;/// Id of the universe this incarnation lives in, if any.
 String? get universeId;/// Incarnation name, e.g. "Princess" or "FBI Agent".
 String get name;/// Display avatar for this incarnation.
 String? get coverImageId;/// Gallery images specific to this incarnation (empty = inherit).
 List<String> get imageIds;/// `null` = inherit from the base character.
 String? get personality;/// `null` = inherit from the base character.
 String? get appearance;/// `null` = inherit from the base character.
 String? get notes;/// `null` = inherit from the base character.
 String? get speechStyle;/// `null` = inherit from the base character.
 String? get aiPrompt;/// Tags specific to this incarnation (empty = inherit).
 List<String> get tags;/// Stories this incarnation specifically appears in.
 List<String> get storyIds;/// Relationships specific to this incarnation.
 List<Relationship> get relationships; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of CharacterVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterVersionCopyWith<CharacterVersion> get copyWith => _$CharacterVersionCopyWithImpl<CharacterVersion>(this as CharacterVersion, _$identity);

  /// Serializes this CharacterVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.characterId, characterId) || other.characterId == characterId)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&(identical(other.personality, personality) || other.personality == personality)&&(identical(other.appearance, appearance) || other.appearance == appearance)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.speechStyle, speechStyle) || other.speechStyle == speechStyle)&&(identical(other.aiPrompt, aiPrompt) || other.aiPrompt == aiPrompt)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.storyIds, storyIds)&&const DeepCollectionEquality().equals(other.relationships, relationships)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,characterId,universeId,name,coverImageId,const DeepCollectionEquality().hash(imageIds),personality,appearance,notes,speechStyle,aiPrompt,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(storyIds),const DeepCollectionEquality().hash(relationships),createdAt,updatedAt);

@override
String toString() {
  return 'CharacterVersion(id: $id, characterId: $characterId, universeId: $universeId, name: $name, coverImageId: $coverImageId, imageIds: $imageIds, personality: $personality, appearance: $appearance, notes: $notes, speechStyle: $speechStyle, aiPrompt: $aiPrompt, tags: $tags, storyIds: $storyIds, relationships: $relationships, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CharacterVersionCopyWith<$Res>  {
  factory $CharacterVersionCopyWith(CharacterVersion value, $Res Function(CharacterVersion) _then) = _$CharacterVersionCopyWithImpl;
@useResult
$Res call({
 String id, String characterId, String? universeId, String name, String? coverImageId, List<String> imageIds, String? personality, String? appearance, String? notes, String? speechStyle, String? aiPrompt, List<String> tags, List<String> storyIds, List<Relationship> relationships, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CharacterVersionCopyWithImpl<$Res>
    implements $CharacterVersionCopyWith<$Res> {
  _$CharacterVersionCopyWithImpl(this._self, this._then);

  final CharacterVersion _self;
  final $Res Function(CharacterVersion) _then;

/// Create a copy of CharacterVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? characterId = null,Object? universeId = freezed,Object? name = null,Object? coverImageId = freezed,Object? imageIds = null,Object? personality = freezed,Object? appearance = freezed,Object? notes = freezed,Object? speechStyle = freezed,Object? aiPrompt = freezed,Object? tags = null,Object? storyIds = null,Object? relationships = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,characterId: null == characterId ? _self.characterId : characterId // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,personality: freezed == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as String?,appearance: freezed == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,speechStyle: freezed == speechStyle ? _self.speechStyle : speechStyle // ignore: cast_nullable_to_non_nullable
as String?,aiPrompt: freezed == aiPrompt ? _self.aiPrompt : aiPrompt // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,storyIds: null == storyIds ? _self.storyIds : storyIds // ignore: cast_nullable_to_non_nullable
as List<String>,relationships: null == relationships ? _self.relationships : relationships // ignore: cast_nullable_to_non_nullable
as List<Relationship>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterVersion].
extension CharacterVersionPatterns on CharacterVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterVersion value)  $default,){
final _that = this;
switch (_that) {
case _CharacterVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterVersion value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String characterId,  String? universeId,  String name,  String? coverImageId,  List<String> imageIds,  String? personality,  String? appearance,  String? notes,  String? speechStyle,  String? aiPrompt,  List<String> tags,  List<String> storyIds,  List<Relationship> relationships,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterVersion() when $default != null:
return $default(_that.id,_that.characterId,_that.universeId,_that.name,_that.coverImageId,_that.imageIds,_that.personality,_that.appearance,_that.notes,_that.speechStyle,_that.aiPrompt,_that.tags,_that.storyIds,_that.relationships,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String characterId,  String? universeId,  String name,  String? coverImageId,  List<String> imageIds,  String? personality,  String? appearance,  String? notes,  String? speechStyle,  String? aiPrompt,  List<String> tags,  List<String> storyIds,  List<Relationship> relationships,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CharacterVersion():
return $default(_that.id,_that.characterId,_that.universeId,_that.name,_that.coverImageId,_that.imageIds,_that.personality,_that.appearance,_that.notes,_that.speechStyle,_that.aiPrompt,_that.tags,_that.storyIds,_that.relationships,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String characterId,  String? universeId,  String name,  String? coverImageId,  List<String> imageIds,  String? personality,  String? appearance,  String? notes,  String? speechStyle,  String? aiPrompt,  List<String> tags,  List<String> storyIds,  List<Relationship> relationships,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CharacterVersion() when $default != null:
return $default(_that.id,_that.characterId,_that.universeId,_that.name,_that.coverImageId,_that.imageIds,_that.personality,_that.appearance,_that.notes,_that.speechStyle,_that.aiPrompt,_that.tags,_that.storyIds,_that.relationships,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterVersion extends CharacterVersion {
  const _CharacterVersion({required this.id, required this.characterId, this.universeId, required this.name, this.coverImageId, final  List<String> imageIds = const <String>[], this.personality, this.appearance, this.notes, this.speechStyle, this.aiPrompt, final  List<String> tags = const <String>[], final  List<String> storyIds = const <String>[], final  List<Relationship> relationships = const <Relationship>[], required this.createdAt, required this.updatedAt}): _imageIds = imageIds,_tags = tags,_storyIds = storyIds,_relationships = relationships,super._();
  factory _CharacterVersion.fromJson(Map<String, dynamic> json) => _$CharacterVersionFromJson(json);

/// Stable unique identifier.
@override final  String id;
/// Id of the base character this version belongs to.
@override final  String characterId;
/// Id of the universe this incarnation lives in, if any.
@override final  String? universeId;
/// Incarnation name, e.g. "Princess" or "FBI Agent".
@override final  String name;
/// Display avatar for this incarnation.
@override final  String? coverImageId;
/// Gallery images specific to this incarnation (empty = inherit).
 final  List<String> _imageIds;
/// Gallery images specific to this incarnation (empty = inherit).
@override@JsonKey() List<String> get imageIds {
  if (_imageIds is EqualUnmodifiableListView) return _imageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageIds);
}

/// `null` = inherit from the base character.
@override final  String? personality;
/// `null` = inherit from the base character.
@override final  String? appearance;
/// `null` = inherit from the base character.
@override final  String? notes;
/// `null` = inherit from the base character.
@override final  String? speechStyle;
/// `null` = inherit from the base character.
@override final  String? aiPrompt;
/// Tags specific to this incarnation (empty = inherit).
 final  List<String> _tags;
/// Tags specific to this incarnation (empty = inherit).
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Stories this incarnation specifically appears in.
 final  List<String> _storyIds;
/// Stories this incarnation specifically appears in.
@override@JsonKey() List<String> get storyIds {
  if (_storyIds is EqualUnmodifiableListView) return _storyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_storyIds);
}

/// Relationships specific to this incarnation.
 final  List<Relationship> _relationships;
/// Relationships specific to this incarnation.
@override@JsonKey() List<Relationship> get relationships {
  if (_relationships is EqualUnmodifiableListView) return _relationships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relationships);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of CharacterVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterVersionCopyWith<_CharacterVersion> get copyWith => __$CharacterVersionCopyWithImpl<_CharacterVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.characterId, characterId) || other.characterId == characterId)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&(identical(other.personality, personality) || other.personality == personality)&&(identical(other.appearance, appearance) || other.appearance == appearance)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.speechStyle, speechStyle) || other.speechStyle == speechStyle)&&(identical(other.aiPrompt, aiPrompt) || other.aiPrompt == aiPrompt)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._storyIds, _storyIds)&&const DeepCollectionEquality().equals(other._relationships, _relationships)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,characterId,universeId,name,coverImageId,const DeepCollectionEquality().hash(_imageIds),personality,appearance,notes,speechStyle,aiPrompt,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_storyIds),const DeepCollectionEquality().hash(_relationships),createdAt,updatedAt);

@override
String toString() {
  return 'CharacterVersion(id: $id, characterId: $characterId, universeId: $universeId, name: $name, coverImageId: $coverImageId, imageIds: $imageIds, personality: $personality, appearance: $appearance, notes: $notes, speechStyle: $speechStyle, aiPrompt: $aiPrompt, tags: $tags, storyIds: $storyIds, relationships: $relationships, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CharacterVersionCopyWith<$Res> implements $CharacterVersionCopyWith<$Res> {
  factory _$CharacterVersionCopyWith(_CharacterVersion value, $Res Function(_CharacterVersion) _then) = __$CharacterVersionCopyWithImpl;
@override @useResult
$Res call({
 String id, String characterId, String? universeId, String name, String? coverImageId, List<String> imageIds, String? personality, String? appearance, String? notes, String? speechStyle, String? aiPrompt, List<String> tags, List<String> storyIds, List<Relationship> relationships, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CharacterVersionCopyWithImpl<$Res>
    implements _$CharacterVersionCopyWith<$Res> {
  __$CharacterVersionCopyWithImpl(this._self, this._then);

  final _CharacterVersion _self;
  final $Res Function(_CharacterVersion) _then;

/// Create a copy of CharacterVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? characterId = null,Object? universeId = freezed,Object? name = null,Object? coverImageId = freezed,Object? imageIds = null,Object? personality = freezed,Object? appearance = freezed,Object? notes = freezed,Object? speechStyle = freezed,Object? aiPrompt = freezed,Object? tags = null,Object? storyIds = null,Object? relationships = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CharacterVersion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,characterId: null == characterId ? _self.characterId : characterId // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,personality: freezed == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as String?,appearance: freezed == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,speechStyle: freezed == speechStyle ? _self.speechStyle : speechStyle // ignore: cast_nullable_to_non_nullable
as String?,aiPrompt: freezed == aiPrompt ? _self.aiPrompt : aiPrompt // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,storyIds: null == storyIds ? _self._storyIds : storyIds // ignore: cast_nullable_to_non_nullable
as List<String>,relationships: null == relationships ? _self._relationships : relationships // ignore: cast_nullable_to_non_nullable
as List<Relationship>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
