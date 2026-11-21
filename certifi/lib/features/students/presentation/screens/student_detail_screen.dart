// lib/features/students/presentation/screens/student_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/dod_state_builder.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../certificates/domain/entities/certificate.dart';
import '../../domain/entities/student.dart';
import '../providers/student_providers.dart';

final studentDetailProvider =
    FutureProvider.family<Student, String>((ref, id) async {
  return ref.read(studentRepositoryProvider).getStudentById(id);
});

/// Chứng chỉ của sinh viên — đi qua CertificateRepository (Clean Architecture),
/// KHÔNG gọi FirebaseFirestore trực tiếp từ màn hình.
final studentCertificatesProvider =
    FutureProvider.family<List<Certificate>, String>((ref, studentCode) {
  return ref
      .watch(certificateRepositoryProvider)
      .getCertificates(studentCode: studentCode);
});

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d/$m/${dt.year}';
  }

  Widget _infoTile(String label, String value, {bool mono = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.small),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: mono ? AppTypography.monoBody : AppTypography.bodyMedium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentDetailProvider(studentId));

    final certColumns = <AppTableColumn<Certificate>>[
      AppTableColumn<Certificate>(
        title: 'MÃ CHỨNG CHỈ',
        width: 150,
        isNumeric: true,
        valueGetter: (c) => c.certificateCode,
      ),
      AppTableColumn<Certificate>(
        title: 'TÊN CHỨNG CHỈ',
        width: 240,
        valueGetter: (c) => c.title,
      ),
      AppTableColumn<Certificate>(
        title: 'ĐƠN VỊ CẤP',
        width: 190,
        valueGetter: (c) => c.issuer,
      ),
      AppTableColumn<Certificate>(
        title: 'ĐIỂM',
        width: 90,
        isNumeric: true,
        valueGetter: (c) => c.score.toStringAsFixed(2),
      ),
      AppTableColumn<Certificate>(
        title: 'TRẠNG THÁI',
        width: 120,
        valueGetter: (c) => c.status.name,
      ),
      AppTableColumn<Certificate>(
        title: 'NGÀY CẤP',
        width: 120,
        isNumeric: true,
        valueGetter: (c) => _formatDate(c.issuedAt),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header cố định phía trên
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  AppScaleButton(
                    label: 'Quay lại',
                    icon: Icons.arrow_back,
                    isOutlined: true,
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Chi tiết Sinh viên',
                      style: AppTypography.headingLarge,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Nội dung chính: đủ 4 trạng thái DoD
            Expanded(
              child: DoDStateBuilder<Student>(
                asyncValue: studentAsync,
                isEmpty: (_) => false,
                emptyTitle: '',
                emptySubtitle: '',
                emptyCtaLabel: '',
                onEmptyCtaPressed: () {},
                onRetry: () =>
                    ref.invalidate(studentDetailProvider(studentId)),
                loadingSkeleton: const AppDataTableSkeleton(),
                dataBuilder: (student) {
                  final certsAsync =
                      ref.watch(studentCertificatesProvider(student.studentCode));

                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      // Khối thông tin cá nhân — số liệu dùng JetBrains Mono
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.xs),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('THÔNG TIN CÁ NHÂN',
                                style: AppTypography.smallMedium),
                            const SizedBox(height: AppSpacing.md),
                            Wrap(
                              spacing: AppSpacing.xl,
                              runSpacing: AppSpacing.md,
                              children: [
                                _infoTile('Mã SV', student.studentCode,
                                    mono: true),
                                _infoTile('Họ và tên', student.fullName),
                                _infoTile('Email', student.email),
                                _infoTile('Chuyên ngành', student.major),
                                _infoTile('Tuổi', '${student.age}', mono: true),
                                _infoTile('GPA tích lũy',
                                    student.gpa.toStringAsFixed(2),
                                    mono: true),
                                _infoTile('Ngày nhập học',
                                    _formatDate(student.enrolledAt),
                                    mono: true),
                                _infoTile('Trạng thái',
                                    student.status == StudentStatus.active
                                        ? 'Đang học'
                                        : 'Bảo lưu',
                                    mono: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Danh sách Chứng chỉ — AppDataTable (Skeleton/Empty/Error/Happy)
                      Row(
                        children: [
                          Expanded(
                            child: Text('CHỨNG CHỈ',
                                style: AppTypography.smallMedium),
                          ),
                          AppScaleButton(
                            label: 'Quản lý chứng chỉ',
                            icon: Icons.open_in_new,
                            isOutlined: true,
                            onPressed: () => context.push(
                              '/certificates?studentCode=${student.studentCode}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 360,
                        child: DoDStateBuilder<List<Certificate>>(
                          asyncValue: certsAsync,
                          isEmpty: (list) => list.isEmpty,
                          emptyIcon: Icons.workspace_premium_outlined,
                          emptyTitle: 'Chưa có chứng chỉ nào',
                          emptySubtitle:
                              'Sinh viên này chưa được cấp chứng chỉ nào trong hệ thống.',
                          emptyCtaLabel: 'Quản lý chứng chỉ',
                          onEmptyCtaPressed: () => context.push(
                            '/certificates?studentCode=${student.studentCode}',
                          ),
                          onRetry: () => ref.invalidate(
                              studentCertificatesProvider(student.studentCode)),
                          dataBuilder: (certs) => AppDataTable<Certificate>(
                            items: certs,
                            idGetter: (c) => c.id,
                            columns: certColumns,
                            selectedIds: const {},
                            onSelectionChanged: (_) {},
                            bulkActionsBuilder: (_) => [
                              AppScaleButton(
                                label: 'Thu hồi đã chọn',
                                icon: Icons.undo,
                                isDestructive: true,
                                onPressed: () {
                                  AppToast.show(
                                    context,
                                    message:
                                        'Dùng màn Quản lý chứng chỉ để thu hồi hàng loạt.',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
