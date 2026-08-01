// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Relationship {

/// The character this relationship points to.
 String get otherCharacterId;/// The kind of relationship.
 RelationshipType get type;/// Free text label used when [type] is [RelationshipType.custom].
 String? get customLabel;/// Optional notes about the relationship.
 String? get notes;
/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelationshipCopyWith<Relationship> get copyWith => _$RelationshipCopyWithImpl<Relationship>(this as Relationship, _$identity);

  /// Serializes this Relationship to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Relationship&&(identical(other.otherCharacterId, otherCharacterId) || other.otherCharacterId == otherCharacterId)&&(identical(other.type, type) || other.type == type)&&(identical(other.customLabel, customLabel) || other.customLabel == customLabel)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,otherCharacterId,type,customLabel,notes);

@override
String toString() {
  return 'Relationship(otherCharacterId: $otherCharacterId, type: $type, customLabel: $customLabel, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RelationshipCopyWith<$Res>  {
  factory $RelationshipCopyWith(Relationship value, $Res Function(Relationship) _then) = _$RelationshipCopyWithImpl;
@useResult
$Res call({
 String otherCharacterId, RelationshipType type, String? customLabel, String? notes
});




}
/// @nodoc
class _$RelationshipCopyWithImpl<$Res>
    implements $RelationshipCopyWith<$Res> {
  _$RelationshipCopyWithImpl(this._self, this._then);

  final Relationship _self;
  final $Res Function(Relationship) _then;

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otherCharacterId = null,Object? type = null,Object? customLabel = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
otherCharacterId: null == otherCharacterId ? _self.otherCharacterId : otherCharacterId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RelationshipType,customLabel: freezed == customLabel ? _self.customLabel : customLabel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Relationship].
extension RelationshipPatterns on Relationship {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Relationship value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Relationship() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Relationship value)  $default,){
final _that = this;
switch (_that) {
case _Relationship():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Relationship value)?  $default,){
final _that = this;
switch (_that) {
case _Relationship() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String otherCharacterId,  RelationshipType type,  String? customLabel,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Relationship() when $default != null:
return $default(_that.otherCharacterId,_that.type,_that.customLabel,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String otherCharacterId,  RelationshipType type,  String? customLabel,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Relationship():
return $default(_that.otherCharacterId,_that.type,_that.customLabel,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String otherCharacterId,  RelationshipType type,  String? customLabel,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Relationship() when $default != null:
return $default(_that.otherCharacterId,_that.type,_that.customLabel,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Relationship implements Relationship {
  const _Relationship({required this.otherCharacterId, required this.type, this.customLabel, this.notes});
  factory _Relationship.fromJson(Map<String, dynamic> json) => _$RelationshipFromJson(json);

/// The character this relationship points to.
@override final  String otherCharacterId;
/// The kind of relationship.
@override final  RelationshipType type;
/// Free text label used when [type] is [RelationshipType.custom].
@override final  String? customLabel;
/// Optional notes about the relationship.
@override final  String? notes;

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelationshipCopyWith<_Relationship> get copyWith => __$RelationshipCopyWithImpl<_Relationship>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RelationshipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Relationship&&(identical(other.otherCharacterId, otherCharacterId) || other.otherCharacterId == otherCharacterId)&&(identical(other.type, type) || other.type == type)&&(identical(other.customLabel, customLabel) || other.customLabel == customLabel)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,otherCharacterId,type,customLabel,notes);

@override
String toString() {
  return 'Relationship(otherCharacterId: $otherCharacterId, type: $type, customLabel: $customLabel, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RelationshipCopyWith<$Res> implements $RelationshipCopyWith<$Res> {
  factory _$RelationshipCopyWith(_Relationship value, $Res Function(_Relationship) _then) = __$RelationshipCopyWithImpl;
@override @useResult
$Res call({
 String otherCharacterId, RelationshipType type, String? customLabel, String? notes
});




}
/// @nodoc
class __$RelationshipCopyWithImpl<$Res>
    implements _$RelationshipCopyWith<$Res> {
  __$RelationshipCopyWithImpl(this._self, this._then);

  final _Relationship _self;
  final $Res Function(_Relationship) _then;

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otherCharacterId = null,Object? type = null,Object? customLabel = freezed,Object? notes = freezed,}) {
  return _then(_Relationship(
otherCharacterId: null == otherCharacterId ? _self.otherCharacterId : otherCharacterId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RelationshipType,customLabel: freezed == customLabel ? _self.customLabel : customLabel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
