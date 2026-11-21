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
