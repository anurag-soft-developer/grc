import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final Rxn<LoginOtpChallengeResponse> pendingOtpChallenge = Rxn();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void cancelLoginOtp() {
    pendingOtpChallenge.value = null;
    otpController.clear();
  }

  void goToSignup() {
    emailController.clear();
    passwordController.clear();
    Get.offNamed(AppConstants.routes.signup);
  }

  void goToForgotPassword() {
    Get.toNamed(AppConstants.routes.forgotPassword);
  }
}
