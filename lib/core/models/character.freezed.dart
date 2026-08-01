// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Character {

/// Stable unique identifier. Never changes after creation.
 String get id;/// Primary display name, e.g. "Haru".
 String get name;/// Alternate names / nicknames.
 List<String> get aliases;/// User-assigned tags, used for filtering and search. Plaintext metadata.
 List<String> get tags;/// Universes this character appears in (a character is reused across
/// universes, unlike most other entities which belong to one).
 List<String> get universeIds;/// Cover image file id (see the local image store).
 String? get coverImageId;/// Additional gallery image file ids.
 List<String> get imageIds;/// Stable core personality. Per-version details override via versions.
 String? get personality;/// Stable core appearance.
 String? get appearance;/// Free-form notes about the character.
 String? get notes;/// How the character tends to speak.
 String? get speechStyle;/// Prompt template used when generating this character with AI.
 String? get aiPrompt;/// Stories this character appears in (denormalized convenience list).
 List<String> get storyIds;/// All versions (incarnations) of this character.
 List<String> get versionIds;/// Relationships from this character to others. See [Relationship].
 List<Relationship> get relationships; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterCopyWith<Character> get copyWith => _$CharacterCopyWithImpl<Character>(this as Character, _$identity);

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Character&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.aliases, aliases)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.universeIds, universeIds)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&(identical(other.personality, personality) || other.personality == personality)&&(identical(other.appearance, appearance) || other.appearance == appearance)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.speechStyle, speechStyle) || other.speechStyle == speechStyle)&&(identical(other.aiPrompt, aiPrompt) || other.aiPrompt == aiPrompt)&&const DeepCollectionEquality().equals(other.storyIds, storyIds)&&const DeepCollectionEquality().equals(other.versionIds, versionIds)&&const DeepCollectionEquality().equals(other.relationships, relationships)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(aliases),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(universeIds),coverImageId,const DeepCollectionEquality().hash(imageIds),personality,appearance,notes,speechStyle,aiPrompt,const DeepCollectionEquality().hash(storyIds),const DeepCollectionEquality().hash(versionIds),const DeepCollectionEquality().hash(relationships),createdAt,updatedAt);

@override
String toString() {
  return 'Character(id: $id, name: $name, aliases: $aliases, tags: $tags, universeIds: $universeIds, coverImageId: $coverImageId, imageIds: $imageIds, personality: $personality, appearance: $appearance, notes: $notes, speechStyle: $speechStyle, aiPrompt: $aiPrompt, storyIds: $storyIds, versionIds: $versionIds, relationships: $relationships, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CharacterCopyWith<$Res>  {
  factory $CharacterCopyWith(Character value, $Res Function(Character) _then) = _$CharacterCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> aliases, List<String> tags, List<String> universeIds, String? coverImageId, List<String> imageIds, String? personality, String? appearance, String? notes, String? speechStyle, String? aiPrompt, List<String> storyIds, List<String> versionIds, List<Relationship> relationships, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CharacterCopyWithImpl<$Res>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._self, this._then);

  final Character _self;
  final $Res Function(Character) _then;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? aliases = null,Object? tags = null,Object? universeIds = null,Object? coverImageId = freezed,Object? imageIds = null,Object? personality = freezed,Object? appearance = freezed,Object? notes = freezed,Object? speechStyle = freezed,Object? aiPrompt = freezed,Object? storyIds = null,Object? versionIds = null,Object? relationships = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,universeIds: null == universeIds ? _self.universeIds : universeIds // ignore: cast_nullable_to_non_nullable
as List<String>,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,personality: freezed == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as String?,appearance: freezed == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,speechStyle: freezed == speechStyle ? _self.speechStyle : speechStyle // ignore: cast_nullable_to_non_nullable
as String?,aiPrompt: freezed == aiPrompt ? _self.aiPrompt : aiPrompt // ignore: cast_nullable_to_non_nullable
as String?,storyIds: null == storyIds ? _self.storyIds : storyIds // ignore: cast_nullable_to_non_nullable
as List<String>,versionIds: null == versionIds ? _self.versionIds : versionIds // ignore: cast_nullable_to_non_nullable
as List<String>,relationships: null == relationships ? _self.relationships : relationships // ignore: cast_nullable_to_non_nullable
as List<Relationship>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Character].
extension CharacterPatterns on Character {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Character value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Character() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Character value)  $default,){
final _that = this;
switch (_that) {
case _Character():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Character value)?  $default,){
final _that = this;
switch (_that) {
case _Character() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> aliases,  List<String> tags,  List<String> universeIds,  String? coverImageId,  List<String> imageIds,  String? personality,  String? appearance,  String? notes,  String? speechStyle,  String? aiPrompt,  List<String> storyIds,  List<String> versionIds,  List<Relationship> relationships,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Character() when $default != null:
return $default(_that.id,_that.name,_that.aliases,_that.tags,_that.universeIds,_that.coverImageId,_that.imageIds,_that.personality,_that.appearance,_that.notes,_that.speechStyle,_that.aiPrompt,_that.storyIds,_that.versionIds,_that.relationships,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> aliases,  List<String> tags,  List<String> universeIds,  String? coverImageId,  List<String> imageIds,  String? personality,  String? appearance,  String? notes,  String? speechStyle,  String? aiPrompt,  List<String> storyIds,  List<String> versionIds,  List<Relationship> relationships,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Character():
return $default(_that.id,_that.name,_that.aliases,_that.tags,_that.universeIds,_that.coverImageId,_that.imageIds,_that.personality,_that.appearance,_that.notes,_that.speechStyle,_that.aiPrompt,_that.storyIds,_that.versionIds,_that.relationships,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> aliases,  List<String> tags,  List<String> universeIds,  String? coverImageId,  List<String> imageIds,  String? personality,  String? appearance,  String? notes,  String? speechStyle,  String? aiPrompt,  List<String> storyIds,  List<String> versionIds,  List<Relationship> relationships,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Character() when $default != null:
return $default(_that.id,_that.name,_that.aliases,_that.tags,_that.universeIds,_that.coverImageId,_that.imageIds,_that.personality,_that.appearance,_that.notes,_that.speechStyle,_that.aiPrompt,_that.storyIds,_that.versionIds,_that.relationships,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Character extends Character {
  const _Character({required this.id, required this.name, final  List<String> aliases = const <String>[], final  List<String> tags = const <String>[], final  List<String> universeIds = const <String>[], this.coverImageId, final  List<String> imageIds = const <String>[], this.personality, this.appearance, this.notes, this.speechStyle, this.aiPrompt, final  List<String> storyIds = const <String>[], final  List<String> versionIds = const <String>[], final  List<Relationship> relationships = const <Relationship>[], required this.createdAt, required this.updatedAt}): _aliases = aliases,_tags = tags,_universeIds = universeIds,_imageIds = imageIds,_storyIds = storyIds,_versionIds = versionIds,_relationships = relationships,super._();
  factory _Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

/// Stable unique identifier. Never changes after creation.
@override final  String id;
/// Primary display name, e.g. "Haru".
@override final  String name;
/// Alternate names / nicknames.
 final  List<String> _aliases;
/// Alternate names / nicknames.
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

/// User-assigned tags, used for filtering and search. Plaintext metadata.
 final  List<String> _tags;
/// User-assigned tags, used for filtering and search. Plaintext metadata.
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Universes this character appears in (a character is reused across
/// universes, unlike most other entities which belong to one).
 final  List<String> _universeIds;
/// Universes this character appears in (a character is reused across
/// universes, unlike most other entities which belong to one).
@override@JsonKey() List<String> get universeIds {
  if (_universeIds is EqualUnmodifiableListView) return _universeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_universeIds);
}

/// Cover image file id (see the local image store).
@override final  String? coverImageId;
/// Additional gallery image file ids.
 final  List<String> _imageIds;
/// Additional gallery image file ids.
@override@JsonKey() List<String> get imageIds {
  if (_imageIds is EqualUnmodifiableListView) return _imageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageIds);
}

/// Stable core personality. Per-version details override via versions.
@override final  String? personality;
/// Stable core appearance.
@override final  String? appearance;
/// Free-form notes about the character.
@override final  String? notes;
/// How the character tends to speak.
@override final  String? speechStyle;
/// Prompt template used when generating this character with AI.
@override final  String? aiPrompt;
/// Stories this character appears in (denormalized convenience list).
 final  List<String> _storyIds;
/// Stories this character appears in (denormalized convenience list).
@override@JsonKey() List<String> get storyIds {
  if (_storyIds is EqualUnmodifiableListView) return _storyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_storyIds);
}

/// All versions (incarnations) of this character.
 final  List<String> _versionIds;
/// All versions (incarnations) of this character.
@override@JsonKey() List<String> get versionIds {
  if (_versionIds is EqualUnmodifiableListView) return _versionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versionIds);
}

/// Relationships from this character to others. See [Relationship].
 final  List<Relationship> _relationships;
/// Relationships from this character to others. See [Relationship].
@override@JsonKey() List<Relationship> get relationships {
  if (_relationships is EqualUnmodifiableListView) return _relationships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relationships);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterCopyWith<_Character> get copyWith => __$CharacterCopyWithImpl<_Character>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Character&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._aliases, _aliases)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._universeIds, _universeIds)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&(identical(other.personality, personality) || other.personality == personality)&&(identical(other.appearance, appearance) || other.appearance == appearance)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.speechStyle, speechStyle) || other.speechStyle == speechStyle)&&(identical(other.aiPrompt, aiPrompt) || other.aiPrompt == aiPrompt)&&const DeepCollectionEquality().equals(other._storyIds, _storyIds)&&const DeepCollectionEquality().equals(other._versionIds, _versionIds)&&const DeepCollectionEquality().equals(other._relationships, _relationships)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_aliases),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_universeIds),coverImageId,const DeepCollectionEquality().hash(_imageIds),personality,appearance,notes,speechStyle,aiPrompt,const DeepCollectionEquality().hash(_storyIds),const DeepCollectionEquality().hash(_versionIds),const DeepCollectionEquality().hash(_relationships),createdAt,updatedAt);

@override
String toString() {
  return 'Character(id: $id, name: $name, aliases: $aliases, tags: $tags, universeIds: $universeIds, coverImageId: $coverImageId, imageIds: $imageIds, personality: $personality, appearance: $appearance, notes: $notes, speechStyle: $speechStyle, aiPrompt: $aiPrompt, storyIds: $storyIds, versionIds: $versionIds, relationships: $relationships, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CharacterCopyWith<$Res> implements $CharacterCopyWith<$Res> {
  factory _$CharacterCopyWith(_Character value, $Res Function(_Character) _then) = __$CharacterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> aliases, List<String> tags, List<String> universeIds, String? coverImageId, List<String> imageIds, String? personality, String? appearance, String? notes, String? speechStyle, String? aiPrompt, List<String> storyIds, List<String> versionIds, List<Relationship> relationships, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CharacterCopyWithImpl<$Res>
    implements _$CharacterCopyWith<$Res> {
  __$CharacterCopyWithImpl(this._self, this._then);

  final _Character _self;
  final $Res Function(_Character) _then;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? aliases = null,Object? tags = null,Object? universeIds = null,Object? coverImageId = freezed,Object? imageIds = null,Object? personality = freezed,Object? appearance = freezed,Object? notes = freezed,Object? speechStyle = freezed,Object? aiPrompt = freezed,Object? storyIds = null,Object? versionIds = null,Object? relationships = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Character(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,universeIds: null == universeIds ? _self._universeIds : universeIds // ignore: cast_nullable_to_non_nullable
as List<String>,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,personality: freezed == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as String?,appearance: freezed == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,speechStyle: freezed == speechStyle ? _self.speechStyle : speechStyle // ignore: cast_nullable_to_non_nullable
as String?,aiPrompt: freezed == aiPrompt ? _self.aiPrompt : aiPrompt // ignore: cast_nullable_to_non_nullable
as String?,storyIds: null == storyIds ? _self._storyIds : storyIds // ignore: cast_nullable_to_non_nullable
as List<String>,versionIds: null == versionIds ? _self._versionIds : versionIds // ignore: cast_nullable_to_non_nullable
as List<String>,relationships: null == relationships ? _self._relationships : relationships // ignore: cast_nullable_to_non_nullable
as List<Relationship>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
