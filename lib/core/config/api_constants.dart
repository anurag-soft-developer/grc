import 'package:grc/core/config/env_config.dart';

class ApiConstants {
  static final String baseUrl = EnvConfig.baseApiUrl;

  static const auth = AuthEndpoints();
  static const user = UserEndpoints();
  static const storage = StorageEndpoints();
  static const runEvents = RunEventEndpoints();

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 5);
}

class AuthEndpoints {
  const AuthEndpoints();

  String get login => '/auth/login';
  String get verifyLoginOtp => '/auth/login/verify-otp';
  String get register => '/auth/register';
  String get refreshToken => '/auth/refresh';
  String get logout => '/auth/logout';
  String get status => '/auth/status';
  String get forgotPassword => '/auth/forgot-password';
  String get resetPassword => '/auth/reset-password';
  String get changePassword => '/auth/change-password';
  String get sendChangePasswordOtp => '/auth/change-password/send-otp';
  String get sendTwoFactorOtp => '/auth/2fa-setting/send-otp';
  String get updateTwoFactor => '/auth/2fa-setting';
  String get sendVerificationEmail => '/auth/send-verification-email';
  String get verifyEmail => '/auth/verify-email';
  String get googleMobile => '/auth/google/mobile';
}

class UserEndpoints {
  const UserEndpoints();

  String get profile => '/users/profile';
}

class StorageEndpoints {
  const StorageEndpoints();

  String get uploadUrl => '/storage/upload-url';
  String get delete => '/storage/objects';
}

class RunEventEndpoints {
  const RunEventEndpoints();

  String get list => '/run-events';
  String get publicList => '/run-events/public';
  String get create => '/run-events';
  String eventById(String id) => '/run-events/$id';
  String publish(String id) => '/run-events/$id/publish';
  String close(String id) => '/run-events/$id/close';
  String archive(String id) => '/run-events/$id/archive';
  String pauseRegistrations(String id) =>
      '/run-events/$id/pause-registrations';
  String resumeRegistrations(String id) =>
      '/run-events/$id/resume-registrations';
}
