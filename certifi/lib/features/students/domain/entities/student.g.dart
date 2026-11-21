// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Student _$StudentFromJson(Map<String, dynamic> json) => _Student(
  id: json['id'] as String,
  studentCode: json['studentCode'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  major: json['major'] as String,
  age: (json['age'] as num).toInt(),
  gpa: (json['gpa'] as num).toDouble(),
  enrolledAt: DateTime.parse(json['enrolledAt'] as String),
  status:
      $enumDecodeNullable(_$StudentStatusEnumMap, json['status']) ??
      StudentStatus.active,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$StudentToJson(_Student instance) => <String, dynamic>{
  'id': instance.id,
  'studentCode': instance.studentCode,
  'fullName': instance.fullName,
  'email': instance.email,
  'major': instance.major,
  'age': instance.age,
  'gpa': instance.gpa,
  'enrolledAt': instance.enrolledAt.toIso8601String(),
  'status': _$StudentStatusEnumMap[instance.status]!,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'archivedAt': instance.archivedAt?.toIso8601String(),
};

const _$StudentStatusEnumMap = {
  StudentStatus.active: 'active',
  StudentStatus.inactive: 'inactive',
};
