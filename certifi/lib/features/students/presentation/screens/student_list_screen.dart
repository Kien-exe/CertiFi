// lib/features/students/presentation/screens/student_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      final result = await ref
          .read(studentListNotifierProvider.notifier)
          .deleteSelected(selectedIds);
      if (!mounted) return;

      if (result.isFullSuccess) {
        AppToast.show(
          context,
          message: 'Đã xóa ${result.succeededIds.length} hồ sơ sinh viên thành công.',
          type: ToastType.success,
        );
      } else {
        AppToast.show(
          context,
          message:
              'Xóa thành công ${result.succeededIds.length}/${result.totalRequested} mục (${result.failedReasons.length} mục lỗi).',
          type: ToastType.error,
        );
      }
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
                onRowTap: (student) => context.push('/students/${student.id}'),
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
