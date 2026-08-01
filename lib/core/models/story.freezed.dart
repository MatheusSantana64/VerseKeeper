// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Story {

 String get id; String get title; String? get universeId; String? get summary; String? get notes; String? get coverImageId; List<String> get imageIds; List<String> get tags;/// Genre/hardcoded tone hints, e.g. "romance", "dark fantasy".
 List<String> get genres;/// Free form publication/status label (draft, finished, ...).
 String? get status;/// The characters (and optionally which incarnation) that appear.
 List<StoryAppearance> get appearances; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCopyWith<Story> get copyWith => _$StoryCopyWithImpl<Story>(this as Story, _$identity);

  /// Serializes this Story to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.appearances, appearances)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,universeId,summary,notes,coverImageId,const DeepCollectionEquality().hash(imageIds),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(genres),status,const DeepCollectionEquality().hash(appearances),createdAt,updatedAt);

@override
String toString() {
  return 'Story(id: $id, title: $title, universeId: $universeId, summary: $summary, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, genres: $genres, status: $status, appearances: $appearances, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StoryCopyWith<$Res>  {
  factory $StoryCopyWith(Story value, $Res Function(Story) _then) = _$StoryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? universeId, String? summary, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, List<String> genres, String? status, List<StoryAppearance> appearances, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StoryCopyWithImpl<$Res>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._self, this._then);

  final Story _self;
  final $Res Function(Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? universeId = freezed,Object? summary = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? genres = null,Object? status = freezed,Object? appearances = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,appearances: null == appearances ? _self.appearances : appearances // ignore: cast_nullable_to_non_nullable
as List<StoryAppearance>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Story].
extension StoryPatterns on Story {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Story value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Story() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Story value)  $default,){
final _that = this;
switch (_that) {
case _Story():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Story value)?  $default,){
final _that = this;
switch (_that) {
case _Story() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? universeId,  String? summary,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  List<String> genres,  String? status,  List<StoryAppearance> appearances,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.universeId,_that.summary,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.genres,_that.status,_that.appearances,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? universeId,  String? summary,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  List<String> genres,  String? status,  List<StoryAppearance> appearances,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Story():
return $default(_that.id,_that.title,_that.universeId,_that.summary,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.genres,_that.status,_that.appearances,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? universeId,  String? summary,  String? notes,  String? coverImageId,  List<String> imageIds,  List<String> tags,  List<String> genres,  String? status,  List<StoryAppearance> appearances,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.universeId,_that.summary,_that.notes,_that.coverImageId,_that.imageIds,_that.tags,_that.genres,_that.status,_that.appearances,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Story extends Story {
  const _Story({required this.id, required this.title, this.universeId, this.summary, this.notes, this.coverImageId, final  List<String> imageIds = const <String>[], final  List<String> tags = const <String>[], final  List<String> genres = const <String>[], this.status, final  List<StoryAppearance> appearances = const <StoryAppearance>[], required this.createdAt, required this.updatedAt}): _imageIds = imageIds,_tags = tags,_genres = genres,_appearances = appearances,super._();
  factory _Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? universeId;
@override final  String? summary;
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

/// Genre/hardcoded tone hints, e.g. "romance", "dark fantasy".
 final  List<String> _genres;
/// Genre/hardcoded tone hints, e.g. "romance", "dark fantasy".
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

/// Free form publication/status label (draft, finished, ...).
@override final  String? status;
/// The characters (and optionally which incarnation) that appear.
 final  List<StoryAppearance> _appearances;
/// The characters (and optionally which incarnation) that appear.
@override@JsonKey() List<StoryAppearance> get appearances {
  if (_appearances is EqualUnmodifiableListView) return _appearances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appearances);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCopyWith<_Story> get copyWith => __$StoryCopyWithImpl<_Story>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.universeId, universeId) || other.universeId == universeId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._appearances, _appearances)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,universeId,summary,notes,coverImageId,const DeepCollectionEquality().hash(_imageIds),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_genres),status,const DeepCollectionEquality().hash(_appearances),createdAt,updatedAt);

@override
String toString() {
  return 'Story(id: $id, title: $title, universeId: $universeId, summary: $summary, notes: $notes, coverImageId: $coverImageId, imageIds: $imageIds, tags: $tags, genres: $genres, status: $status, appearances: $appearances, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StoryCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$StoryCopyWith(_Story value, $Res Function(_Story) _then) = __$StoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? universeId, String? summary, String? notes, String? coverImageId, List<String> imageIds, List<String> tags, List<String> genres, String? status, List<StoryAppearance> appearances, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StoryCopyWithImpl<$Res>
    implements _$StoryCopyWith<$Res> {
  __$StoryCopyWithImpl(this._self, this._then);

  final _Story _self;
  final $Res Function(_Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? universeId = freezed,Object? summary = freezed,Object? notes = freezed,Object? coverImageId = freezed,Object? imageIds = null,Object? tags = null,Object? genres = null,Object? status = freezed,Object? appearances = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Story(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,universeId: freezed == universeId ? _self.universeId : universeId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,appearances: null == appearances ? _self._appearances : appearances // ignore: cast_nullable_to_non_nullable
as List<StoryAppearance>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
