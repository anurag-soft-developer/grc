import 'package:get/get.dart';
import 'package:grc/core/navigation/app_navigation.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';

class AdminDashboardController extends GetxController {
  void openMyEventsTab() {
    Get.find<NavigationController>().changeTab(1);
  }

  void openEventForm() {
    AppNavigation.toNamed(AppConstants.routes.eventForm);
  }
}
