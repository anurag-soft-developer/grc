import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/auth/verify_email/verify_email_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/repositories/user_repository.dart';
import 'package:grc/core/routes/app_routes.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/core/utils/validators.dart';

class VerifyEmailScreen extends HookWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VerifyEmailController>();
    final authRepo = Get.find<AuthRepository>();
    final userRepo = Get.find<UserRepository>();
    final authState = Get.find<AuthStateController>();
    final client = useQueryClient();

    final sendMutation = useMutation<bool, Object, String, void>(
      (email, _) => authRepo.sendVerificationEmail(email),
      mutationKey: QueryKeys.sendVerificationEmail,
      onSuccess: (ok, _, __, ___) {
        if (ok) {
          ExceptionHandler.showSuccessToast(AppConstants.successMessages.otpSent);
          controller.goToOtpStep();
        }
      },
    );

    final verifyMutation = useMutation<void, Object, void, void>(
      (_, __) async {
        if (!controller.otpFormKey.currentState!.validate()) {
          throw Exception('Validation failed');
        }
        await authRepo.verifyEmail(
          email: controller.emailController.text.trim(),
          otp: controller.otpController.text.trim(),
        );
        final profile = await userRepo.getProfile();
        if (profile != null) authState.setUser(profile);
        await client.invalidateQueries(queryKey: QueryKeys.profile);
      },
      mutationKey: QueryKeys.verifyEmail,
      onSuccess: (_, __, ___, ____) {
        if (authState.isLoggedIn) {
          if (Get.previousRoute == AppRoutes.mainRoute) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.mainRoute);
          }
        } else {
          Get.offAllNamed(AppConstants.routes.login);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Obx(() {
        if (controller.step.value == 0) {
          return MutationLoadingOverlay(
            mutationKey: QueryKeys.sendVerificationEmail,
            child: _EmailStep(
              controller: controller,
              onSend: () {
                if (controller.emailFormKey.currentState!.validate()) {
                  sendMutation.mutate(controller.emailController.text.trim());
                }
              },
            ),
          );
        }
        return MutationLoadingOverlay(
          mutationKey: QueryKeys.verifyEmail,
          child: _OtpStep(
            controller: controller,
            onVerify: () => verifyMutation.mutate(null),
            onBack: controller.goToEmailStep,
            onResend: () => sendMutation.mutate(
              controller.emailController.text.trim(),
            ),
          ),
        );
      }),
    );
  }
}

class _EmailStep extends StatelessWidget {
  final VerifyEmailController controller;
  final VoidCallback onSend;

  const _EmailStep({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: controller.emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify your email',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: controller.emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Send verification OTP', onPressed: onSend),
          ],
        ),
      ),
    );
  }
}

class _OtpStep extends StatelessWidget {
  final VerifyEmailController controller;
  final VoidCallback onVerify;
  final VoidCallback onBack;
  final VoidCallback onResend;

  const _OtpStep({
    required this.controller,
    required this.onVerify,
    required this.onBack,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: controller.otpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
            CustomTextField(
              controller: controller.otpController,
              labelText: 'OTP',
              keyboardType: TextInputType.number,
              validator: (v) => Validators.validateOtp(v),
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Verify email', onPressed: onVerify),
            TextButton(onPressed: onResend, child: const Text('Resend OTP')),
          ],
        ),
      ),
    );
  }
}
