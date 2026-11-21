// lib/features/certificates/presentation/screens/certificate_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/dod_state_builder.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../../core/widgets/shake_widget.dart';
import '../../domain/entities/certificate.dart';
import '../providers/certificate_providers.dart';

/// Màn hình quản lý Chứng chỉ: chỉ giao tiếp với CertificateRepository qua Riverpod.
/// Đáp ứng 100%: Data Table (Sticky Header, Truncation Tooltip, Bulk Actions),
/// Inter + JetBrains Mono (tabular-nums), Skeleton Loading và 4 trạng thái DoD.
class CertificateListScreen extends ConsumerStatefulWidget {
  /// Mã sinh viên để lọc sẵn (VD: truyền từ Student Detail)
  final String? initialStudentCode;

  const CertificateListScreen({super.key, this.initialStudentCode});

  @override
  ConsumerState<CertificateListScreen> createState() =>
      _CertificateListScreenState();
}

class _CertificateListScreenState extends ConsumerState<CertificateListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ShakeController _searchShakeCtrl = ShakeController();

  @override
  void initState() {
    super.initState();
    if (widget.initialStudentCode != null) {
      // Đặt filter sau frame đầu tiên để provider đã sẵn sàng
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(certificateStudentCodeProvider.notifier).state =
            widget.initialStudentCode;
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    if (value.contains(RegExp(r'[<>{};]'))) {
      _searchShakeCtrl.shake(); // Shake 150ms khi lỗi validation
      AppToast.show(
        context,
        message: 'Từ khóa tìm kiếm chứa ký tự không hợp lệ.',
        type: ToastType.error,
      );
      return;
    }
    ref.read(certificateSearchProvider.notifier).state = value;
  }

  Future<void> _handleBulkRevoke(Set<String> ids) async {
    try {
      final result = await ref
          .read(certificateListNotifierProvider.notifier)
          .revokeSelected(ids);
      if (!mounted) return;

      if (result.isFullSuccess) {
        AppToast.show(
          context,
          message: 'Đã thu hồi ${result.succeededIds.length} chứng chỉ.',
          type: ToastType.success,
        );
      } else {
        AppToast.show(
          context,
          message:
              'Thu hồi thành công ${result.succeededIds.length}/${result.totalRequested} mục (${result.failedReasons.length} mục lỗi).',
          type: ToastType.error,
        );
      }
    } on AppFailure catch (failure) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: failure.userMessage,
        type: ToastType.error,
      );
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Vô thời hạn';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d/$m/${dt.year}';
  }

  Widget _buildStatusBadge(CertificateStatus status) {
    final (label, fg, bg) = switch (status) {
      CertificateStatus.valid => (
          'Còn hiệu lực',
          AppColors.success,
          AppColors.successBg,
        ),
      CertificateStatus.expired => (
          'Hết hạn',
          AppColors.warning,
          AppColors.warningBg,
        ),
      CertificateStatus.revoked => (
          'Đã thu hồi',
          AppColors.error,
          AppColors.errorBg,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.xxs),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.smallMedium.copyWith(color: fg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final certAsync = ref.watch(certificateListNotifierProvider);
    final selectedIds = ref.watch(selectedCertificateIdsProvider);
    final studentCodeFilter = ref.watch(certificateStudentCodeProvider);

    final columns = <AppTableColumn<Certificate>>[
      AppTableColumn<Certificate>(
        title: 'MÃ CHỨNG CHỈ',
        width: 155,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => c.certificateCode,
      ),
      AppTableColumn<Certificate>(
        title: 'MÃ SV',
        width: 115,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => c.studentCode,
      ),
      AppTableColumn<Certificate>(
        title: 'SINH VIÊN',
        width: 185,
        valueGetter: (c) => c.studentName, // Inter + Truncation + Tooltip
      ),
      AppTableColumn<Certificate>(
        title: 'TÊN CHỨNG CHỈ',
        width: 260,
        valueGetter: (c) => c.title, // Inter + Truncation + Tooltip
      ),
      AppTableColumn<Certificate>(
        title: 'ĐƠN VỊ CẤP',
        width: 200,
        valueGetter: (c) => c.issuer,
      ),
      AppTableColumn<Certificate>(
        title: 'ĐIỂM',
        width: 95,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => c.score.toStringAsFixed(2),
      ),
      AppTableColumn<Certificate>(
        title: 'NGÀY CẤP',
        width: 120,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => _formatDate(c.issuedAt),
      ),
      AppTableColumn<Certificate>(
        title: 'HẾT HẠN',
        width: 120,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => _formatDate(c.expiredAt),
      ),
      AppTableColumn<Certificate>(
        title: 'TRẠNG THÁI',
        width: 130,
        valueGetter: (c) => c.status.name,
        customCellBuilder: (c) => _buildStatusBadge(c.status),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách Chứng chỉ',
                      style: AppTypography.headingLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      studentCodeFilter != null
                          ? 'Chứng chỉ của sinh viên $studentCodeFilter'
                          : 'Theo dõi văn bằng, chứng chỉ ngoại ngữ và tin học theo từng mã sinh viên',
                      style: AppTypography.small,
                    ),
                  ],
                ),
              ),
              if (studentCodeFilter != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: AppScaleButton(
                    label: 'Xem tất cả',
                    icon: Icons.filter_alt_off_outlined,
                    isOutlined: true,
                    onPressed: () {
                      ref
                          .read(certificateStudentCodeProvider.notifier)
                          .state = null;
                    },
                  ),
                ),
              SizedBox(
                width: 280,
                child: ShakeWidget(
                  controller: _searchShakeCtrl,
                  child: TextField(
                    controller: _searchCtrl,
                    onSubmitted: _submitSearch,
                    style: AppTypography.body,
                    decoration: const InputDecoration(
                      hintText: 'Tìm mã chứng chỉ, mã SV, tên...',
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
                label: 'Thêm chứng chỉ',
                icon: Icons.add,
                onPressed: () {
                  AppToast.show(
                    context,
                    message: 'Mở biểu mẫu cấp mới chứng chỉ.',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // BẮT BUỘC đủ 4 trạng thái DoD: Loading (Skeleton), Empty, Error, Happy Path
          Expanded(
            child: DoDStateBuilder<List<Certificate>>(
              asyncValue: certAsync,
              isEmpty: (items) => items.isEmpty,
              loadingSkeleton: const AppDataTableSkeleton(
                rowCount: 8,
                columnCount: 8,
              ),
              emptyIcon: Icons.workspace_premium_outlined,
              emptyTitle: 'Chưa có chứng chỉ nào được ghi nhận',
              emptySubtitle:
                  'Không có chứng chỉ nào khớp với điều kiện hiện tại. Hãy thêm chứng chỉ mới hoặc đặt lại bộ lọc.',
              emptyCtaLabel: 'Thêm chứng chỉ mới',
              onEmptyCtaPressed: () {
                _searchCtrl.clear();
                ref.read(certificateSearchProvider.notifier).state = '';
                ref.read(certificateStudentCodeProvider.notifier).state =
                    null;
              },
              onRetry: () {
                ref.read(certificateListNotifierProvider.notifier).refresh();
              },
              dataBuilder: (items) => AppDataTable<Certificate>(
                items: items,
                idGetter: (c) => c.id,
                columns: columns,
                selectedIds: selectedIds,
                onSelectionChanged: (updated) {
                  ref.read(selectedCertificateIdsProvider.notifier).state =
                      updated;
                },
                bulkActionsBuilder: (ids) => [
                  AppScaleButton(
                    label: 'Thu hồi (${ids.length})',
                    icon: Icons.block_outlined,
                    isOutlined: true,
                    isDestructive: true,
                    onPressed: () => _handleBulkRevoke(ids),
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
