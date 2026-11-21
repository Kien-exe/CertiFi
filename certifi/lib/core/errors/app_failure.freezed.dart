// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure()';
}


}

/// @nodoc
class $AppFailureCopyWith<$Res>  {
$AppFailureCopyWith(AppFailure _, $Res Function(AppFailure) __);
}


/// Adds pattern-matching-related methods to [AppFailure].
extension AppFailurePatterns on AppFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( PermissionDeniedFailure value)?  permissionDenied,TResult Function( NotFoundFailure value)?  notFound,TResult Function( ValidationFailure value)?  validation,TResult Function( ConflictFailure value)?  conflict,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ValidationFailure() when validation != null:
return validation(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( PermissionDeniedFailure value)  permissionDenied,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( ValidationFailure value)  validation,required TResult Function( ConflictFailure value)  conflict,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case PermissionDeniedFailure():
return permissionDenied(_that);case NotFoundFailure():
return notFound(_that);case ValidationFailure():
return validation(_that);case ConflictFailure():
return conflict(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( PermissionDeniedFailure value)?  permissionDenied,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( ValidationFailure value)?  validation,TResult? Function( ConflictFailure value)?  conflict,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ValidationFailure() when validation != null:
return validation(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  network,TResult Function( String message)?  permissionDenied,TResult Function( String entityName,  String entityId)?  notFound,TResult Function( String field,  String message)?  validation,TResult Function( String message)?  conflict,TResult Function( String message,  Object? rawError)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message);case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that.message);case NotFoundFailure() when notFound != null:
return notFound(_that.entityName,_that.entityId);case ValidationFailure() when validation != null:
return validation(_that.field,_that.message);case ConflictFailure() when conflict != null:
return conflict(_that.message);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.rawError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  network,required TResult Function( String message)  permissionDenied,required TResult Function( String entityName,  String entityId)  notFound,required TResult Function( String field,  String message)  validation,required TResult Function( String message)  conflict,required TResult Function( String message,  Object? rawError)  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that.message);case PermissionDeniedFailure():
return permissionDenied(_that.message);case NotFoundFailure():
return notFound(_that.entityName,_that.entityId);case ValidationFailure():
return validation(_that.field,_that.message);case ConflictFailure():
return conflict(_that.message);case UnknownFailure():
return unknown(_that.message,_that.rawError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  network,TResult? Function( String message)?  permissionDenied,TResult? Function( String entityName,  String entityId)?  notFound,TResult? Function( String field,  String message)?  validation,TResult? Function( String message)?  conflict,TResult? Function( String message,  Object? rawError)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message);case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that.message);case NotFoundFailure() when notFound != null:
return notFound(_that.entityName,_that.entityId);case ValidationFailure() when validation != null:
return validation(_that.field,_that.message);case ConflictFailure() when conflict != null:
return conflict(_that.message);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.rawError);case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure extends AppFailure {
  const NetworkFailure({this.message = 'Mất kết nối mạng. Vui lòng kiểm tra đường truyền và thử lại.'}): super._();
  

@JsonKey() final  String message;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppFailure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PermissionDeniedFailure extends AppFailure {
  const PermissionDeniedFailure({this.message = 'Bạn không có quyền thực hiện thao tác này.'}): super._();
  

@JsonKey() final  String message;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionDeniedFailureCopyWith<PermissionDeniedFailure> get copyWith => _$PermissionDeniedFailureCopyWithImpl<PermissionDeniedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionDeniedFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppFailure.permissionDenied(message: $message)';
}


}

/// @nodoc
abstract mixin class $PermissionDeniedFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $PermissionDeniedFailureCopyWith(PermissionDeniedFailure value, $Res Function(PermissionDeniedFailure) _then) = _$PermissionDeniedFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PermissionDeniedFailureCopyWithImpl<$Res>
    implements $PermissionDeniedFailureCopyWith<$Res> {
  _$PermissionDeniedFailureCopyWithImpl(this._self, this._then);

  final PermissionDeniedFailure _self;
  final $Res Function(PermissionDeniedFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PermissionDeniedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NotFoundFailure extends AppFailure {
  const NotFoundFailure({required this.entityName, required this.entityId}): super._();
  

 final  String entityName;
 final  String entityId;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundFailureCopyWith<NotFoundFailure> get copyWith => _$NotFoundFailureCopyWithImpl<NotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure&&(identical(other.entityName, entityName) || other.entityName == entityName)&&(identical(other.entityId, entityId) || other.entityId == entityId));
}


@override
int get hashCode => Object.hash(runtimeType,entityName,entityId);

@override
String toString() {
  return 'AppFailure.notFound(entityName: $entityName, entityId: $entityId)';
}


}

/// @nodoc
abstract mixin class $NotFoundFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $NotFoundFailureCopyWith(NotFoundFailure value, $Res Function(NotFoundFailure) _then) = _$NotFoundFailureCopyWithImpl;
@useResult
$Res call({
 String entityName, String entityId
});




}
/// @nodoc
class _$NotFoundFailureCopyWithImpl<$Res>
    implements $NotFoundFailureCopyWith<$Res> {
  _$NotFoundFailureCopyWithImpl(this._self, this._then);

  final NotFoundFailure _self;
  final $Res Function(NotFoundFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entityName = null,Object? entityId = null,}) {
  return _then(NotFoundFailure(
entityName: null == entityName ? _self.entityName : entityName // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidationFailure extends AppFailure {
  const ValidationFailure({required this.field, required this.message}): super._();
  

 final  String field;
 final  String message;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'AppFailure.validation(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field = null,Object? message = null,}) {
  return _then(ValidationFailure(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ConflictFailure extends AppFailure {
  const ConflictFailure({required this.message}): super._();
  

 final  String message;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictFailureCopyWith<ConflictFailure> get copyWith => _$ConflictFailureCopyWithImpl<ConflictFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppFailure.conflict(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConflictFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $ConflictFailureCopyWith(ConflictFailure value, $Res Function(ConflictFailure) _then) = _$ConflictFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConflictFailureCopyWithImpl<$Res>
    implements $ConflictFailureCopyWith<$Res> {
  _$ConflictFailureCopyWithImpl(this._self, this._then);

  final ConflictFailure _self;
  final $Res Function(ConflictFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConflictFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnknownFailure extends AppFailure {
  const UnknownFailure({this.message = 'Đã xảy ra lỗi cơ sở dữ liệu không xác định.', this.rawError}): super._();
  

@JsonKey() final  String message;
 final  Object? rawError;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.rawError, rawError));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(rawError));

@override
String toString() {
  return 'AppFailure.unknown(message: $message, rawError: $rawError)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@useResult
$Res call({
 String message, Object? rawError
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? rawError = freezed,}) {
  return _then(UnknownFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,rawError: freezed == rawError ? _self.rawError : rawError ,
  ));
}


}

// dart format on
