import 'package:get/get.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NavigationController>(NavigationController(), permanent: true);
  }
}
