import 'package:get/get.dart';
import 'package:grc/admin/events/questionnaires/form_builder_controller.dart';

class FormBuilderBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<FormBuilderController>()) {
      Get.delete<FormBuilderController>(force: true);
    }
    Get.put(FormBuilderController());
  }
}
