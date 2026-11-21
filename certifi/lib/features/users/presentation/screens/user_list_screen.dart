// lib/features/users/presentation/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/dod_state_builder.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../domain/entities/app_user.dart';
import '../providers/user_providers.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  Set<String> _selectedIds = {};

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$min';
  }

  Future<void> _handleBulkDelete(Set<String> ids) async {
    try {
      final result =
          await ref.read(userListNotifierProvider.notifier).deleteUsers(ids);
      if (!mounted) return;
      setState(() => _selectedIds = {});

      if (result.isFullSuccess) {
        AppToast.show(
          context,
          message: 'Đã xóa ${result.succeededIds.length} người dùng.',
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
    } on AppFailure catch (failure) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: failure.userMessage,
        type: ToastType.error,
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: 'Lỗi khi xóa: $e',
        type: ToastType.error,
      );
    }
  }

  void _showAddUserDialog() {
    // TODO(Sprint sau): Form thêm user đầy đủ (employeeCode, fullName, email,
    // phoneNumber, role, initialPassword) gọi notifier.createUser.
    AppToast.show(
      context,
      message: 'Biểu mẫu thêm người dùng sẽ hoàn thiện ở Sprint tiếp theo.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(userListNotifierProvider);

    final columns = <AppTableColumn<AppUser>>[
      AppTableColumn<AppUser>(
        title: 'MÃ NV',
        width: 110,
        isNumeric: true,
        valueGetter: (u) => u.employeeCode,
      ),
      AppTableColumn<AppUser>(
        title: 'HỌ VÀ TÊN',
        width: 200,
        valueGetter: (u) => u.fullName,
      ),
      AppTableColumn<AppUser>(
        title: 'EMAIL',
        width: 230,
        valueGetter: (u) => u.email,
      ),
      AppTableColumn<AppUser>(
        title: 'SĐT',
        width: 120,
        isNumeric: true,
        valueGetter: (u) => u.phoneNumber,
      ),
      AppTableColumn<AppUser>(
        title: 'VAI TRÒ',
        width: 110,
        valueGetter: (u) => u.role.name.toUpperCase(),
      ),
      AppTableColumn<AppUser>(
        title: 'TRẠNG THÁI',
        width: 110,
        valueGetter: (u) =>
            u.status == AccountStatus.active ? 'Hoạt động' : 'Đã khóa',
        customCellBuilder: (u) => Text(
          u.status == AccountStatus.active ? 'Hoạt động' : 'Đã khóa',
          style: AppTypography.body.copyWith(
            color: u.status == AccountStatus.active
                ? AppColors.success
                : AppColors.error,
          ),
        ),
      ),
      AppTableColumn<AppUser>(
        title: 'ĐĂNG NHẬP CUỐI',
        width: 160,
        isNumeric: true,
        valueGetter: (u) => _formatDateTime(u.lastLoginAt),
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
                    Text('Quản lý Người dùng', style: AppTypography.headingLarge),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Tài khoản hệ thống: Giáo vụ, Giảng viên, Quản trị viên',
                      style: AppTypography.small,
                    ),
                  ],
                ),
              ),
              AppScaleButton(
                label: 'Thêm người dùng',
                icon: Icons.person_add_outlined,
                onPressed: _showAddUserDialog,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: DoDStateBuilder<List<AppUser>>(
              asyncValue: usersAsync,
              isEmpty: (list) => list.isEmpty,
              emptyIcon: Icons.badge_outlined,
              emptyTitle: 'Chưa có người dùng nào',
              emptySubtitle:
                  'Danh sách tài khoản hệ thống đang trống. Hãy thêm người dùng đầu tiên.',
              emptyCtaLabel: 'Thêm người dùng',
              onEmptyCtaPressed: _showAddUserDialog,
              onRetry: () =>
                  ref.read(userListNotifierProvider.notifier).refresh(),
              dataBuilder: (users) => AppDataTable<AppUser>(
                items: users,
                idGetter: (u) => u.id,
                columns: columns,
                selectedIds: _selectedIds,
                onSelectionChanged: (ids) =>
                    setState(() => _selectedIds = ids),
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
