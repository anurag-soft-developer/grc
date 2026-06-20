import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_navigation.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/routes/main_tab_routes.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/services/auth_storage_service.dart';

AuthStateController get _auth => Get.find<AuthStateController>();

class PublicSessionMiddleware extends GetMiddleware {
  @override
  Widget onPageBuilt(Widget page) {
    return _PublicSessionGate(child: page);
  }
}

class _PublicSessionGate extends StatefulWidget {
  const _PublicSessionGate({required this.child});

  final Widget child;

  @override
  State<_PublicSessionGate> createState() => _PublicSessionGateState();
}

class _PublicSessionGateState extends State<_PublicSessionGate> {
  final AuthStorageService _storage = AuthStorageService();
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkStoredSession();
  }

  Future<void> _checkStoredSession() async {
    await _auth.ensureHydrated();

    if (_auth.isLoggedIn) {
      if (mounted) AuthNavigation.goAfterAuth();
      return;
    }

    final accessToken = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();
    final storedUser = await _storage.getUserFromPreferences();

    final hasTokens = accessToken != null && refreshToken != null;

    if (hasTokens && storedUser != null) {
      _auth.setUser(storedUser);
      if (mounted) AuthNavigation.goAfterAuth();
      return;
    }

    if (hasTokens) {
      final status = await _authRepo.getAuthStatus(
        accessTokenOverride: accessToken,
      );
      if (status != null) {
        await _storage.saveUser(status.user);
        _auth.setUser(status.user);
        if (mounted) AuthNavigation.goAfterAuth();
        return;
      }
    }

    if (mounted) {
      setState(() {
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Checking your session...'),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!_auth.isLoggedIn) {
      return RouteSettings(
        name: AuthNavigation.loginPath(
          returnTo: AuthNavigation.intendedPath(route),
        ),
      );
    }

    if (_auth.user?.isEmailVerified != true && !_isVerifyEmailRoute(route)) {
      final returnTo = AuthNavigation.intendedPath(route);
      return RouteSettings(
        name: AppConstants.routes.verifyEmailPath(
          email: _auth.user?.email,
          redirect: returnTo.isNotEmpty ? returnTo : null,
        ),
      );
    }

    return null;
  }

  bool _isVerifyEmailRoute(String? route) {
    final path = AuthNavigation.intendedPath(route);
    return path == AppConstants.routes.verifyEmail ||
        path.startsWith('${AppConstants.routes.verifyEmail}?');
  }
}

class MainTabAccessGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final path = AuthNavigation.intendedPath(route);

    if (_auth.isLoggedIn) {
      return null;
    }

    if (path == MainTabRoutes.events) {
      return null;
    }

    if (MainTabRoutes.isMainTabRoute(path)) {
      return RouteSettings(name: AuthNavigation.loginPath(returnTo: path));
    }

    return null;
  }
}

class RoleGuard extends GetMiddleware {
  final List<String> allowedRoles;

  RoleGuard({required this.allowedRoles});

  @override
  RouteSettings? redirect(String? route) {
    if (!allowedRoles.contains(_auth.user?.role)) {
      return RouteSettings(name: AppConstants.routes.accessDenied);
    }
    return null;
  }
}
