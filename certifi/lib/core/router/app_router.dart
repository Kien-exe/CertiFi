// lib/core/router/app_router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/certificates/presentation/screens/certificate_list_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/students/presentation/screens/student_detail_screen.dart';
import '../../features/students/presentation/screens/student_list_screen.dart';
import '../../features/users/presentation/screens/user_list_screen.dart';
import '../widgets/adaptive_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Bọc màn hình trong AdaptiveShell (NavigationRail/NavigationBar)
class AppShell extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const AppShell({super.key, required this.currentIndex, required this.child});

  static const List<String> _paths = ['/', '/students', '/users', '/profile'];

  @override
  Widget build(BuildContext context) {
    return AdaptiveShell(
      currentIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index != currentIndex) {
          context.go(_paths[index]);
        }
      },
      child: child,
    );
  }
}

/// Trigger rebuild router khi trạng thái đăng nhập thay đổi
final _authStateRefresh = ValueNotifier<int>(0);
bool _authListenerAttached = false;

void _ensureAuthListener() {
  if (_authListenerAttached) return;
  _authListenerAttached = true;
  FirebaseAuth.instance.authStateChanges().listen((_) {
    _authStateRefresh.value++;
  });
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: _authStateRefresh,
  redirect: (context, state) {
    _ensureAuthListener();
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    final onLoginPage = state.matchedLocation == '/login';

    if (!loggedIn && !onLoginPage) return '/login';
    if (loggedIn && onLoginPage) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const AppShell(currentIndex: 0, child: HomeScreen()),
    ),
    GoRoute(
      path: '/students',
      builder: (context, state) =>
          const AppShell(currentIndex: 1, child: StudentListScreen()),
    ),
    GoRoute(
      path: '/students/:id',
      builder: (context, state) => StudentDetailScreen(
        studentId: state.pathParameters['id']!,
      ),
      parentNavigatorKey: _rootNavigatorKey,
    ),
    GoRoute(
      path: '/certificates',
      builder: (context, state) => AppShell(
        currentIndex: 1,
        child: CertificateListScreen(
          initialStudentCode: state.uri.queryParameters['studentCode'],
        ),
      ),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) =>
          const AppShell(currentIndex: 2, child: UserListScreen()),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) =>
          const AppShell(currentIndex: 3, child: ProfileScreen()),
    ),
  ],
);
