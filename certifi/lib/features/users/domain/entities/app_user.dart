// lib/features/users/domain/entities/app_user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/auth_session.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum AccountStatus { active, locked }

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String employeeCode,
    required String fullName,
    required String email,
    required String phoneNumber,
    required UserRole role,
    required AccountStatus status,
    required DateTime lastLoginAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
