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
