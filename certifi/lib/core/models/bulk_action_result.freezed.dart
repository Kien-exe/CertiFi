// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_action_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkActionResult {

 int get totalRequested; List<String> get succeededIds; Map<String, String> get failedReasons;
/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkActionResultCopyWith<BulkActionResult> get copyWith => _$BulkActionResultCopyWithImpl<BulkActionResult>(this as BulkActionResult, _$identity);

  /// Serializes this BulkActionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkActionResult&&(identical(other.totalRequested, totalRequested) || other.totalRequested == totalRequested)&&const DeepCollectionEquality().equals(other.succeededIds, succeededIds)&&const DeepCollectionEquality().equals(other.failedReasons, failedReasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalRequested,const DeepCollectionEquality().hash(succeededIds),const DeepCollectionEquality().hash(failedReasons));

@override
String toString() {
  return 'BulkActionResult(totalRequested: $totalRequested, succeededIds: $succeededIds, failedReasons: $failedReasons)';
}


}

/// @nodoc
abstract mixin class $BulkActionResultCopyWith<$Res>  {
  factory $BulkActionResultCopyWith(BulkActionResult value, $Res Function(BulkActionResult) _then) = _$BulkActionResultCopyWithImpl;
@useResult
$Res call({
 int totalRequested, List<String> succeededIds, Map<String, String> failedReasons
});




}
/// @nodoc
class _$BulkActionResultCopyWithImpl<$Res>
    implements $BulkActionResultCopyWith<$Res> {
  _$BulkActionResultCopyWithImpl(this._self, this._then);

  final BulkActionResult _self;
  final $Res Function(BulkActionResult) _then;

/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRequested = null,Object? succeededIds = null,Object? failedReasons = null,}) {
  return _then(_self.copyWith(
totalRequested: null == totalRequested ? _self.totalRequested : totalRequested // ignore: cast_nullable_to_non_nullable
as int,succeededIds: null == succeededIds ? _self.succeededIds : succeededIds // ignore: cast_nullable_to_non_nullable
as List<String>,failedReasons: null == failedReasons ? _self.failedReasons : failedReasons // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkActionResult].
extension BulkActionResultPatterns on BulkActionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkActionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkActionResult value)  $default,){
final _that = this;
switch (_that) {
case _BulkActionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkActionResult value)?  $default,){
final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalRequested,  List<String> succeededIds,  Map<String, String> failedReasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
return $default(_that.totalRequested,_that.succeededIds,_that.failedReasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalRequested,  List<String> succeededIds,  Map<String, String> failedReasons)  $default,) {final _that = this;
switch (_that) {
case _BulkActionResult():
return $default(_that.totalRequested,_that.succeededIds,_that.failedReasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalRequested,  List<String> succeededIds,  Map<String, String> failedReasons)?  $default,) {final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
return $default(_that.totalRequested,_that.succeededIds,_that.failedReasons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkActionResult extends BulkActionResult {
  const _BulkActionResult({required this.totalRequested, required final  List<String> succeededIds, required final  Map<String, String> failedReasons}): _succeededIds = succeededIds,_failedReasons = failedReasons,super._();
  factory _BulkActionResult.fromJson(Map<String, dynamic> json) => _$BulkActionResultFromJson(json);

@override final  int totalRequested;
 final  List<String> _succeededIds;
@override List<String> get succeededIds {
  if (_succeededIds is EqualUnmodifiableListView) return _succeededIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_succeededIds);
}

 final  Map<String, String> _failedReasons;
@override Map<String, String> get failedReasons {
  if (_failedReasons is EqualUnmodifiableMapView) return _failedReasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failedReasons);
}


/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkActionResultCopyWith<_BulkActionResult> get copyWith => __$BulkActionResultCopyWithImpl<_BulkActionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkActionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkActionResult&&(identical(other.totalRequested, totalRequested) || other.totalRequested == totalRequested)&&const DeepCollectionEquality().equals(other._succeededIds, _succeededIds)&&const DeepCollectionEquality().equals(other._failedReasons, _failedReasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalRequested,const DeepCollectionEquality().hash(_succeededIds),const DeepCollectionEquality().hash(_failedReasons));

@override
String toString() {
  return 'BulkActionResult(totalRequested: $totalRequested, succeededIds: $succeededIds, failedReasons: $failedReasons)';
}


}

/// @nodoc
abstract mixin class _$BulkActionResultCopyWith<$Res> implements $BulkActionResultCopyWith<$Res> {
  factory _$BulkActionResultCopyWith(_BulkActionResult value, $Res Function(_BulkActionResult) _then) = __$BulkActionResultCopyWithImpl;
@override @useResult
$Res call({
 int totalRequested, List<String> succeededIds, Map<String, String> failedReasons
});




}
/// @nodoc
class __$BulkActionResultCopyWithImpl<$Res>
    implements _$BulkActionResultCopyWith<$Res> {
  __$BulkActionResultCopyWithImpl(this._self, this._then);

  final _BulkActionResult _self;
  final $Res Function(_BulkActionResult) _then;

/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRequested = null,Object? succeededIds = null,Object? failedReasons = null,}) {
  return _then(_BulkActionResult(
totalRequested: null == totalRequested ? _self.totalRequested : totalRequested // ignore: cast_nullable_to_non_nullable
as int,succeededIds: null == succeededIds ? _self._succeededIds : succeededIds // ignore: cast_nullable_to_non_nullable
as List<String>,failedReasons: null == failedReasons ? _self._failedReasons : failedReasons // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
