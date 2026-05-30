import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/core/utils/validators.dart';

class TwoFactorScreen extends HookWidget {
  const TwoFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final authRepo = Get.find<AuthRepository>();
    final client = useQueryClient();
    final otpController = useTextEditingController();
    final otpSent = useState(false);
    final enabled = authState.user?.twoFactorEnabled == true;

    final sendOtpMutation = useMutation<bool, Object, void, void>(
      (_, __) => authRepo.sendTwoFactorOtp(),
      mutationKey: const ['mutation', 'sendTwoFactorOtp'],
      onSuccess: (ok, _, __, ___) {
        if (ok) {
          otpSent.value = true;
          ExceptionHandler.showSuccessToast(AppConstants.successMessages.otpSent);
        }
      },
    );

    final updateMutation = useMutation<UserModel?, Object, bool, void>(
      (targetEnabled, _) => authRepo.updateTwoFactor(
        enabled: targetEnabled,
        otp: otpController.text.trim(),
      ),
      mutationKey: QueryKeys.updateTwoFactor,
      onSuccess: (user, _, __, ___) async {
        if (user != null) {
          authState.setUser(user);
          await client.invalidateQueries(queryKey: QueryKeys.profile);
          Get.back();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Two-factor authentication')),
      body: MutationLoadingOverlay(
        mutationKey: QueryKeys.updateTwoFactor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                enabled
                    ? '2FA is currently enabled. Enter OTP to disable.'
                    : 'Enable 2FA with an email OTP.',
              ),
              const SizedBox(height: 24),
              if (!otpSent.value)
                CustomButton(
                  text: 'Send OTP',
                  onPressed: () => sendOtpMutation.mutate(null),
                ),
              if (otpSent.value) ...[
                CustomTextField(
                  controller: otpController,
                  labelText: 'OTP',
                  validator: (v) => Validators.validateOtp(v),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: enabled ? 'Disable 2FA' : 'Enable 2FA',
                  onPressed: () => updateMutation.mutate(!enabled),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
