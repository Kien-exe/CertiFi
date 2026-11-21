// lib/features/auth/domain/entities/auth_session.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

enum UserRole { admin, manager, employee }

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String uid,
    required String email,
    required String displayName,
    required UserRole role,
    required DateTime signedInAt,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
