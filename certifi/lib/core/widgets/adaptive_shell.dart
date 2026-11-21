// lib/core/widgets/adaptive_shell.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AdaptiveDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const AdaptiveDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class AdaptiveShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const AdaptiveShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  static const List<AdaptiveDestination> _destinations = [
    AdaptiveDestination(
      label: 'Tổng quan',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    AdaptiveDestination(
      label: 'Sinh viên',
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
    ),
    AdaptiveDestination(
      label: 'Người dùng',
      icon: Icons.badge_outlined,
      selectedIcon: Icons.badge,
    ),
    AdaptiveDestination(
      label: 'Hồ sơ',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < AppSpacing.tabletBreakpoint;
    final isExtendedDesktop = screenWidth >= AppSpacing.desktopBreakpoint;

    if (isMobile) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: _destinations
                .map(
                  (d) => NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: isExtendedDesktop,
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.onPrimary,
                        size: 18,
                      ),
                    ),
                    if (isExtendedDesktop) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text('CertiFi', style: AppTypography.subHeading),
                    ],
                  ],
                ),
              ),
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
