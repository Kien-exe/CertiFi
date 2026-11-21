// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../students/presentation/providers/student_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentListNotifierProvider);

    return studentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi tải dữ liệu: $e')),
      data: (students) {
        final avgGpa = students.isEmpty
            ? 0.0
            : students.map((s) => s.gpa).reduce((a, b) => a + b) /
                students.length;

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Tổng quan', style: AppTypography.headingLarge),
            const SizedBox(height: AppSpacing.md),

            // Tầng 1: 4 thẻ chỉ số tổng quan — số liệu JetBrains Mono tabular-nums
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _StatCard(
                  title: 'TỔNG SINH VIÊN',
                  value: '${students.length}',
                  icon: Icons.school_outlined,
                ),
                _StatCard(
                  title: 'GPA TRUNG BÌNH',
                  value: avgGpa.toStringAsFixed(2),
                  icon: Icons.workspace_premium_outlined,
                ),
                _StatCard(
                  title: 'CHUYÊN NGÀNH',
                  value: '${students.map((s) => s.major).toSet().length}',
                  icon: Icons.category_outlined,
                ),
                _StatCard(
                  title: 'EMAIL HỢP LỆ',
                  value: '${students.where((s) => s.email.contains('@')).length}',
                  icon: Icons.mark_email_read_outlined,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Tầng 2: Bảng sinh viên mới cập nhật gần nhất (top 5)
            Text('SINH VIÊN MỚI NHẤT', style: AppTypography.smallMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: students.take(5).map((s) {
                  return Container(
                    height: AppSpacing.tableRowHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            s.studentCode,
                            style: AppTypography.monoBody,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            s.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.body,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            s.major,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.small,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            s.gpa.toStringAsFixed(2),
                            textAlign: TextAlign.right,
                            style: AppTypography.monoBody,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: AppTypography.smallMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.monoHeading),
        ],
      ),
    );
  }
}
