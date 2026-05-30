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
    final initialOtpSent = useState(false);

    final user = authState.user;
    final hasPassword = user?.isPasswordExists == true;
    final twoFactorOn = user?.twoFactorEnabled == true;
    final needsOtpForVerification = !hasPassword || twoFactorOn;

    final sendOtpMutation = useMutation<bool, Object, void, void>(
      (_, __) => authRepo.sendChangePasswordOtp(),
      mutationKey: const ['mutation', 'sendChangePasswordOtp'],
      onSuccess: (ok, _, __, ___) {
        if (ok) {
          initialOtpSent.value = true;
        }
      },
    );

    useEffect(() {
      if (!needsOtpForVerification) return null;
      sendOtpMutation.mutate(null);
      return null;
    }, const []);

    final changeMutation = useMutation<bool, Object, void, void>(
      (_, __) async {
        if (!formKey.currentState!.validate()) {
          throw Exception('Validation failed');
        }
        return authRepo.changePassword(
          newPassword: newPassword.text.trim(),
          currentPassword:
              hasPassword ? currentPassword.text.trim() : null,
          otp: needsOtpForVerification ? otpController.text.trim() : null,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (needsOtpForVerification) ...[
                  Text(
                    twoFactorOn && hasPassword
                        ? 'Two-factor authentication is on. Enter the code we email you, plus your current password.'
                        : twoFactorOn
                            ? 'Two-factor authentication is on. Enter the code we email you.'
                            : 'You signed in without a password. Enter the code we email you to set a new password.',
                    style: const TextStyle(
                      color: Color(AppColors.textSecondary),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: otpController,
                    labelText: 'Verification code',
                    hintText: '${AppConstants.otp.length}-digit code',
                    keyboardType: TextInputType.number,
                    validator: Validators.validateOtp,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: sendOtpMutation.isPending
                          ? null
                          : () {
                              sendOtpMutation.mutate(null);
                              if (initialOtpSent.value) {
                                ExceptionHandler.showSuccessToast(
                                  AppConstants.successMessages.otpSent,
                                );
                              }
                            },
                      child: sendOtpMutation.isPending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              initialOtpSent.value ? 'Resend code' : 'Send code',
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (hasPassword) ...[
                  CustomTextField(
                    controller: currentPassword,
                    labelText: 'Current password',
                    obscureText: true,
                    validator: (v) =>
                        Validators.validateRequired(v, 'Current password'),
                  ),
                  const SizedBox(height: 16),
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
                  labelText: 'Confirm new password',
                  obscureText: true,
                  validator: (v) => Validators.validateConfirmPassword(
                    v,
                    newPassword.text,
                  ),
                ),
                const SizedBox(height: 32),
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
