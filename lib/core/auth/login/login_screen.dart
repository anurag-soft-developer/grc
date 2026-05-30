import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/auth/login/login_controller.dart';
import 'package:grc/core/auth/login/login_otp_challenge_view.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/app_routes.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/core/utils/validators.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final authState = Get.find<AuthStateController>();
    final authRepo = Get.find<AuthRepository>();

    final loginMutation = useMutation<LoginResult?, Object, void, void>(
      (_, __) async {
        if (!controller.loginFormKey.currentState!.validate()) {
          throw Exception('Validation failed');
        }
        return authRepo.login(
          email: controller.emailController.text.trim(),
          password: controller.passwordController.text.trim(),
        );
      },
      mutationKey: QueryKeys.login,
      onSuccess: (result, _, __, ___) {
        if (result == null) return;
        if (result.user != null) {
          authState.setUser(result.user!);
          Get.offAllNamed(AppRoutes.mainRoute);
        } else if (result.otpChallenge != null) {
          controller.pendingOtpChallenge.value = result.otpChallenge;
          controller.otpController.clear();
          ExceptionHandler.showSuccessToast(
            result.otpChallenge!.message.isNotEmpty
                ? result.otpChallenge!.message
                : 'OTP sent. Please verify to continue.',
          );
        }
      },
    );

    final googleMutation = useMutation<UserModel?, Object, void, void>(
      (_, __) => authRepo.signInWithGoogle(),
      mutationKey: QueryKeys.googleSignIn,
      onSuccess: (user, _, __, ___) {
        if (user != null) {
          authState.setUser(user);
          Get.offAllNamed(AppRoutes.mainRoute);
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: Obx(() {
        final challenge = controller.pendingOtpChallenge.value;
        if (challenge != null) {
          return LoginOtpChallengeView(
            challenge: challenge,
            controller: controller,
          );
        }

        return MutationLoadingOverlay(
          mutationKey: QueryKeys.login,
          child: MutationLoadingOverlay(
            mutationKey: QueryKeys.googleSignIn,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(AppColors.text),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to GRC runs',
                        style: TextStyle(color: Color(AppColors.textSecondary)),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        controller: controller.emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: controller.passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: Validators.validateLoginPassword,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: controller.goToForgotPassword,
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Sign in',
                        onPressed: () => loginMutation.mutate(null),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Continue with Google',
                        isOutlined: true,
                        icon: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://developers.google.com/identity/images/g-logo.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onPressed: () => googleMutation.mutate(null),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('New here? '),
                          TextButton(
                            onPressed: controller.goToSignup,
                            child: const Text('Join GRC runs'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
