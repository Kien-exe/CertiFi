// lib/features/profile/data/repositories/firebase_profile_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  const FirebaseProfileRepository(this._auth, this._firestore);

  @override
  Future<void> updateAvatarUrl(String url) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Chưa đăng nhập.');
    await _firestore.collection('users').doc(uid).set(
          {'avatarUrl': url},
          SetOptions(merge: true),
        );
  }

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
    // TODO(Sprint sau): reauthenticateWithCredential để xác minh
    // currentPassword trước khi updatePassword (cần EmailAuthProvider).
    await user.updatePassword(newPassword);
  }
}
