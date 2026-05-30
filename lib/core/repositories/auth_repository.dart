import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/config/env_config.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/services/api_service.dart';
import 'package:grc/core/services/auth_storage_service.dart';
import 'package:grc/core/utils/exception_handler.dart';

class AuthRepository {
  final ApiService _api = ApiService();
  final AuthStorageService _storage = AuthStorageService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: EnvConfig.googleClientId.isNotEmpty
        ? EnvConfig.googleClientId
        : null,
  );

  Future<UserModel?> getStoredUser() async {
    try {
      final user = await _storage.getUserFromPreferences();
      final isLoggedIn = await _storage.isLoggedIn();
      final accessToken = await _storage.getAccessToken();
      if (user != null && isLoggedIn && accessToken != null) {
        return user;
      }
      await _storage.clearAuthData();
      return null;
    } catch (_) {
      await _storage.clearAuthData();
      return null;
    }
  }

  Future<AuthStatusResponse?> getAuthStatus() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.auth.status,
    );
    if (response == null) return null;
    return AuthStatusResponse.fromMap(response);
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.register,
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
    if (response == null) return null;
    final auth = AuthResponse.fromMap(response);
    await _storage.storeAuthData(auth);
    ExceptionHandler.showSuccessToast(AppConstants.successMessages.signup);
    return auth.user;
  }

  Future<LoginResult?> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.login,
      data: {'email': email, 'password': password},
    );
    if (response == null) return null;

    if (response['requiresOtp'] == true) {
      return LoginResult.challenge(
        LoginOtpChallengeResponse.fromMap(response),
      );
    }

    final auth = AuthResponse.fromMap(response);
    await _storage.storeAuthData(auth);
    ExceptionHandler.showSuccessToast(AppConstants.successMessages.login);
    return LoginResult.authenticated(auth.user);
  }

  Future<UserModel?> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.verifyLoginOtp,
      data: {'email': email, 'otp': otp},
    );
    if (response == null) return null;
    final auth = AuthResponse.fromMap(response);
    await _storage.storeAuthData(auth);
    ExceptionHandler.showSuccessToast(AppConstants.successMessages.login);
    return auth.user;
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        ExceptionHandler.showErrorToast('Google Sign-In failed');
        return null;
      }

      final response = await _api.post<Map<String, dynamic>>(
        ApiConstants.auth.googleMobile,
        data: {'idToken': idToken},
      );
      if (response == null) return null;

      final authResponse = AuthResponse.fromMap(response);
      await _storage.storeAuthData(authResponse);
      ExceptionHandler.showSuccessToast('Google Sign-In successful');
      return authResponse.user;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      ExceptionHandler.showErrorToast('Google Sign-In failed');
      return null;
    }
  }

  Future<void> logout() async {
    await _api.post(ApiConstants.auth.logout);
    await _storage.clearAuthData();
    ExceptionHandler.showSuccessToast(AppConstants.successMessages.logout);
  }

  Future<bool> sendPasswordResetOtp(String email) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.forgotPassword,
      data: {'email': email},
    );
    return response != null;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.resetPassword,
      data: {'email': email, 'otp': otp, 'password': password},
    );
    return response != null;
  }

  Future<bool> sendVerificationEmail(String email) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.sendVerificationEmail,
      data: {'email': email},
    );
    return response != null;
  }

  Future<VerifyEmailTokensResponse?> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.verifyEmail,
      data: {'email': email, 'otp': otp},
    );
    if (response == null) return null;
    final tokens = VerifyEmailTokensResponse.fromMap(response);
    await _storage.storeTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    ExceptionHandler.showSuccessToast(AppConstants.successMessages.emailVerified);
    return tokens;
  }

  Future<bool> changePassword({
    required String newPassword,
    String? currentPassword,
    String? otp,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.changePassword,
      data: {
        'newPassword': newPassword,
        if (currentPassword != null) 'currentPassword': currentPassword,
        if (otp != null) 'otp': otp,
      },
    );
    return response != null;
  }

  Future<bool> sendChangePasswordOtp() async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.sendChangePasswordOtp,
    );
    return response != null;
  }

  Future<bool> sendTwoFactorOtp() async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.auth.sendTwoFactorOtp,
    );
    return response != null;
  }

  Future<UserModel?> updateTwoFactor({
    required bool enabled,
    required String otp,
  }) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.auth.updateTwoFactor,
      data: {'enabled': enabled, 'otp': otp},
    );
    if (response == null) return null;
    return UserModel.fromMap(response);
  }
}
