import 'package:grc/core/config/env_config.dart';

export 'app_colors.dart';

class AppConstants {
  static final String appName = EnvConfig.appName;

  static const routes = Routes();
  static const storageKeys = StorageKeys();
  static const errorMessages = ErrorMessages();
  static const successMessages = SuccessMessages();
  static const otp = OtpConstants();
}

class Routes {
  const Routes();

  final String authCallback = '/auth/callback';
  final String login = '/login';
  final String signup = '/signup';
  final String forgotPassword = '/forgot-password';
  final String verifyEmail = '/verify-email';
  final String profile = '/profile';
  final String editProfile = '/edit-profile';
  final String settings = '/settings';
  final String changePassword = '/change-password';
  final String twoFactorAuth = '/two-factor';
  final String termsOfService = '/terms-of-service';
  final String privacyPolicy = '/privacy-policy';
  final String accessDenied = '/access-denied';
  final String eventForm = '/admin/event-form';
  final String paymentsRazorpayCallback = '/payments/razorpay/callback';

  String eventDetailPath(String slug) => '/events/$slug';

  String adminEventDetailPath(String id) => '/admin/events/$id';

  String registrationDetailPath(String id) => '/registrations/$id';

  String registrationFormPath(String id) => '/events/$id/register';

  String adminEventParticipantsPath(String id) =>
      '/admin/events/$id/participants';

  String adminEventAnalyticsPath(String id) => '/admin/events/$id/analytics';

  String adminEventQuestionnairesPath(String id) =>
      '/admin/events/$id/questionnaires';

  String adminFormBuilderPath(String id) => '/admin/events/$id/form-builder';

  String adminEventFormEditPath(String id) => '/admin/event-form/$id';

  String verifyEmailPath({String? email, String? redirect}) {
    final params = <String, String>{};
    if (email != null && email.isNotEmpty) {
      params['email'] = email;
    }
    if (redirect != null && redirect.isNotEmpty) {
      params['redirect'] = redirect;
    }
    if (params.isEmpty) return verifyEmail;
    return '$verifyEmail?${params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';
  }
}

enum AppMode {
  user('user'),
  admin('admin');

  const AppMode(this.value);
  final String value;

  static AppMode fromValue(String? raw) {
    if (raw == AppMode.admin.value) return AppMode.admin;
    return AppMode.user;
  }
}

class StorageKeys {
  const StorageKeys();

  final String accessToken = 'access_token';
  final String refreshToken = 'refresh_token';
  final String userData = 'user_data';
  final String isLoggedIn = 'is_logged_in';
  final String appMode = 'app_mode';
}

class ErrorMessages {
  const ErrorMessages();

  final String unknown = 'An unknown error occurred';
  final String authentication = 'Authentication failed';
}

class SuccessMessages {
  const SuccessMessages();

  final String login = 'Login successful';
  final String signup = 'Account created successfully';
  final String logout = 'Logged out successfully';
  final String profileUpdate = 'Profile updated successfully';
  final String otpSent = 'OTP sent to your email';
  final String passwordReset = 'Password reset successfully';
  final String emailVerified = 'Email verified successfully';
}

class OtpConstants {
  const OtpConstants();

  final int length = 6;
  final int timeoutSeconds = 300;
}
