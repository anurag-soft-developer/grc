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

  static const _selectedColor = Color(AppColors.primary);
  static const _unselectedColor = Color(AppColors.textSecondary);

  static NavigationBarThemeData _navBarTheme() {
    return NavigationBarThemeData(
      height: 60,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: _selectedColor.withValues(alpha: 0.12),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? _selectedColor : _unselectedColor,
          size: selected ? 22 : 20,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          height: 1.1,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: selected ? 0.15 : 0,
          color: selected ? _selectedColor : _unselectedColor,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(AppColors.surface),
        border: Border(
          top: BorderSide(color: Color(AppColors.divider), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: _navBarTheme(),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: [
            for (final tab in tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.activeIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}
