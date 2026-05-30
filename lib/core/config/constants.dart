import 'package:grc/core/config/app_colors.dart';
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

  final String login = '/login';
  final String signup = '/signup';
  final String forgotPassword = '/forgot-password';
  final String verifyEmail = '/verify-email';
  final String profile = '/profile';
  final String editProfile = '/edit-profile';
  final String settings = '/settings';
  final String changePassword = '/change-password';
  final String twoFactorAuth = '/two-factor';
  final String accessDenied = '/access-denied';
}

class StorageKeys {
  const StorageKeys();

  final String accessToken = 'access_token';
  final String refreshToken = 'refresh_token';
  final String userData = 'user_data';
  final String isLoggedIn = 'is_logged_in';
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
