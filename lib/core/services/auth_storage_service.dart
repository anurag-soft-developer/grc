import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static final AuthStorageService _instance = AuthStorageService._internal();
  factory AuthStorageService() => _instance;
  AuthStorageService._internal();

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.storageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.storageKeys.refreshToken);
  }

  Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageKeys.accessToken, token);
  }

  Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageKeys.refreshToken, token);
  }

  Future<void> storeAuthData(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.storageKeys.accessToken,
      authResponse.accessToken,
    );
    await prefs.setString(
      AppConstants.storageKeys.refreshToken,
      authResponse.refreshToken,
    );
    await saveUser(authResponse.user);
    await prefs.setBool(AppConstants.storageKeys.isLoggedIn, true);
  }

  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageKeys.accessToken, accessToken);
    await prefs.setString(AppConstants.storageKeys.refreshToken, refreshToken);
    await prefs.setBool(AppConstants.storageKeys.isLoggedIn, true);
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.storageKeys.userData,
      user.toJson(),
    );
  }

  Future<UserModel?> getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.storageKeys.userData);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.storageKeys.isLoggedIn) ?? false;
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.storageKeys.accessToken);
    await prefs.remove(AppConstants.storageKeys.refreshToken);
    await prefs.remove(AppConstants.storageKeys.userData);
    await prefs.setBool(AppConstants.storageKeys.isLoggedIn, false);
  }
}
