// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Stream<AuthSession?> watchAuthState();
  Future<AuthSession?> getCurrentSession();
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
