// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Student {

 String get id; String get studentCode; String get fullName; String get email; String get major; int get age; double get gpa; DateTime get enrolledAt; StudentStatus get status; DateTime? get updatedAt;// Soft delete: khi xóa chỉ set archivedAt, giữ lịch sử tra cứu
 DateTime? get archivedAt;
/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCopyWith<Student> get copyWith => _$StudentCopyWithImpl<Student>(this as Student, _$identity);

  /// Serializes this Student to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Student&&(identical(other.id, id) || other.id == id)&&(identical(other.studentCode, studentCode) || other.studentCode == studentCode)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.major, major) || other.major == major)&&(identical(other.age, age) || other.age == age)&&(identical(other.gpa, gpa) || other.gpa == gpa)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentCode,fullName,email,major,age,gpa,enrolledAt,status,updatedAt,archivedAt);

@override
String toString() {
  return 'Student(id: $id, studentCode: $studentCode, fullName: $fullName, email: $email, major: $major, age: $age, gpa: $gpa, enrolledAt: $enrolledAt, status: $status, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $StudentCopyWith<$Res>  {
  factory $StudentCopyWith(Student value, $Res Function(Student) _then) = _$StudentCopyWithImpl;
@useResult
$Res call({
 String id, String studentCode, String fullName, String email, String major, int age, double gpa, DateTime enrolledAt, StudentStatus status, DateTime? updatedAt, DateTime? archivedAt
});




}
/// @nodoc
class _$StudentCopyWithImpl<$Res>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._self, this._then);

  final Student _self;
  final $Res Function(Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentCode = null,Object? fullName = null,Object? email = null,Object? major = null,Object? age = null,Object? gpa = null,Object? enrolledAt = null,Object? status = null,Object? updatedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentCode: null == studentCode ? _self.studentCode : studentCode // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gpa: null == gpa ? _self.gpa : gpa // ignore: cast_nullable_to_non_nullable
as double,enrolledAt: null == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentStatus,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Student].
extension StudentPatterns on Student {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Student value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Student value)  $default,){
final _that = this;
switch (_that) {
case _Student():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Student value)?  $default,){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentCode,  String fullName,  String email,  String major,  int age,  double gpa,  DateTime enrolledAt,  StudentStatus status,  DateTime? updatedAt,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.studentCode,_that.fullName,_that.email,_that.major,_that.age,_that.gpa,_that.enrolledAt,_that.status,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentCode,  String fullName,  String email,  String major,  int age,  double gpa,  DateTime enrolledAt,  StudentStatus status,  DateTime? updatedAt,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Student():
return $default(_that.id,_that.studentCode,_that.fullName,_that.email,_that.major,_that.age,_that.gpa,_that.enrolledAt,_that.status,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentCode,  String fullName,  String email,  String major,  int age,  double gpa,  DateTime enrolledAt,  StudentStatus status,  DateTime? updatedAt,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.studentCode,_that.fullName,_that.email,_that.major,_that.age,_that.gpa,_that.enrolledAt,_that.status,_that.updatedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Student implements Student {
  const _Student({required this.id, required this.studentCode, required this.fullName, required this.email, required this.major, required this.age, required this.gpa, required this.enrolledAt, this.status = StudentStatus.active, this.updatedAt, this.archivedAt});
  factory _Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

@override final  String id;
@override final  String studentCode;
@override final  String fullName;
@override final  String email;
@override final  String major;
@override final  int age;
@override final  double gpa;
@override final  DateTime enrolledAt;
@override@JsonKey() final  StudentStatus status;
@override final  DateTime? updatedAt;
// Soft delete: khi xóa chỉ set archivedAt, giữ lịch sử tra cứu
@override final  DateTime? archivedAt;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCopyWith<_Student> get copyWith => __$StudentCopyWithImpl<_Student>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Student&&(identical(other.id, id) || other.id == id)&&(identical(other.studentCode, studentCode) || other.studentCode == studentCode)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.major, major) || other.major == major)&&(identical(other.age, age) || other.age == age)&&(identical(other.gpa, gpa) || other.gpa == gpa)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentCode,fullName,email,major,age,gpa,enrolledAt,status,updatedAt,archivedAt);

@override
String toString() {
  return 'Student(id: $id, studentCode: $studentCode, fullName: $fullName, email: $email, major: $major, age: $age, gpa: $gpa, enrolledAt: $enrolledAt, status: $status, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$StudentCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$StudentCopyWith(_Student value, $Res Function(_Student) _then) = __$StudentCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentCode, String fullName, String email, String major, int age, double gpa, DateTime enrolledAt, StudentStatus status, DateTime? updatedAt, DateTime? archivedAt
});




}
/// @nodoc
class __$StudentCopyWithImpl<$Res>
    implements _$StudentCopyWith<$Res> {
  __$StudentCopyWithImpl(this._self, this._then);

  final _Student _self;
  final $Res Function(_Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentCode = null,Object? fullName = null,Object? email = null,Object? major = null,Object? age = null,Object? gpa = null,Object? enrolledAt = null,Object? status = null,Object? updatedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_Student(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentCode: null == studentCode ? _self.studentCode : studentCode // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gpa: null == gpa ? _self.gpa : gpa // ignore: cast_nullable_to_non_nullable
as double,enrolledAt: null == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudentStatus,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
