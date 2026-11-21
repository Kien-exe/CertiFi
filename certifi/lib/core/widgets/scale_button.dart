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
