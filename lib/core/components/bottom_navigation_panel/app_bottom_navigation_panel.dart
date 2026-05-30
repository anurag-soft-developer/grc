import 'package:flutter/material.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';
import 'package:grc/core/config/constants.dart';

class AppBottomNavigationPanel extends StatelessWidget {
  final List<NavTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationPanel({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: const Color(AppColors.surface),
      indicatorColor: const Color(AppColors.primary).withValues(alpha: 0.15),
      destinations: [
        for (final tab in tabs)
          NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.activeIcon, color: const Color(AppColors.primary)),
            label: tab.label,
          ),
      ],
    );
  }
}
