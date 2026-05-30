import 'package:get/get.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/guards/auth_guard.dart';
import 'package:grc/core/views/legal/privacy_policy_screen.dart';
import 'package:grc/core/views/legal/terms_of_service_screen.dart';
import 'package:grc/settings/change_password_screen.dart';
import 'package:grc/settings/settings_screen.dart';
import 'package:grc/settings/two_factor_screen.dart';

final settingsRoutes = [
  GetPage(
    name: AppConstants.routes.settings,
    page: () => const SettingsScreen(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: AppConstants.routes.changePassword,
    page: () => const ChangePasswordScreen(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: AppConstants.routes.twoFactorAuth,
    page: () => const TwoFactorScreen(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: AppConstants.routes.termsOfService,
    page: () => const TermsOfServiceScreen(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: AppConstants.routes.privacyPolicy,
    page: () => const PrivacyPolicyScreen(),
    middlewares: [AuthGuard()],
  ),
];
