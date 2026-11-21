// lib/features/auth/data/repositories/firebase_auth_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  const FirebaseAuthRepository(this._auth, this._firestore);

  /// Resolve role từ collection `users` theo email.
  /// Mặc định `employee` nếu chưa có hồ sơ (xem docs/lecturer_qa_checklist.md).
  Future<UserRole> _resolveRole(String email) async {
    try {
      final snap = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return UserRole.employee;
      final roleStr = snap.docs.first.data()['role'] as String?;
      return UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.employee,
      );
    } catch (_) {
      return UserRole.employee;
    }
  }

  Future<AuthSession?> _toSession(fb.User? user) async {
    if (user == null) return null;
    final role = await _resolveRole(user.email ?? '');
    return AuthSession(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? user.email?.split('@').first ?? 'User',
      role: role,
      signedInAt: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  @override
  Stream<AuthSession?> watchAuthState() =>
      _auth.authStateChanges().asyncMap(_toSession);

  @override
  Future<AuthSession?> getCurrentSession() => _toSession(_auth.currentUser);

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final session = await _toSession(cred.user);
    if (session == null) {
      throw Exception('Đăng nhập thất bại. Vui lòng thử lại.');
    }
    return session;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập.');
    if (newPassword.length < 6) {
      throw Exception('Mật khẩu mới phải có ít nhất 6 ký tự.');
    }
    // TODO: reauthenticateWithCredential để xác minh currentPassword
    // trước khi updatePassword (cần EmailAuthProvider credential).
    await user.updatePassword(newPassword);
  }
}
