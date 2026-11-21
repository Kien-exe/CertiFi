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
