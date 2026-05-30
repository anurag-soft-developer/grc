import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/core/utils/validators.dart';

class ChangePasswordScreen extends HookWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final authRepo = Get.find<AuthRepository>();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final currentPassword = useTextEditingController();
    final newPassword = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final otpController = useTextEditingController();
    final needsOtp = useState(false);

    final user = authState.user;
    final requiresOtp =
        user?.isPasswordExists != true || user?.twoFactorEnabled == true;

    final sendOtpMutation = useMutation<bool, Object, void, void>(
      (_, __) => authRepo.sendChangePasswordOtp(),
      mutationKey: const ['mutation', 'sendChangePasswordOtp'],
    );

    final changeMutation = useMutation<bool, Object, void, void>(
      (_, __) async {
        if (!formKey.currentState!.validate()) {
          throw Exception('Validation failed');
        }
        return authRepo.changePassword(
          newPassword: newPassword.text.trim(),
          currentPassword: requiresOtp ? null : currentPassword.text.trim(),
          otp: requiresOtp ? otpController.text.trim() : null,
        );
      },
      mutationKey: QueryKeys.changePassword,
      onSuccess: (ok, _, __, ___) {
        if (ok) {
          ExceptionHandler.showSuccessToast('Password updated');
          Get.back();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: MutationLoadingOverlay(
        mutationKey: QueryKeys.changePassword,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                if (!requiresOtp) ...[
                  CustomTextField(
                    controller: currentPassword,
                    labelText: 'Current password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                ],
                if (requiresOtp) ...[
                  if (!needsOtp.value)
                    CustomButton(
                      text: 'Send OTP',
                      onPressed: () {
                        sendOtpMutation.mutate(null);
                        needsOtp.value = true;
                        ExceptionHandler.showSuccessToast(
                          AppConstants.successMessages.otpSent,
                        );
                      },
                    ),
                  if (needsOtp.value) ...[
                    CustomTextField(
                      controller: otpController,
                      labelText: 'OTP',
                      validator: (v) => Validators.validateOtp(v),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
                CustomTextField(
                  controller: newPassword,
                  labelText: 'New password',
                  obscureText: true,
                  validator: Validators.validateSignupPassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: confirmPassword,
                  labelText: 'Confirm password',
                  obscureText: true,
                  validator: (v) => Validators.validateConfirmPassword(
                    v,
                    newPassword.text,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Update password',
                  onPressed: () => changeMutation.mutate(null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
