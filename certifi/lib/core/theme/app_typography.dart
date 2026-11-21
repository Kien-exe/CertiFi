// lib/core/theme/app_typography.dart
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
