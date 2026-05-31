import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/bottom_navigation_panel/app_bottom_navigation_panel.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';

class MainScreenWrapper extends StatelessWidget {
  const MainScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    return Obx(() {
      final isAdminMode = authState.isAdminMode;
      return _MainTabShell(
        key: ValueKey(isAdminMode),
        isAdminMode: isAdminMode,
      );
    });
  }
}

class _MainTabShell extends StatefulWidget {
  final bool isAdminMode;

  const _MainTabShell({super.key, required this.isAdminMode});

  @override
  State<_MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<_MainTabShell> {
  late final NavigationController _navController;
  late List<Widget?> _tabCache;

  @override
  void initState() {
    super.initState();
    _navController = Get.find<NavigationController>();
    _tabCache = List<Widget?>.filled(
      navTabsFor(widget.isAdminMode).length,
      null,
    );
    final tabs = navTabsFor(widget.isAdminMode);
    if (tabs.isNotEmpty) {
      tabs[0].loadController?.call();
    }
  }

  List<NavTab> get _tabs => navTabsFor(widget.isAdminMode);

  Widget _buildLazyIndexedStack(int index) {
    if (_tabCache[index] == null) {
      _tabCache[index] = _tabs[index].screenBuilder();
    }
    return IndexedStack(
      index: index,
      children: List.generate(
        _tabs.length,
        (i) => _tabCache[i] ?? const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final index = _navController.currentIndex.clamp(0, _tabs.length - 1);
        return _buildLazyIndexedStack(index);
      }),
      bottomNavigationBar: Obx(() {
        final index = _navController.currentIndex.clamp(0, _tabs.length - 1);
        return AppBottomNavigationPanel(
          tabs: _tabs,
          currentIndex: index,
          onTap: _navController.changeTab,
        );
      }),
    );
  }
}
