// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  signedInAt: DateTime.parse(json['signedInAt'] as String),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'signedInAt': instance.signedInAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.manager: 'manager',
  UserRole.employee: 'employee',
};
