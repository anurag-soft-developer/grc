import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/auth/login/login_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/app_routes.dart';
import 'package:grc/core/utils/validators.dart';

class LoginOtpChallengeView extends HookWidget {
  final LoginOtpChallengeResponse challenge;
  final LoginController controller;

  const LoginOtpChallengeView({
    super.key,
    required this.challenge,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final authRepo = Get.find<AuthRepository>();
    final authState = Get.find<AuthStateController>();

    final verifyMutation = useMutation<UserModel?, Object, void, void>(
      (_, __) => authRepo.verifyLoginOtp(
        email: challenge.email,
        otp: controller.otpController.text.trim(),
      ),
      mutationKey: QueryKeys.verifyLoginOtp,
      onSuccess: (user, _, __, ___) {
        if (user != null) {
          authState.setUser(user);
          controller.pendingOtpChallenge.value = null;
          Get.offAllNamed(AppRoutes.mainRoute);
        }
      },
    );

    return MutationLoadingOverlay(
      mutationKey: QueryKeys.verifyLoginOtp,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.otpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: controller.cancelLoginOtp,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 16),
              const Text(
                'Verify OTP',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Code sent to ${challenge.email}'),
              const SizedBox(height: 32),
              CustomTextField(
                controller: controller.otpController,
                labelText: 'OTP',
                keyboardType: TextInputType.number,
                validator: (v) => Validators.validateOtp(v),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Verify',
                onPressed: () {
                  if (controller.otpFormKey.currentState!.validate()) {
                    verifyMutation.mutate(null);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
