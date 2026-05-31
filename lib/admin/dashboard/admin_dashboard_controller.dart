import 'package:get/get.dart';
import 'package:grc/admin/form/event_form_screen.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';

class AdminDashboardController extends GetxController {
  void openMyEventsTab() {
    Get.find<NavigationController>().changeTab(1);
  }

  void openEventForm() {
    Get.toNamed(
      AppConstants.routes.eventForm,
      arguments: eventFormCreate,
    );
  }
}
