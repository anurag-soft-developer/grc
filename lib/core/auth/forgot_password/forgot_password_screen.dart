import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/forgot_password/forgot_password_email_step.dart';
import 'package:grc/components/forgot_password/forgot_password_otp_step.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/utils/exception_handler.dart';

class ForgotPasswordScreen extends HookWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final email = useState('');
    final authRepo = Get.find<AuthRepository>();

    final sendOtpMutation = useMutation<bool, Object, String, void>(
      (addr, _) => authRepo.sendPasswordResetOtp(addr),
      mutationKey: QueryKeys.forgotPassword,
      onSuccess: (ok, addr, _, __) {
        if (ok) {
          email.value = addr;
          ExceptionHandler.showSuccessToast(AppConstants.successMessages.otpSent);
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
    );

    final resetMutation = useMutation<bool, Object, Map<String, String>, void>(
      (vars, _) => authRepo.resetPassword(
        email: vars['email']!,
        otp: vars['otp']!,
        password: vars['password']!,
      ),
      mutationKey: QueryKeys.resetPassword,
      onSuccess: (ok, _, __, ___) {
        if (ok) {
          ExceptionHandler.showSuccessToast(
            AppConstants.successMessages.passwordReset,
          );
          Get.back();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ForgotPasswordEmailStep(
            mutationKey: QueryKeys.forgotPassword,
            onSubmit: (addr) => sendOtpMutation.mutate(addr),
          ),
          ForgotPasswordOtpStep(
            email: email.value,
            mutationKey: QueryKeys.resetPassword,
            onBack: () => pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            onSubmit: (otp, password) => resetMutation.mutate({
              'email': email.value,
              'otp': otp,
              'password': password,
            }),
            onResend: () => sendOtpMutation.mutate(email.value),
          ),
        ],
      ),
    );
  }
}
