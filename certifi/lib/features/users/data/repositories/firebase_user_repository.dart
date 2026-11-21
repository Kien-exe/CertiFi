// lib/features/users/data/repositories/firebase_user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart' as core;
import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../../firebase_options.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users');

  core.FirebaseApp? _secondaryApp;

  /// Secondary FirebaseApp để tạo Auth user mới mà KHÔNG đăng xuất
  /// phiên Admin hiện tại (xem docs/lecturer_qa_checklist.md).
  Future<fb.FirebaseAuth> _secondaryAuth() async {
    _secondaryApp ??= await core.Firebase.initializeApp(
      name: 'user-creation',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return fb.FirebaseAuth.instanceFor(app: _secondaryApp!);
  }

  AppUser _docToUser(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppUser.fromJson({
      ...data,
      'id': doc.id,
      'lastLoginAt': (data['lastLoginAt'] is Timestamp)
          ? (data['lastLoginAt'] as Timestamp).toDate().toIso8601String()
          : (data['lastLoginAt'] as String? ??
              DateTime.fromMillisecondsSinceEpoch(0).toIso8601String()),
    });
  }

  AppFailure _mapError(Object e, String fallback) {
    if (e is FirebaseException) {
      if (e.code == 'permission-denied') {
        return const AppFailure.permissionDenied();
      }
      return AppFailure.unknown(message: e.message ?? fallback, rawError: e);
    }
    return AppFailure.unknown(message: fallback, rawError: e);
  }

  @override
  Future<List<AppUser>> getUsers({
    String? searchQuery,
    UserRole? roleFilter,
    AccountStatus? statusFilter,
  }) async {
    final snapshot = await _collection.get();
    var users = snapshot.docs.map(_docToUser).toList();

    if (roleFilter != null) {
      users = users.where((u) => u.role == roleFilter).toList();
    }
    if (statusFilter != null) {
      users = users.where((u) => u.status == statusFilter).toList();
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      users = users.where((u) {
        return u.employeeCode.toLowerCase().contains(q) ||
            u.fullName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q) ||
            u.phoneNumber.contains(q);
      }).toList();
    }
    users.sort((a, b) => a.employeeCode.compareTo(b.employeeCode));
    return users;
  }

  @override
  Future<AppUser> getUserById(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      throw AppFailure.notFound(entityName: 'người dùng', entityId: userId);
    }
    return _docToUser(doc);
  }

  @override
  Future<AppUser> createUser(AppUser user, {required String initialPassword}) async {
    try {
      // 1. Tạo Firebase Auth account qua Secondary App (không logout admin)
      final cred = await (await _secondaryAuth())
          .createUserWithEmailAndPassword(
        email: user.email.trim(),
        password: initialPassword,
      );
      final uid = cred.user!.uid;

      // 2. Ghi hồ sơ vào collection users với id = uid
      final data = user.toJson()..remove('id');
      await _collection.doc(uid).set(data);

      return user.copyWith(id: uid);
    } catch (e) {
      throw _mapError(e, 'Không thể tạo tài khoản người dùng.');
    }
  }

  @override
  Future<AppUser> updateUser(AppUser user) async {
    try {
      final data = user.toJson()..remove('id');
      await _collection.doc(user.id).set(data, SetOptions(merge: true));
      return user;
    } catch (e) {
      throw _mapError(e, 'Không thể cập nhật người dùng.');
    }
  }

  @override
  Future<BulkActionResult> updateStatusBulk({
    required Set<String> userIds,
    required AccountStatus status,
  }) async {
    final succeeded = <String>[];
    final failed = <String, String>{};

    for (final id in userIds) {
      try {
        await _collection.doc(id).update({'status': status.name});
        succeeded.add(id);
      } catch (e) {
        failed[id] = e.toString();
      }
    }

    return BulkActionResult(
      totalRequested: userIds.length,
      succeededIds: succeeded,
      failedReasons: failed,
    );
  }

  @override
  Future<BulkActionResult> deleteUsersBulk(Set<String> userIds) async {
    final succeeded = <String>[];
    final failed = <String, String>{};

    for (final id in userIds) {
      try {
        await _collection.doc(id).delete();
        succeeded.add(id);
      } catch (e) {
        failed[id] = e.toString();
      }
    }

    return BulkActionResult(
      totalRequested: userIds.length,
      succeededIds: succeeded,
      failedReasons: failed,
    );
  }
}
