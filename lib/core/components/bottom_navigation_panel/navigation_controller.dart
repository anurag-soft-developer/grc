import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';
import 'package:grc/core/routes/main_tab_routes.dart';

class NavigationController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  bool _redirectScheduled = false;

  int get currentIndex => _currentIndex.value;
  List<NavTab> get activeTabs =>
      navTabsFor(Get.find<AuthStateController>().isAdminMode);
  int get tabCount => activeTabs.length;
  String _normalizeRoute(String route) => Uri.parse(route).path;

  int _indexForRoute(String route) {
    final normalized = _normalizeRoute(route);
    for (var i = 0; i < activeTabs.length; i++) {
      if (activeTabs[i].route == normalized) {
        return i;
      }
    }
    return -1;
  }

  void changeTab(int index) {
    if (index < 0 || index >= tabCount) return;
    final nextRoute = activeTabs[index].route;
    final currentRoute = _normalizeRoute(Get.currentRoute);

    if (currentRoute != nextRoute) {
      _redirectTo(nextRoute);
      return;
    }

    if (_currentIndex.value != index) {
      _currentIndex.value = index;
      _loadControllerForCurrentTab();
    }
  }

  void resetToFirstTab() {
    if (tabCount == 0) return;
    _redirectTo(activeTabs.first.route);
  }

  void syncWithCurrentRoute() {
    if (tabCount == 0) return;

    final currentRoute = _normalizeRoute(Get.currentRoute);
    final index = _indexForRoute(currentRoute);
    if (index >= 0) {
      if (_currentIndex.value != index) {
        _currentIndex.value = index;
      }
      _loadControllerForCurrentTab();
      return;
    }

    if (currentRoute == MainTabRoutes.legacyMain) {
      _redirectTo(activeTabs.first.route);
      return;
    }

    if (MainTabRoutes.isMainTabRoute(currentRoute)) {
      _redirectTo(activeTabs.first.route);
      return;
    }

    _loadControllerForCurrentTab();
  }

  void _loadControllerForCurrentTab() {
    if (tabCount == 0) return;
    final idx = _currentIndex.value.clamp(0, tabCount - 1);
    activeTabs[idx].loadController?.call();
  }

  void _redirectTo(String route) {
    if (_redirectScheduled) return;
    _redirectScheduled = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _redirectScheduled = false;
      if (tabCount == 0) return;

      final currentRoute = _normalizeRoute(Get.currentRoute);
      if (currentRoute == route) {
        syncWithCurrentRoute();
        return;
      }

      Get.offNamed(route);
    });
  }

  @override
  void onInit() {
    super.onInit();
    syncWithCurrentRoute();
  }
}
