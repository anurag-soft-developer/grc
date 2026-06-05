import 'package:get/get.dart';
import 'package:grc/registrations/event_registration_controller.dart';

class EventRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EventRegistrationController>()) {
      Get.put(EventRegistrationController());
    }
  }
}
