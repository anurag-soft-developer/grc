import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final RxInt step = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.parameters['email'];
    if (args != null && args.isNotEmpty) {
      emailController.text = args;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void goToOtpStep() => step.value = 1;
  void goToEmailStep() => step.value = 0;
}
