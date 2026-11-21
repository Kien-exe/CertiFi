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
