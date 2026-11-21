# Student Management App — Sprint 1: Design System, Figma Blueprint & Clean Architecture Setup

Tài liệu kỹ thuật và bộ mã nguồn Production-Ready cho Sprint khởi tạo dự án **Student Management App**, tuân thủ nghiêm ngặt kiến trúc **Feature-First Clean Architecture**, **Typography-driven Data Table UI**, **Micro-interactions (150ms–250ms)** và tiêu chuẩn **4 trạng thái hoàn thành (DoD)**.

## 1. Cấu trúc File khởi tạo & Đặc tả Thiết kế (Figma + Design System)

### 1.1. Lệnh khởi tạo Project & Cài đặt Dependencies

```bash
# Tạo project với cấu trúc chuẩn
flutter create --org com.edu.studentmgmt student_management_app
cd student_management_app

# Cài đặt State Management, Routing, Firebase & UI Fonts
flutter pub add flutter_riverpod hooks_riverpod go_router google_fonts
flutter pub add firebase_core firebase_auth cloud_firestore
flutter pub add freezed_annotation json_annotation

# Cài đặt Code Generators ở dev_dependencies
flutter pub add --dev build_runner freezed json_serializable flutter_lints
```

### 1.2. Cấu trúc thư mục (Clean Architecture + Feature-First)

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   └── app_durations.dart            # Khóa cứng animation 150ms - 250ms, Toast 3s
│   ├── router/
│   │   └── app_router.dart               # Cấu hình GoRouter + PageTransition 200ms
│   ├── theme/
│   │   ├── app_colors.dart               # Semantic Color Tokens (Material 3)
│   │   ├── app_spacing.dart              # Hệ lưới 4px/8px & Layout Breakpoints
│   │   ├── app_typography.dart           # Inter + JetBrains Mono (tabular-nums)
│   │   └── app_theme.dart                # ThemeData Material 3 (Light/Dark)
│   └── widgets/
│       ├── adaptive_shell.dart           # NavigationRail (Desktop/Tablet) & NavigationBar (Mobile)
│       ├── app_data_table.dart           # Sticky Header + Ellipsis Tooltip + Bulk Checkbox
│       ├── app_skeleton.dart             # Skeleton Shimmer (thay thế hoàn toàn Spinner)
│       ├── app_toast.dart                # Overlay Toast tự ẩn sau 3s
│       ├── dod_state_builder.dart        # Bộ khung bắt buộc đủ 4 trạng thái DoD
│       ├── scale_button.dart             # Nút bấm scale 0.95 + Ripple (150ms)
│       └── shake_widget.dart             # Hiệu ứng rung lắc 150ms khi lỗi Form Validation
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/user_dto.dart
    │   │   └── repositories/firebase_auth_repository.dart
    │   ├── domain/
    │   │   ├── entities/auth_user.dart
    │   │   └── repositories/auth_repository.dart
    │   └── presentation/
    │       ├── providers/auth_notifier.dart
    │       └── screens/login_screen.dart
    ├── home/
    │   ├── data/...
    │   ├── domain/...
    │   └── presentation/screens/home_screen.dart
    ├── users/
    │   ├── data/...
    │   ├── domain/repositories/user_repository.dart
    │   └── presentation/screens/user_list_screen.dart
    ├── students/
    │   ├── data/
    │   │   └── repositories/firebase_student_repository.dart
    │   ├── domain/
    │   │   ├── entities/student.dart
    │   │   ├── entities/student.freezed.dart
    │   │   ├── entities/student.g.dart
    │   │   └── repositories/student_repository.dart
    │   └── presentation/
    │       ├── providers/student_providers.dart
    │       └── screens/
    │           ├── student_list_screen.dart
    │           └── student_detail_screen.dart
    └── profile/
        ├── data/...
        ├── domain/repositories/profile_repository.dart
        └── presentation/screens/profile_screen.dart
```

### 1.3. Chốt Design System (Tokens & Quy chuẩn)

| Hạng mục | Token / Quy chuẩn | Giá trị kỹ thuật | Quy tắc áp dụng bắt buộc |
| :--- | :--- | :--- | :--- |
| **Primary Color** | `AppColors.primary` | `#1E40AF` (Blue 800) | Thanh điều hướng, nút CTA chính, trạng thái Checkbox chọn |
| **Surface / Canvas** | `AppColors.surface` / `bg` | `#FFFFFF` / `#F8FAFC` | Nền bảng dữ liệu trắng tinh; nền trang xám lạnh nhẹ tăng độ tương phản |
| **Border / Divider** | `AppColors.border` | `#E2E8F0` (Slate 200) | Đường kẻ bảng `1px` sắc nét, phân tách Sticky Header và các dòng dữ liệu |
| **Semantic Status** | `success` / `warning` / `error` | `#15803D` / `#B45309` / `#B91C1C` | Dùng cho Toast Notification, trạng thái học tập và cảnh báo Form |
| **Font Văn bản** | `Inter` | Weight `400`, `500`, `600` | Toàn bộ tiêu đề, nhãn điều hướng, họ tên, email, mô tả |
| **Font Số liệu** | `JetBrains Mono` | `FontFeature.tabularFigures()` | Bắt buộc cho cột GPA, tuổi, mã SV, số điện thoại, ngày giờ (`tabular-nums`) |
| **Type Scale** | Khóa cứng 4 cấp độ | `12px`, `14px`, `16px`, `20px–24px` | Small (`12px`), Body (`14px`), Sub-heading (`16px`), Heading (`20px–24px`) |
| **Spacing Grid** | Base `4px` | `4, 8, 12, 16, 24, 32px` | Padding ô bảng: ngang `16px`, dọc `12px`; chiều cao dòng chuẩn `48px` |
| **Micro-motion** | `AppDurations` | `150ms` – `250ms` | Scale nút & Shake form: `150ms`; Chuyển trang & trượt thanh Bulk: `200ms` |

### 1.4. Đặc tả Wireframe / Mockup trên Figma (6 Màn hình)

Thiết kế Figma sử dụng **Standard Layout** với hệ lưới 12 cột trên Desktop (`1440x900`, Margin `24px`, Gutter `16px`) và 4 cột trên Mobile (`390x844`, Margin `16px`, Gutter `12px`), loại bỏ hoàn toàn Bento Grid:

| Màn hình | Bố cục khung (Standard Layout) | Thành phần dữ liệu & Tương tác trọng tâm |
| :--- | :--- | :--- |
| **1. Login** | Centered Card (`420px` max-width) đặt trên nền `surfaceBackground` | Form Email/Password bọc trong `ShakeWidget` (rung `150ms` khi sai định dạng); nút Đăng nhập dùng `AppScaleButton` (`0.95`); khi chờ xác thực hiển thị thanh Skeleton Mờ trên form thay vì vòng xoay Spinner. |
| **2. Home** | `NavigationRail` (trái) + Khu vực nội dung chính chia 2 tầng dọc | Tầng 1: Dải 4 thẻ chỉ số tổng quan ngang hàng (Tổng SV, GPA trung bình, Chứng chỉ cấp mới, Tỷ lệ đạt) hiển thị bằng `JetBrains Mono` `24px tabular-nums`. Tầng 2: Bảng `AppDataTable` danh sách sinh viên vừa cập nhật (Sticky Header, Bulk Checkbox). |
| **3. User List** | `NavigationRail`/`NavigationBar` + Top Filter Bar + Full-height `AppDataTable` | Quản lý tài khoản hệ thống (Giáo vụ, Giảng viên, Admin). Cột: Checkbox, Mã NV (`JetBrains Mono`), Họ tên (Ellipsis + Tooltip), Email (Ellipsis + Tooltip), Vai trò, Đăng nhập cuối (`JetBrains Mono` `tabular-nums`). |
| **4. Student List** | `NavigationRail`/`NavigationBar` + Search/Filter + Contextual Bulk Bar + `AppDataTable` | Cột: Checkbox, Mã SV (`JetBrains Mono`), Họ tên, Chuyên ngành (Ellipsis + Tooltip), Tuổi (`JetBrains Mono`), GPA (`JetBrains Mono`), Ngày nhập học (`JetBrains Mono`). Khi chọn `>= 1` dòng, thanh Bulk Actions trượt xuống (`200ms`) cho phép Xóa hàng loạt hoặc Xuất danh sách. |
| **5. Student Detail** | Header hồ sơ cố định phía trên + Tab điều hướng (`Học tập`, `Chứng chỉ`) bên dưới | Khối thông tin cá nhân hiển thị Mã SV, Tuổi, GPA tích lũy bằng `JetBrains Mono`. Phần danh sách Chứng chỉ (`Certificate`) bên dưới bắt buộc hiển thị bằng `AppDataTable` (Sticky Header, Ellipsis + Tooltip, Bulk Checkbox để thu hồi/cấp lại hàng loạt). |
| **6. Profile** | Khung 2 cột chuẩn (Trái `320px`: Thông tin cá nhân; Phải `Flexible`: Lịch sử phiên đăng nhập) | Form đổi mật khẩu áp dụng `ShakeWidget` (`150ms`) và `AppToast` (tự ẩn sau `3s`). Lịch sử thiết bị đăng nhập hiển thị bằng `AppDataTable` với cột IP và Thời gian dùng `JetBrains Mono` (`tabular-nums`). |

## 2. Mã nguồn Hoàn chỉnh (Production-Ready Code)

### 2.1. `pubspec.yaml`

```yaml
name: student_management_app
description: Production-ready Student Management Application with Clean Architecture.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  go_router: ^14.2.0
  google_fonts: ^6.2.1
  firebase_core: ^3.1.0
  firebase_auth: ^5.1.0
  cloud_firestore: ^5.0.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
```

### 2.2. Core Constants & Design System (`app_durations.dart`, `app_colors.dart`, `app_spacing.dart`)

```dart
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
```

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand & Primary
  static const Color primary = Color(0xFF1E40AF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  // Neutral Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color rowHover = Color(0xFFF8FAFC);
  static const Color rowSelected = Color(0xFFEFF6FF);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // Semantic Status
  static const Color success = Color(0xFF15803D);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFB45309);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFB91C1C);
  static const Color errorBg = Color(0xFFFEE2E2);

  // Skeleton Shimmer
  static const Color skeletonBase = Color(0xFFE2E8F0);
  static const Color skeletonHighlight = Color(0xFFF1F5F9);
}
```

```dart
// lib/core/theme/app_spacing.dart
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Table Geometry
  static const double tableHeaderHeight = 44.0;
  static const double tableRowHeight = 48.0;
  static const double checkboxColumnWidth = 52.0;

  // Responsive Breakpoints (Standard Layout)
  static const double tabletBreakpoint = 600.0;
  static const double desktopBreakpoint = 1024.0;
}
```

### 2.3. Nghệ thuật xếp chữ — Typography khóa cứng Type Scale & `tabular-nums` (`lib/core/theme/app_typography.dart`)

```dart
// lib/core/theme/app_typography.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Khóa cứng 4 cấp độ Type Scale theo Global Rules
  static const double sizeSmall = 12.0;
  static const double sizeBody = 14.0;
  static const double sizeSubHeading = 16.0;
  static const double sizeHeading = 20.0;
  static const double sizeHeadingLarge = 24.0;

  /// Thuộc tính bắt buộc cho số liệu: tương đương CSS `font-variant-numeric: tabular-nums`
  static const List<FontFeature> _tabularFeatures = <FontFeature>[
    FontFeature.tabularFigures(),
    FontFeature.slashedZero(),
  ];

  // ===========================================================================
  // 1. INTER — Dành cho văn bản đọc (Họ tên, Email, Nhãn, Tiêu đề)
  // ===========================================================================
  static TextStyle get small => GoogleFonts.inter(
        fontSize: sizeSmall,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get smallMedium => GoogleFonts.inter(
        fontSize: sizeSmall,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: sizeBody,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: sizeBody,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get subHeading => GoogleFonts.inter(
        fontSize: sizeSubHeading,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading => GoogleFonts.inter(
        fontSize: sizeHeading,
        height: 28 / 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingLarge => GoogleFonts.inter(
        fontSize: sizeHeadingLarge,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ===========================================================================
  // 2. JETBRAINS MONO + TABULAR-NUMS — Bắt buộc cho Mã SV, GPA, Tuổi, Thời gian
  // ===========================================================================
  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: sizeSmall,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        fontFeatures: _tabularFeatures,
      );

  static TextStyle get monoBody => GoogleFonts.jetBrainsMono(
        fontSize: sizeBody,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontFeatures: _tabularFeatures,
      );

  static TextStyle get monoSubHeading => GoogleFonts.jetBrainsMono(
        fontSize: sizeSubHeading,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFeatures: _tabularFeatures,
      );

  static TextStyle get monoHeading => GoogleFonts.jetBrainsMono(
        fontSize: sizeHeadingLarge,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontFeatures: _tabularFeatures,
      );

  /// Ánh xạ vào Material 3 TextTheme
  static TextTheme get textTheme => TextTheme(
        headlineMedium: headingLarge,
        headlineSmall: heading,
        titleMedium: subHeading,
        bodyLarge: bodyMedium,
        bodyMedium: body,
        bodySmall: small,
        labelLarge: bodyMedium,
        labelSmall: smallMedium,
      );
}
```

### 2.4. Cấu hình Theme Material 3 (`lib/core/theme/app_theme.dart`)

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      // Khóa tốc độ chuyển trang trong khoảng 150ms - 250ms
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FastFadePageTransitionsBuilder(),
          TargetPlatform.iOS: _FastFadePageTransitionsBuilder(),
          TargetPlatform.macOS: _FastFadePageTransitionsBuilder(),
          TargetPlatform.windows: _FastFadePageTransitionsBuilder(),
          TargetPlatform.linux: _FastFadePageTransitionsBuilder(),
        },
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        selectedIconTheme: const IconThemeData(color: AppColors.primary),
        unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
        selectedLabelTextStyle: AppTypography.smallMedium.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelTextStyle: AppTypography.small,
        indicatorColor: AppColors.primaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.smallMedium.copyWith(color: AppColors.primary);
          }
          return AppTypography.small;
        }),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: AppDurations.fast,
        showDuration: AppDurations.toastVisible,
        textStyle: AppTypography.small.copyWith(color: Colors.white),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppSpacing.xxs),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xxs),
        ),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted),
        labelStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
        errorStyle: AppTypography.small.copyWith(color: AppColors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

class _FastFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FastFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeOutCubic).animate(animation),
      child: child,
    );
  }
}
```

### 2.5. Micro-interactions: Scale Button 0.95, Shake Validation 150ms & Toast 3s

```dart
// lib/core/widgets/scale_button.dart
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppScaleButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isOutlined;

  const AppScaleButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isDestructive = false,
    this.isOutlined = false,
  });

  @override
  State<AppScaleButton> createState() => _AppScaleButtonState();
}

class _AppScaleButtonState extends State<AppScaleButton> {
  bool _isPressed = false;
  DateTime? _lastTapTime;

  void _handleTap() {
    if (widget.onPressed == null) return;
    // Debounce 300ms chống double-tap gọi API lặp
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(milliseconds: 300)) {
      return;
    }
    _lastTapTime = now;
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isOutlined
        ? Colors.transparent
        : (widget.isDestructive ? AppColors.error : AppColors.primary);
    final fgColor = widget.isOutlined
        ? (widget.isDestructive ? AppColors.error : AppColors.textPrimary)
        : AppColors.onPrimary;

    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) => setState(() => _isPressed = false)
          : null,
      onTapCancel: widget.onPressed != null
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppDurations.fast, // 150ms chuẩn quy tắc
        curve: Curves.easeOutCubic,
        child: Material(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            side: widget.isOutlined
                ? BorderSide(
                    color: widget.isDestructive
                        ? AppColors.error
                        : AppColors.borderStrong,
                  )
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: widget.onPressed != null ? _handleTap : null,
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 16, color: fgColor),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    widget.label,
                    style: AppTypography.bodyMedium.copyWith(color: fgColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

```dart
// lib/core/widgets/shake_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';

class ShakeController {
  VoidCallback? _trigger;
  void shake() => _trigger?.call();
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final ShakeController controller;
  final double shakeOffset;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.controller,
    this.shakeOffset = 8.0,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppDurations.fast, // 150ms chuẩn quy tắc
    );
    widget.controller._trigger = _startShake;
  }

  void _startShake() {
    if (!mounted) return;
    _animController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._trigger = null;
      widget.controller._trigger = _startShake;
    }
  }

  @override
  void dispose() {
    widget.controller._trigger = null;
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        // Dao động 3 chu kỳ sin trong 150ms
        final sineValue = math.sin(_animController.value * math.pi * 3 * 2);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
```

```dart
// lib/core/widgets/app_toast.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum ToastType { success, error }

class AppToast {
  AppToast._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.success,
  }) {
    _removeCurrent();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _ToastView(
        message: message,
        type: type,
        onDismissed: () {
          if (_currentEntry == entry) {
            _removeCurrent();
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(AppDurations.toastVisible, () {
      _removeCurrent();
    });
  }

  static void _removeCurrent() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastView extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismissed;

  const _ToastView({
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.medium, // 200ms
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.type == ToastType.success;
    final accentColor = isSuccess ? AppColors.success : AppColors.error;
    final bgColor = isSuccess ? AppColors.successBg : AppColors.errorBg;

    return Positioned(
      top: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _controller,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                border: Border.all(color: accentColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuccess
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: accentColor,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  InkWell(
                    onTap: widget.onDismissed,
                    child: Icon(Icons.close, size: 16, color: accentColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### 2.6. Skeleton Loading & Bộ xử lý 4 Trạng thái DoD (`app_skeleton.dart`, `dod_state_builder.dart`)

```dart
// lib/core/widgets/app_skeleton.dart
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Khối Skeleton cơ bản (Tuyệt đối không dùng CircularProgressIndicator)
class AppSkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const AppSkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppSpacing.xxs,
  });

  @override
  State<AppSkeletonBox> createState() => _AppSkeletonBoxState();
}

class _AppSkeletonBoxState extends State<AppSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.skeletonPulse,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              AppColors.skeletonBase,
              AppColors.skeletonHighlight,
              _controller.value,
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton mô phỏng chính xác cấu trúc Data Table khi đang tải từ Firebase
class AppDataTableSkeleton extends StatelessWidget {
  final int rowCount;
  final int columnCount;

  const AppDataTableSkeleton({
    super.key,
    this.rowCount = 8,
    this.columnCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Skeleton Header
          Container(
            height: AppSpacing.tableHeaderHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const AppSkeletonBox(width: 18, height: 18),
                const SizedBox(width: AppSpacing.md),
                ...List.generate(
                  columnCount,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: AppSkeletonBox(
                        height: 12,
                        width: index == 0 ? 60 : 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Skeleton Rows
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rowCount,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, rowIdx) => Container(
                height: AppSpacing.tableRowHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    const AppSkeletonBox(width: 18, height: 18),
                    const SizedBox(width: AppSpacing.md),
                    ...List.generate(
                      columnCount,
                      (colIdx) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.md),
                          child: AppSkeletonBox(
                            height: 14,
                            width: (rowIdx + colIdx).isEven ? 90 : 65,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

```dart
// lib/core/widgets/dod_state_builder.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_skeleton.dart';
import 'scale_button.dart';

/// Widget ép buộc mọi màn hình danh sách/chi tiết tuân thủ đủ 4 trạng thái DoD:
/// 1. Loading State (Skeleton)
/// 2. Empty State (Icon minh họa + nút CTA)
/// 3. Error State (Thông báo lỗi mạng/DB + nút "Thử lại")
/// 4. Happy Path (Hiển thị dữ liệu chuẩn)
class DoDStateBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final bool Function(T data) isEmpty;
  final Widget Function(T data) dataBuilder;
  final Widget? loadingSkeleton;

  // Empty State Config
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final String emptyCtaLabel;
  final VoidCallback onEmptyCtaPressed;

  // Error State Config
  final VoidCallback onRetry;

  const DoDStateBuilder({
    super.key,
    required this.asyncValue,
    required this.isEmpty,
    required this.dataBuilder,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyCtaLabel,
    required this.onEmptyCtaPressed,
    required this.onRetry,
    this.emptyIcon = Icons.inbox_outlined,
    this.loadingSkeleton,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      skipLoadingOnRefresh: false,
      // 1. LOADING STATE: Bắt buộc dùng Skeleton, cấm dùng Spinner
      loading: () => loadingSkeleton ?? const AppDataTableSkeleton(),

      // 3. ERROR STATE: Thông báo lỗi rõ ràng kèm nút "Thử lại"
      error: (error, _) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.errorBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_outlined,
                  size: 32,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Không thể kết nối dữ liệu',
                style: AppTypography.subHeading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Đã xảy ra sự cố kết nối mạng hoặc truy vấn cơ sở dữ liệu (${error.toString()}). Vui lòng kiểm tra kết nối và thử lại.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppScaleButton(
                label: 'Thử lại',
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),

      // 2. EMPTY STATE & 4. HAPPY PATH
      data: (data) {
        if (isEmpty(data)) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      emptyIcon,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    emptyTitle,
                    style: AppTypography.subHeading,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    emptySubtitle,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppScaleButton(
                    label: emptyCtaLabel,
                    icon: Icons.add,
                    onPressed: onEmptyCtaPressed,
                  ),
                ],
              ),
            ),
          );
        }

        // 4. HAPPY PATH
        return dataBuilder(data);
      },
    );
  }
}
```

### 2.7. Core Data Table: Sticky Header + Truncation Tooltip + Bulk Actions + `tabular-nums` (`lib/core/widgets/app_data_table.dart`)

```dart
// lib/core/widgets/app_data_table.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Cấu hình từng cột của Data Table
class AppTableColumn<T> {
  final String title;
  final double width;
  final bool isNumeric;
  final String Function(T item) valueGetter;
  final Widget Function(T item)? customCellBuilder;

  const AppTableColumn({
    required this.title,
    required this.width,
    required this.valueGetter,
    this.isNumeric = false,
    this.customCellBuilder,
  });
}

/// Component bảng dữ liệu chuẩn cho Student, User, Certificate:
/// 1. Sticky Header đứng yên khi cuộn dọc, đồng bộ cuộn ngang.
/// 2. Text Truncation (`...`) kèm Tooltip khi hover/nhấn giữ.
/// 3. Bulk Actions Checkbox ở cột đầu tiên.
/// 4. Cột `isNumeric = true` tự động ép kiểu `JetBrains Mono` + `tabular-nums`.
class AppDataTable<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) idGetter;
  final List<AppTableColumn<T>> columns;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final ValueChanged<T>? onRowTap;
  final List<Widget> Function(Set<String> selectedIds)? bulkActionsBuilder;

  const AppDataTable({
    super.key,
    required this.items,
    required this.idGetter,
    required this.columns,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.onRowTap,
    this.bulkActionsBuilder,
  });

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  final ScrollController _headerHorizontalCtrl = ScrollController();
  final ScrollController _bodyHorizontalCtrl = ScrollController();
  final ScrollController _bodyVerticalCtrl = ScrollController();
  bool _isSyncingScroll = false;

  @override
  void initState() {
    super.initState();
    _headerHorizontalCtrl.addListener(_syncFromHeader);
    _bodyHorizontalCtrl.addListener(_syncFromBody);
  }

  void _syncFromHeader() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_bodyHorizontalCtrl.hasClients) {
      _bodyHorizontalCtrl.jumpTo(_headerHorizontalCtrl.offset);
    }
    _isSyncingScroll = false;
  }

  void _syncFromBody() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_headerHorizontalCtrl.hasClients) {
      _headerHorizontalCtrl.jumpTo(_bodyHorizontalCtrl.offset);
    }
    _isSyncingScroll = false;
  }

  @override
  void dispose() {
    _headerHorizontalCtrl.removeListener(_syncFromHeader);
    _bodyHorizontalCtrl.removeListener(_syncFromBody);
    _headerHorizontalCtrl.dispose();
    _bodyHorizontalCtrl.dispose();
    _bodyVerticalCtrl.dispose();
    super.dispose();
  }

  double get _totalColumnsWidth =>
      AppSpacing.checkboxColumnWidth +
      widget.columns.fold(0.0, (sum, col) => sum + col.width);

  bool? get _masterCheckboxState {
    if (widget.items.isEmpty) return false;
    final allIds = widget.items.map(widget.idGetter).toSet();
    final matchedCount = widget.selectedIds.intersection(allIds).length;
    if (matchedCount == 0) return false;
    if (matchedCount == allIds.length) return true;
    return null; // Tristate khi chọn một phần
  }

  void _toggleSelectAll(bool? value) {
    final allIds = widget.items.map(widget.idGetter).toSet();
    if (_masterCheckboxState == true) {
      final updated = Set<String>.from(widget.selectedIds)..removeAll(allIds);
      widget.onSelectionChanged(updated);
    } else {
      final updated = Set<String>.from(widget.selectedIds)..addAll(allIds);
      widget.onSelectionChanged(updated);
    }
  }

  void _toggleRow(String id) {
    final updated = Set<String>.from(widget.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    widget.onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    // Khóa giới hạn phóng to chữ của hệ điều hành ở mức tối đa 1.1x để giữ bố cục cột
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, _totalColumnsWidth);

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thanh công cụ Bulk Actions trượt xuống trong 200ms khi có dòng được chọn
                AnimatedSwitcher(
                  duration: AppDurations.medium,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: widget.selectedIds.isNotEmpty
                      ? Container(
                          key: const ValueKey('bulk_bar'),
                          height: AppSpacing.tableHeaderHeight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            border: Border(
                              bottom: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Đã chọn ',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                '${widget.selectedIds.length}',
                                style: AppTypography.monoBody.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                ' mục',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                              const Spacer(),
                              if (widget.bulkActionsBuilder != null)
                                ...widget.bulkActionsBuilder!(
                                  widget.selectedIds,
                                ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // 1. STICKY HEADER: Luôn đứng yên trên đỉnh khi cuộn dọc
                SingleChildScrollView(
                  controller: _headerHorizontalCtrl,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    width: tableWidth,
                    height: AppSpacing.tableHeaderHeight,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceVariant,
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppSpacing.checkboxColumnWidth,
                          child: Center(
                            child: Checkbox(
                              tristate: true,
                              value: _masterCheckboxState,
                              onChanged: _toggleSelectAll,
                            ),
                          ),
                        ),
                        ...widget.columns.map(
                          (col) => Container(
                            width: col.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            alignment: col.isNumeric
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Tooltip(
                              message: col.title,
                              child: Text(
                                col.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.smallMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BODY: Cuộn dọc độc lập, đồng bộ cuộn ngang với Sticky Header
                Expanded(
                  child: Scrollbar(
                    controller: _bodyVerticalCtrl,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _bodyHorizontalCtrl,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: tableWidth,
                        child: ListView.separated(
                          controller: _bodyVerticalCtrl,
                          itemCount: widget.items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final id = widget.idGetter(item);
                            final isSelected = widget.selectedIds.contains(id);

                            return _DataTableRow<T>(
                              item: item,
                              columns: widget.columns,
                              isSelected: isSelected,
                              onToggleSelect: () => _toggleRow(id),
                              onRowTap: widget.onRowTap != null
                                  ? () => widget.onRowTap!(item)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DataTableRow<T> extends StatefulWidget {
  final T item;
  final List<AppTableColumn<T>> columns;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final VoidCallback? onRowTap;

  const _DataTableRow({
    required this.item,
    required this.columns,
    required this.isSelected,
    required this.onToggleSelect,
    this.onRowTap,
  });

  @override
  State<_DataTableRow<T>> createState() => _DataTableRowState<T>();
}

class _DataTableRowState<T> extends State<_DataTableRow<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isSelected
        ? AppColors.rowSelected
        : (_isHovered ? AppColors.rowHover : AppColors.surface);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onRowTap ?? widget.onToggleSelect,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          height: AppSpacing.tableRowHeight,
          color: bgColor,
          child: Row(
            children: [
              // 3. BULK ACTIONS CHECKBOX
              SizedBox(
                width: AppSpacing.checkboxColumnWidth,
                child: Center(
                  child: Checkbox(
                    value: widget.isSelected,
                    onChanged: (_) => widget.onToggleSelect(),
                  ),
                ),
              ),
              // DATA CELLS
              ...widget.columns.map((col) {
                final textValue = col.valueGetter(widget.item);
                // Cột số bắt buộc dùng JetBrains Mono + tabular-nums
                final textStyle = col.isNumeric
                    ? AppTypography.monoBody
                    : AppTypography.body;

                return Container(
                  width: col.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  alignment: col.isNumeric
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  // 2. TEXT TRUNCATION (`...`) + HOVER TOOLTIP
                  child: Tooltip(
                    message: textValue,
                    child: col.customCellBuilder != null
                        ? col.customCellBuilder!(widget.item)
                        : Text(
                            textValue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle,
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 2.8. Standard Layout Shell: `NavigationRail` (Desktop/Tablet) & `NavigationBar` (Mobile) (`lib/core/widgets/adaptive_shell.dart`)

```dart
// lib/core/widgets/adaptive_shell.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AdaptiveDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const AdaptiveDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class AdaptiveShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const AdaptiveShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  static const List<AdaptiveDestination> _destinations = [
    AdaptiveDestination(
      label: 'Tổng quan',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    AdaptiveDestination(
      label: 'Sinh viên',
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
    ),
    AdaptiveDestination(
      label: 'Người dùng',
      icon: Icons.badge_outlined,
      selectedIcon: Icons.badge,
    ),
    AdaptiveDestination(
      label: 'Hồ sơ',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < AppSpacing.tabletBreakpoint;
    final isExtendedDesktop = screenWidth >= AppSpacing.desktopBreakpoint;

    if (isMobile) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: _destinations
                .map(
                  (d) => NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: isExtendedDesktop,
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.onPrimary,
                        size: 18,
                      ),
                    ),
                    if (isExtendedDesktop) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text('EduManage', style: AppTypography.subHeading),
                    ],
                  ],
                ),
              ),
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
```

### 2.9. Feature `students` (Clean Architecture: Domain -> Data -> Presentation)

#### A. Tầng Domain: Entity với `freezed` + `abstract class StudentRepository`

```dart
// lib/features/students/domain/entities/student.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
class Student with _$Student {
  const factory Student({
    required String id,
    required String studentCode,
    required String fullName,
    required String email,
    required String major,
    required int age,
    required double gpa,
    required DateTime enrolledAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
```

```dart
// lib/features/students/domain/repositories/student_repository.dart
import '../entities/student.dart';

/// Interface ở tầng Domain: UI/State Management chỉ giao tiếp qua hợp đồng này
abstract class StudentRepository {
  Future<List<Student>> getStudents({String? searchQuery});
  Future<Student> getStudentById(String id);
  Future<void> deleteStudentsBulk(Set<String> studentIds);
}
```

#### B. Tầng Data: Thực thi Firebase tách biệt hoàn toàn khỏi UI

```dart
// lib/features/students/data/repositories/firebase_student_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

class FirebaseStudentRepository implements StudentRepository {
  final FirebaseFirestore _firestore;

  const FirebaseStudentRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('students');

  @override
  Future<List<Student>> getStudents({String? searchQuery}) async {
    final snapshot = await _collection.orderBy('studentCode').get();
    final students = snapshot.docs.map((doc) {
      final data = doc.data();
      return Student.fromJson({
        ...data,
        'id': doc.id,
        'enrolledAt': (data['enrolledAt'] is Timestamp)
            ? (data['enrolledAt'] as Timestamp).toDate().toIso8601String()
            : data['enrolledAt'] as String,
      });
    }).toList();

    if (searchQuery == null || searchQuery.trim().isEmpty) {
      return students;
    }

    final normalized = searchQuery.trim().toLowerCase();
    return students.where((s) {
      return s.studentCode.toLowerCase().contains(normalized) ||
          s.fullName.toLowerCase().contains(normalized) ||
          s.email.toLowerCase().contains(normalized);
    }).toList();
  }

  @override
  Future<Student> getStudentById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Không tìm thấy hồ sơ sinh viên mã $id');
    }
    final data = doc.data()!;
    return Student.fromJson({
      ...data,
      'id': doc.id,
      'enrolledAt': (data['enrolledAt'] is Timestamp)
          ? (data['enrolledAt'] as Timestamp).toDate().toIso8601String()
          : data['enrolledAt'] as String,
    });
  }

  @override
  Future<void> deleteStudentsBulk(Set<String> studentIds) async {
    if (studentIds.isEmpty) return;

    // Firestore giới hạn tối đa 500 thao tác trên mỗi WriteBatch
    final idsList = studentIds.toList();
    const batchLimit = 450;

    for (var i = 0; i < idsList.length; i += batchLimit) {
      final chunk = idsList.sublist(
        i,
        i + batchLimit > idsList.length ? idsList.length : i + batchLimit,
      );
      final batch = _firestore.batch();
      for (final id in chunk) {
        batch.delete(_collection.doc(id));
      }
      await batch.commit();
    }
  }
}
```

#### C. Tầng Presentation: Riverpod State Management & Màn hình `StudentListScreen`

```dart
// lib/features/students/presentation/providers/student_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firebase_student_repository.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

/// Inject interface StudentRepository (UI không biết tới FirebaseFirestore)
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return FirebaseStudentRepository(FirebaseFirestore.instance);
});

final studentSearchQueryProvider = StateProvider<String>((ref) => '');

final selectedStudentIdsProvider = StateProvider<Set<String>>((ref) => {});

final studentListNotifierProvider =
    AsyncNotifierProvider<StudentListNotifier, List<Student>>(
  StudentListNotifier.new,
);

class StudentListNotifier extends AsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() async {
    final query = ref.watch(studentSearchQueryProvider);
    final repo = ref.watch(studentRepositoryProvider);
    final items = await repo.getStudents(searchQuery: query);

    // Tự động loại bỏ các ID đã chọn nhưng không còn tồn tại trong danh sách hiện tại
    final validIds = items.map((e) => e.id).toSet();
    final currentSelected = ref.read(selectedStudentIdsProvider);
    final sanitized = currentSelected.intersection(validIds);
    if (sanitized.length != currentSelected.length) {
      Future.microtask(() {
        ref.read(selectedStudentIdsProvider.notifier).state = sanitized;
      });
    }

    return items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final query = ref.read(studentSearchQueryProvider);
      return ref.read(studentRepositoryProvider).getStudents(
            searchQuery: query,
          );
    });
  }

  Future<void> deleteSelected(Set<String> ids) async {
    final repo = ref.read(studentRepositoryProvider);
    await repo.deleteStudentsBulk(ids);
    ref.read(selectedStudentIdsProvider.notifier).state = {};
    await refresh();
  }
}
```

```dart
// lib/features/students/presentation/screens/student_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/dod_state_builder.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../../core/widgets/shake_widget.dart';
import '../../domain/entities/student.dart';
import '../providers/student_providers.dart';

class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({super.key});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ShakeController _searchShakeCtrl = ShakeController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    // Ví dụ kiểm tra validation: cấm ký tự đặc biệt nguy hiểm, rung 150ms nếu vi phạm
    if (value.contains(RegExp(r'[<>{};]'))) {
      _searchShakeCtrl.shake();
      AppToast.show(
        context,
        message: 'Từ khóa tìm kiếm chứa ký tự không hợp lệ.',
        type: ToastType.error,
      );
      return;
    }
    ref.read(studentSearchQueryProvider.notifier).state = value;
  }

  Future<void> _handleBulkDelete(Set<String> selectedIds) async {
    try {
      await ref
          .read(studentListNotifierProvider.notifier)
          .deleteSelected(selectedIds);
      if (!mounted) return;
      AppToast.show(
        context,
        message: 'Đã xóa ${selectedIds.length} hồ sơ sinh viên thành công.',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: 'Lỗi khi xóa hàng loạt: $e',
        type: ToastType.error,
      );
    }
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d/$m/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentListNotifierProvider);
    final selectedIds = ref.watch(selectedStudentIdsProvider);

    final columns = <AppTableColumn<Student>>[
      AppTableColumn<Student>(
        title: 'MÃ SV',
        width: 130,
        isNumeric: true, // Áp dụng JetBrains Mono + tabular-nums
        valueGetter: (s) => s.studentCode,
      ),
      AppTableColumn<Student>(
        title: 'HỌ VÀ TÊN',
        width: 220,
        valueGetter: (s) => s.fullName,
      ),
      AppTableColumn<Student>(
        title: 'EMAIL',
        width: 240,
        valueGetter: (s) => s.email,
      ),
      AppTableColumn<Student>(
        title: 'CHUYÊN NGÀNH',
        width: 200,
        valueGetter: (s) => s.major,
      ),
      AppTableColumn<Student>(
        title: 'TUỔI',
        width: 90,
        isNumeric: true, // Áp dụng JetBrains Mono + tabular-nums
        valueGetter: (s) => s.age.toString(),
      ),
      AppTableColumn<Student>(
        title: 'GPA',
        width: 100,
        isNumeric: true, // Áp dụng JetBrains Mono + tabular-nums
        valueGetter: (s) => s.gpa.toStringAsFixed(2),
      ),
      AppTableColumn<Student>(
        title: 'NGÀY NHẬP HỌC',
        width: 150,
        isNumeric: true, // Áp dụng JetBrains Mono + tabular-nums
        valueGetter: (s) => _formatDate(s.enrolledAt),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header & Thanh công cụ
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách Sinh viên',
                      style: AppTypography.headingLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Quản lý hồ sơ học vụ, điểm GPA và trạng thái tín chỉ tập trung',
                      style: AppTypography.small,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                child: ShakeWidget(
                  controller: _searchShakeCtrl,
                  child: TextField(
                    controller: _searchCtrl,
                    onSubmitted: _onSearchSubmitted,
                    style: AppTypography.body,
                    decoration: const InputDecoration(
                      hintText: 'Tìm theo mã SV, tên, email...',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppScaleButton(
                label: 'Thêm sinh viên',
                icon: Icons.add,
                onPressed: () {
                  AppToast.show(
                    context,
                    message: 'Mở biểu mẫu tạo mới hồ sơ sinh viên.',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Khu vực chính xử lý đủ 4 trạng thái DoD (Loading Skeleton, Empty, Error, Happy Path)
          Expanded(
            child: DoDStateBuilder<List<Student>>(
              asyncValue: studentsAsync,
              isEmpty: (list) => list.isEmpty,
              emptyIcon: Icons.school_outlined,
              emptyTitle: 'Chưa có hồ sơ sinh viên nào',
              emptySubtitle:
                  'Hệ thống chưa ghi nhận sinh viên phù hợp với bộ lọc hiện tại. Hãy thêm sinh viên mới hoặc làm mới bộ lọc.',
              emptyCtaLabel: 'Thêm sinh viên đầu tiên',
              onEmptyCtaPressed: () {
                _searchCtrl.clear();
                ref.read(studentSearchQueryProvider.notifier).state = '';
              },
              onRetry: () {
                ref.read(studentListNotifierProvider.notifier).refresh();
              },
              dataBuilder: (students) => AppDataTable<Student>(
                items: students,
                idGetter: (s) => s.id,
                columns: columns,
                selectedIds: selectedIds,
                onSelectionChanged: (updated) {
                  ref.read(selectedStudentIdsProvider.notifier).state = updated;
                },
                bulkActionsBuilder: (ids) => [
                  AppScaleButton(
                    label: 'Xóa đã chọn (${ids.length})',
                    icon: Icons.delete_outline,
                    isDestructive: true,
                    onPressed: () => _handleBulkDelete(ids),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## 3. Phân tích Rủi ro (Edge Cases) & Cơ chế Phòng ngừa trong Code

| # | Rủi ro (Edge Case) thực tế | Hậu quả nếu không xử lý | Cơ chế phòng ngừa đã tích hợp trong Code |
| :--- | :--- | :--- | :--- |
| **1** | **Lệch cuộn ngang (Scroll Desync) giữa Sticky Header và Body trong Data Table** | Khi bảng có nhiều cột (Mã SV, Tên, Email, Ngành, Tuổi, GPA, Ngày nhập học) trên màn hình nhỏ, người dùng vuốt ngang phần thân bảng nhưng tiêu đề cột phía trên đứng yên, làm lệch toàn bộ cột số liệu so với tiêu đề. | Trong `AppDataTable`, sử dụng cặp `_headerHorizontalCtrl` và `_bodyHorizontalCtrl` gắn listener 2 chiều có cờ khóa `_isSyncingScroll` để gọi `jumpTo` tức thời mà không gây vòng lặp vô hạn (infinite scroll loop). |
| **2** | **Ghost Selection (Lưu trữ ID ảo) khi lọc tìm kiếm hoặc sau khi xóa hàng loạt** | Người dùng tích chọn 5 sinh viên, sau đó gõ tìm kiếm chỉ còn 1 sinh viên hiển thị rồi bấm "Xóa đã chọn", dẫn đến xóa nhầm 4 sinh viên đang bị ẩn ngoài bộ lọc. | Trong `StudentListNotifier.build()`, mỗi khi danh sách tải mới hoặc lọc lại, code tự động tính giao tập hợp `currentSelected.intersection(validIds)` để loại bỏ ngay lập tức mọi ID không nằm trong tập hiển thị hiện tại. |
| **3** | **Vượt giới hạn 500 thao tác của Firestore `WriteBatch` khi Bulk Action** | Nếu người dùng chọn "Select All" trên danh sách `> 500` sinh viên và bấm xóa hàng loạt, Firebase SDK sẽ ném lỗi `FirebaseException: maximum 500 writes allowed per batch`. | Trong `FirebaseStudentRepository.deleteStudentsBulk()`, tập hợp ID được chia nhỏ thành từng cụm tối đa `450` bản ghi (`batchLimit = 450`) và commit tuần tự từng `WriteBatch`. |
| **4** | **Rò rỉ bộ nhớ (Memory Leak) hoặc lỗi `Overlay` khi Toast tự ẩn sau 3 giây** | Người dùng kích hoạt liên tiếp nhiều Toast trong vòng chưa đầy 3 giây hoặc chuyển màn hình trước khi Timer 3 giây kết thúc, gây chồng lấp nhiều lớp `OverlayEntry` hoặc crash `setState() called after dispose()`. | `AppToast` quản lý biến tĩnh `_currentEntry` và `_dismissTimer`: hủy ngay Timer và gỡ `OverlayEntry` cũ trước khi chèn Toast mới; đồng thời kiểm tra `if (!mounted) return;` trước mọi lệnh gọi sau `await`. |
| **5** | **Phóng to kích thước chữ hệ thống (OS Accessibility Font Scaling) làm vỡ cột Data Table** | Khi người dùng bật cỡ chữ 150%–200% trên điện thoại/máy tính bảng, các cột cố định như GPA, Tuổi, Mã SV bị tràn dòng hoặc cắt mất số dù đã bật `tabular-nums`. | Trong `AppDataTable.build()`, bọc bảng bằng `MediaQuery` với `textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.1)` kết hợp `maxLines: 1`, `TextOverflow.ellipsis` và `Tooltip` hiển thị đầy đủ khi chạm/di chuột. |
| **6** | **Double-tap / Spam click vào nút Thực thi hoặc nút Thử lại (`Retry`)** | Người dùng bấm liên tiếp vào nút "Xóa đã chọn" hoặc "Thử lại" trong lúc hiệu ứng scale `150ms` đang chạy, kích hoạt 2–3 request trùng lặp lên Firebase. | Trong `AppScaleButton`, tích hợp bộ khóa thời gian `_lastTapTime` (debounce `300ms`) chặn hoàn toàn các lượt nhấn lặp trước khi callback `onPressed` được kích hoạt. |
| **7** | **Không đồng nhất kiểu dữ liệu thời gian (`Timestamp` vs `String`) từ Firestore** | Dữ liệu từ Firestore trả về kiểu `Timestamp`, trong khi `json_serializable` mặc định kỳ vọng chuỗi ISO-8601 `String`, gây crash parse model ở tầng Data. | Trong `FirebaseStudentRepository`, chuẩn hóa trường `enrolledAt` sang chuỗi ISO-8601 (`toDate().toIso8601String()`) trước khi đưa vào `Student.fromJson`, đảm bảo tầng Domain hoàn toàn độc lập với kiểu `Timestamp` của Firebase. |
