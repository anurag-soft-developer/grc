import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/components/bottom_navigation_panel/app_bottom_navigation_panel.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';

class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  late final NavigationController _navController;
  final List<Widget?> _tabCache = List<Widget?>.filled(kNavTabs.length, null);

  @override
  void initState() {
    super.initState();
    _navController = Get.find<NavigationController>();
  }

  Widget _buildLazyIndexedStack(int index) {
    if (_tabCache[index] == null) {
      _tabCache[index] = kNavTabs[index].screenBuilder();
    }
    return IndexedStack(
      index: index,
      children: List.generate(
        kNavTabs.length,
        (i) => _tabCache[i] ?? const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final index = _navController.currentIndex.clamp(0, kNavTabs.length - 1);
        return _buildLazyIndexedStack(index);
      }),
      bottomNavigationBar: Obx(() {
        final index = _navController.currentIndex.clamp(0, kNavTabs.length - 1);
        return AppBottomNavigationPanel(
          tabs: kNavTabs,
          currentIndex: index,
          onTap: _navController.changeTab,
        );
      }),
    );
  }
}
