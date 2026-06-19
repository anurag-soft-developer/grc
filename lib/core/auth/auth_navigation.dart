import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/routes/app_routes.dart';

/// Post-login / session-restore navigation that preserves deep links on web reload.
class AuthNavigation {
  AuthNavigation._();

  static const redirectParam = 'redirect';

  static String intendedPath(String? route) {
    final raw = route?.trim();
    if (raw != null && raw.isNotEmpty) return _pathOnly(raw);

    final current = Get.currentRoute.trim();
    if (current.isNotEmpty) return _pathOnly(current);

    return _pathOnly(Uri.base.path);
  }

  static String loginPath({String? returnTo}) {
    final target = returnTo?.trim() ?? '';
    if (!_isValidReturnTo(target)) return AppConstants.routes.login;
    return '${AppConstants.routes.login}?$redirectParam=${Uri.encodeComponent(target)}';
  }

  static String readRedirectParam() {
    final value = Get.parameters[redirectParam]?.trim();
    return value != null && value.isNotEmpty ? _pathOnly(value) : '';
  }

  static String postAuthDestination({String? fallback}) {
    final auth = Get.find<AuthStateController>();

    if (!auth.isLoggedIn) {
      return AppConstants.routes.login;
    }

    final returnTo = readRedirectParam();

    if (auth.user?.isEmailVerified != true) {
      return AppConstants.routes.verifyEmailPath(
        email: auth.user?.email,
        redirect: returnTo.isNotEmpty ? returnTo : null,
      );
    }

    if (returnTo.isNotEmpty && _isValidReturnTo(returnTo)) {
      return returnTo;
    }

    return fallback ?? AppRoutes.mainRoute;
  }

  static void goAfterAuth({String? fallback}) {
    Get.offAllNamed(postAuthDestination(fallback: fallback));
  }

  static String _pathOnly(String route) {
    final path = Uri.parse(route).path;
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }

  static bool _isValidReturnTo(String path) {
    if (path.isEmpty || path == AppRoutes.splashRoute) return false;

    const blocked = {
      '/login',
      '/signup',
      '/forgot-password',
      '/verify-email',
      '/auth/callback',
      '/access-denied',
    };

    if (blocked.contains(path)) return false;
    if (path.startsWith('${AppConstants.routes.login}?')) return false;
    if (path.startsWith('${AppConstants.routes.verifyEmail}?')) return false;

    return true;
  }
}
