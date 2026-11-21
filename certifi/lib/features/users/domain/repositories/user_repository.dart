// lib/features/users/domain/repositories/user_repository.dart
import '../../../../core/models/bulk_action_result.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../entities/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getUsers({
    String? searchQuery,
    UserRole? roleFilter,
    AccountStatus? statusFilter,
  });

  Future<AppUser> getUserById(String userId);
  Future<AppUser> createUser(AppUser user, {required String initialPassword});
  Future<AppUser> updateUser(AppUser user);
  Future<BulkActionResult> updateStatusBulk({
    required Set<String> userIds,
    required AccountStatus status,
  });
  Future<BulkActionResult> deleteUsersBulk(Set<String> userIds);
}
