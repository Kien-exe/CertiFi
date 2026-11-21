// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../../core/widgets/shake_widget.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _shakeCtrl = ShakeController();
  bool _obscurePassword = true;

  static final _emailRegex =
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    // Validation: sai định dạng -> rung 150ms + Toast lỗi
    if (!_emailRegex.hasMatch(email) || password.length < 6) {
      _shakeCtrl.shake();
      AppToast.show(
        context,
        message: 'Email hoặc mật khẩu không hợp lệ.',
        type: ToastType.error,
      );
      return;
    }

    ref.read(isLoggingInProvider.notifier).state = true;
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .login(email, password);
      if (!mounted) return;
      if (success) {
        AppToast.show(context, message: 'Đăng nhập thành công.');
        context.go('/');
      } else {
        _shakeCtrl.shake();
        AppToast.show(
          context,
          message: 'Sai email hoặc mật khẩu.',
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        ref.read(isLoggingInProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggingIn = ref.watch(isLoggingInProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & tiêu đề
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: AppColors.onPrimary,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'CertiFi',
                  style: AppTypography.heading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Đăng nhập để quản lý thông tin sinh viên',
                  style: AppTypography.small,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Khi chờ xác thực: Skeleton mờ thay vì Spinner
                if (isLoggingIn)
                  const AppSkeletonBox(height: 120)
                else
                  ShakeWidget(
                    controller: _shakeCtrl,
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: AppTypography.body,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'you@university.edu',
                            prefixIcon: Icon(Icons.mail_outline, size: 18),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          style: AppTypography.body,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            prefixIcon:
                                const Icon(Icons.lock_outline, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppScaleButton(
                          label: 'Đăng nhập',
                          icon: Icons.login,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
