import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/routes/app_routes.dart';

AuthStateController get _auth => Get.find<AuthStateController>();

class PublicGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (_auth.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.mainRoute);
    }
    return null;
  }
}

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!_auth.isLoggedIn) {
      return RouteSettings(name: AppConstants.routes.login);
    }

    if (_auth.user?.isEmailVerified != true &&
        route != AppConstants.routes.verifyEmail) {
      return RouteSettings(
        name: AppConstants.routes.verifyEmail,
        arguments: {'email': _auth.user?.email},
      );
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
