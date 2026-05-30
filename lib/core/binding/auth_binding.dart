import 'package:get/get.dart';
import 'package:grc/core/auth/login/login_controller.dart';
import 'package:grc/core/auth/signup/signup_controller.dart';
import 'package:grc/core/auth/verify_email/verify_email_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyEmailController>(() => VerifyEmailController());
  }
}
