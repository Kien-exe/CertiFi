// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

/// Inject AuthRepository — UI không phụ thuộc trực tiếp FirebaseAuth
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

/// Trạng thái đăng nhập hiện tại (null = chưa đăng nhập)
final currentUserProvider = StreamProvider<AuthSession?>((ref) {
  return ref.watch(authRepositoryProvider).watchAuthState();
});

/// Trạng thái xử lý nút Login (chống double-submit, hiển thị skeleton)
final isLoggingInProvider = StateProvider<bool>((ref) => false);

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthSession?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    return ref.watch(authRepositoryProvider).getCurrentSession();
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(authRepositoryProvider).signInWithEmail(
            email: email,
            password: password,
          );
    });
    return !state.hasError;
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await ref.read(authRepositoryProvider).changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
  }
}
