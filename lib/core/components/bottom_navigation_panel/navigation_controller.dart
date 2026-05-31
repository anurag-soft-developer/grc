import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/bottom_navigation_panel/nav_tabs.dart';

class NavigationController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;
  List<NavTab> get activeTabs =>
      navTabsFor(Get.find<AuthStateController>().isAdminMode);
  int get tabCount => activeTabs.length;

  void changeTab(int index) {
    if (index >= 0 && index < tabCount && _currentIndex.value != index) {
      _currentIndex.value = index;
      _loadControllerForCurrentTab();
    }
  }

  void resetToFirstTab() {
    _currentIndex.value = 0;
    _loadControllerForCurrentTab();
  }

  void _loadControllerForCurrentTab() {
    if (tabCount == 0) return;
    final idx = _currentIndex.value.clamp(0, tabCount - 1);
    activeTabs[idx].loadController?.call();
  }

  @override
  void onInit() {
    super.onInit();
    _loadControllerForCurrentTab();
  }
}
