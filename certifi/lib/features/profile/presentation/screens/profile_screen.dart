// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../../core/widgets/shake_widget.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  final _shakeCtrl = ShakeController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$min';
  }

  Future<void> _changePassword() async {
    final next = _newPwCtrl.text;
    final confirm = _confirmPwCtrl.text;

    if (next != confirm || next.length < 6) {
      _shakeCtrl.shake();
      AppToast.show(
        context,
        message: 'Mật khẩu mới không khớp hoặc quá ngắn (tối thiểu 6 ký tự).',
        type: ToastType.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // Đi qua AuthRepository.changePassword (Clean Architecture)
      await ref.read(authNotifierProvider.notifier).changePassword(
            currentPassword: _currentPwCtrl.text,
            newPassword: next,
          );
      if (!mounted) return;
      _currentPwCtrl.clear();
      _newPwCtrl.clear();
      _confirmPwCtrl.clear();
      AppToast.show(context, message: 'Đổi mật khẩu thành công.');
    } catch (e) {
      if (!mounted) return;
      _shakeCtrl.shake();
      AppToast.show(
        context,
        message: 'Đổi mật khẩu thất bại: $e',
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (user) {
          if (user == null) {
            return Center(
              child: AppScaleButton(
                label: 'Đăng nhập',
                icon: Icons.login,
                onPressed: () {},
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Hồ sơ của tôi', style: AppTypography.headingLarge),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cột trái 320px: thông tin cá nhân
                      SizedBox(
                        width: 320,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.xs),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.primaryContainer,
                                child: Text(
                                  user.displayName.isNotEmpty
                                      ? user.displayName[0].toUpperCase()
                                      : 'U',
                                  style: AppTypography.heading.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                user.displayName,
                                style: AppTypography.subHeading,
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(user.email, style: AppTypography.small),
                              const SizedBox(height: AppSpacing.md),
                              AppScaleButton(
                                label: 'Đăng xuất',
                                icon: Icons.logout,
                                isDestructive: true,
                                onPressed: () async {
                                  await ref
                                      .read(authNotifierProvider.notifier)
                                      .logout();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      // Cột phải: đổi mật khẩu
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.xs),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ĐỔI MẬT KHẨU',
                                style: AppTypography.smallMedium,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ShakeWidget(
                                controller: _shakeCtrl,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _currentPwCtrl,
                                      obscureText: true,
                                      style: AppTypography.body,
                                      decoration: const InputDecoration(
                                        labelText: 'Mật khẩu hiện tại',
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    TextField(
                                      controller: _newPwCtrl,
                                      obscureText: true,
                                      style: AppTypography.body,
                                      decoration: const InputDecoration(
                                        labelText: 'Mật khẩu mới',
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    TextField(
                                      controller: _confirmPwCtrl,
                                      obscureText: true,
                                      style: AppTypography.body,
                                      decoration: const InputDecoration(
                                        labelText: 'Nhập lại mật khẩu mới',
                                      ),
                                      onSubmitted: (_) => _changePassword(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              AppScaleButton(
                                label: _isSubmitting
                                    ? 'Đang xử lý...'
                                    : 'Cập nhật mật khẩu',
                                icon: Icons.password,
                                onPressed:
                                    _isSubmitting ? null : _changePassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Lịch sử phiên đăng nhập (sẽ đầy đủ ở Sprint sau)
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
                        Text('LỊCH SỬ ĐĂNG NHẬP',
                            style: AppTypography.smallMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Phiên hiện tại: đăng nhập lúc '
                          '${_formatDateTime(user.signedInAt)} '
                          'với vai trò ${user.role.name.toUpperCase()}',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
