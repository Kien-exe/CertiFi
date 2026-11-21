// lib/core/constants/app_durations.dart
class AppDurations {
  AppDurations._();

  /// Tốc độ phản hồi tức thời: Scale button, Shake validation, Checkbox (150ms)
  static const Duration fast = Duration(milliseconds: 150);

  /// Tốc độ chuyển cảnh chuẩn: Mở modal, trượt thanh Bulk Action, chuyển tab (200ms)
  static const Duration medium = Duration(milliseconds: 200);

  /// Giới hạn trần animation theo luật dự án (250ms)
  static const Duration slow = Duration(milliseconds: 250);

  /// Chu kỳ quét sáng của Skeleton Loading (không thuộc nhóm chuyển cảnh UI)
  static const Duration skeletonPulse = Duration(milliseconds: 1000);

  /// Thời gian hiển thị Toast Notification tự ẩn (3 giây)
  static const Duration toastVisible = Duration(seconds: 3);
}
