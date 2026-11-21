// lib/features/profile/domain/repositories/profile_repository.dart
/// Hợp đồng tầng Domain cho hồ sơ cá nhân.
abstract class ProfileRepository {
  /// Cập nhật ảnh đại diện (URL sau khi upload).
  Future<void> updateAvatarUrl(String url);

  /// Đổi mật khẩu — ném Exception nếu mật khẩu cũ sai hoặc quá ngắn.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
