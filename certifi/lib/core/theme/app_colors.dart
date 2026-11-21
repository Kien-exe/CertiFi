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
