// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  employeeCode: json['employeeCode'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'employeeCode': instance.employeeCode,
  'fullName': instance.fullName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'role': _$UserRoleEnumMap[instance.role]!,
  'status': _$AccountStatusEnumMap[instance.status]!,
  'lastLoginAt': instance.lastLoginAt.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.manager: 'manager',
  UserRole.employee: 'employee',
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.locked: 'locked',
};
