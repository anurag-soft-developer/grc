import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/app_routes.dart';
import 'package:grc/core/services/auth_storage_service.dart';
import 'package:grc/core/utils/exception_handler.dart';

class GoogleAuthCallbackScreen extends StatefulWidget {
  const GoogleAuthCallbackScreen({super.key});

  @override
  State<GoogleAuthCallbackScreen> createState() =>
      _GoogleAuthCallbackScreenState();
}

class _GoogleAuthCallbackScreenState extends State<GoogleAuthCallbackScreen> {
  final AuthStorageService _storage = AuthStorageService();
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final AuthStateController _authState = Get.find<AuthStateController>();

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _completeGoogleAuth();
  }

  Future<void> _completeGoogleAuth() async {
    try {
      final uri = Uri.base;
      final accessToken = _normalizeToken(
        uri.queryParameters['token'] ?? uri.queryParameters['accessToken'],
      );
      final refreshToken = _normalizeToken(
        uri.queryParameters['refresh'] ?? uri.queryParameters['refreshToken'],
      );

      if (accessToken == null || refreshToken == null) {
        throw Exception('Missing or invalid OAuth tokens');
      }

      final status = await _authRepo.getAuthStatus(
        accessTokenOverride: accessToken,
      );
      if (status == null) {
        throw Exception('Unable to complete Google Sign-In');
      }

      await _storage.storeAuthData(
        AuthResponse(
          user: status.user,
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
      _authState.setUser(status.user);
      ExceptionHandler.showSuccessToast('Google Sign-In successful');

      if (!mounted) return;
      Get.offAllNamed(AppRoutes.mainRoute);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Google sign-in failed. Please try again.';
        _isLoading = false;
      });
    }
  }

  String? _normalizeToken(String? raw) {
    if (raw == null) return null;
    final token = raw.trim();
    if (token.isEmpty) return null;

    final lowered = token.toLowerCase();
    if (lowered == 'null' || lowered == 'undefined') return null;
    return token;
  }

  void _goToLogin() {
    Get.offAllNamed(AppConstants.routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text('Completing Google sign-in...'),
                    ] else ...[
                      Text(
                        _error ?? 'Unable to complete sign-in.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(AppColors.error)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _goToLogin,
                        child: const Text('Back to sign in'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
