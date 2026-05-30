import 'package:get/get.dart';
import 'package:grc/core/auth/forgot_password/forgot_password_screen.dart';
import 'package:grc/core/auth/login/login_screen.dart';
import 'package:grc/core/auth/signup/signup_screen.dart';
import 'package:grc/core/auth/verify_email/verify_email_screen.dart';
import 'package:grc/core/binding/auth_binding.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/guards/auth_guard.dart';

final authRoutes = [
  GetPage(
    name: AppConstants.routes.login,
    page: () => const LoginScreen(),
    binding: LoginBinding(),
    middlewares: [PublicGuard()],
  ),
  GetPage(
    name: AppConstants.routes.signup,
    page: () => const SignupScreen(),
    binding: SignupBinding(),
    middlewares: [PublicGuard()],
  ),
  GetPage(
    name: AppConstants.routes.forgotPassword,
    page: () => const ForgotPasswordScreen(),
    middlewares: [PublicGuard()],
  ),
  GetPage(
    name: AppConstants.routes.verifyEmail,
    page: () => const VerifyEmailScreen(),
    binding: VerifyEmailBinding(),
  ),
];
