// lib/features/users/presentation/providers/user_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../data/repositories/firebase_user_repository.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirebaseUserRepository(FirebaseFirestore.instance);
});

final userSearchQueryProvider = StateProvider<String>((ref) => '');

final userListNotifierProvider =
    AsyncNotifierProvider<UserListNotifier, List<AppUser>>(
  UserListNotifier.new,
);

class UserListNotifier extends AsyncNotifier<List<AppUser>> {
  @override
  Future<List<AppUser>> build() async {
    final query = ref.watch(userSearchQueryProvider);
    return ref.watch(userRepositoryProvider).getUsers(searchQuery: query);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final query = ref.read(userSearchQueryProvider);
      return ref.read(userRepositoryProvider).getUsers(searchQuery: query);
    });
  }

  Future<AppUser> createUser(AppUser user, {required String password}) async {
    final created = await ref
        .read(userRepositoryProvider)
        .createUser(user, initialPassword: password);
    await refresh();
    return created;
  }

  Future<AppUser> updateUser(AppUser user) async {
    final updated = await ref.read(userRepositoryProvider).updateUser(user);
    await refresh();
    return updated;
  }

  Future<BulkActionResult> deleteUsers(Set<String> ids) async {
    final result = await ref
        .read(userRepositoryProvider)
        .deleteUsersBulk(ids);
    await refresh();
    return result;
  }
}
