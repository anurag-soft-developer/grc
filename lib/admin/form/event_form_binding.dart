import 'package:get/get.dart';
import 'package:grc/admin/form/event_form_controller.dart';

class EventFormBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<EventFormController>()) {
      Get.delete<EventFormController>(force: true);
    }
    Get.put(EventFormController());
  }
}
