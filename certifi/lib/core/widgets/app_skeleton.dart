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
