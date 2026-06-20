import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_navigation.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/auth/signup/signup_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/main_tab_routes.dart';
import 'package:grc/core/utils/validators.dart';

class SignupScreen extends HookWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();
    final authState = Get.find<AuthStateController>();
    final authRepo = Get.find<AuthRepository>();

    final registerMutation = useMutation<UserModel?, Object, void, void>(
      (_, __) async {
        if (!controller.formKey.currentState!.validate()) {
          throw Exception('Validation failed');
        }
        return authRepo.register(
          email: controller.emailController.text.trim(),
          password: controller.passwordController.text.trim(),
          fullName: controller.fullNameController.text.trim(),
          phone: controller.phoneController.text.trim().isEmpty
              ? null
              : controller.phoneController.text.trim(),
        );
      },
      mutationKey: QueryKeys.register,
      onSuccess: (user, _, __, ___) {
        if (user != null) {
          authState.setUser(user);
          AuthNavigation.goAfterAuth();
        }
      },
    );

    final googleMutation = useMutation<UserModel?, Object, void, void>(
      (_, __) => authRepo.signInWithGoogle(),
      mutationKey: QueryKeys.googleSignIn,
      onSuccess: (user, _, __, ___) {
        if (user != null) {
          authState.setUser(user);
          AuthNavigation.goAfterAuth();
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        backgroundColor: const Color(AppColors.background),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Join GRC runs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(AppColors.text)),
          onPressed: () => Get.offAllNamed(MainTabRoutes.events),
        ),
      ),
      body: MutationLoadingOverlay(
        mutationKey: QueryKeys.register,
        child: MutationLoadingOverlay(
          mutationKey: QueryKeys.googleSignIn,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 40 : 24,
                    vertical: isWide ? 32 : 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(AppColors.surface),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(AppColors.divider),
                          ),
                          boxShadow: isWide
                              ? const [
                                  BoxShadow(
                                    color: Color(0x16000000),
                                    blurRadius: 24,
                                    offset: Offset(0, 10),
                                  ),
                                ]
                              : null,
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: controller.fullNameController,
                                labelText: 'Full name',
                                validator: Validators.validateFullName,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: controller.emailController,
                                labelText: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: controller.phoneController,
                                labelText: 'Phone (optional)',
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: controller.passwordController,
                                labelText: 'Password',
                                obscureText: true,
                                validator: Validators.validateSignupPassword,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller:
                                    controller.confirmPasswordController,
                                labelText: 'Confirm password',
                                obscureText: true,
                                validator: (v) =>
                                    Validators.validateConfirmPassword(
                                      v,
                                      controller.passwordController.text,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              CustomButton(
                                text: 'Create account',
                                onPressed: () => registerMutation.mutate(null),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Continue with Google',
                                isOutlined: true,
                                icon: SvgPicture.asset(
                                  'assets/logos/google.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                onPressed: () => googleMutation.mutate(null),
                              ),
                              TextButton(
                                onPressed: controller.goToLogin,
                                child: const Text(
                                  'Already have an account? Sign in',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
