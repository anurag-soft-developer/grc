import 'package:get/get.dart';
import 'package:grc/bindings/main_screen_wrapper_binding.dart';
import 'package:grc/core/components/bottom_navigation_panel/main_screen_wrapper.dart';
import 'package:grc/core/guards/auth_guard.dart';
import 'package:grc/core/routes/auth_routes.dart';
import 'package:grc/core/routes/profile_routes.dart';
import 'package:grc/core/routes/settings_routes.dart';
import 'package:grc/core/views/access_denied_screen.dart';
import 'package:grc/core/views/splash_screen.dart';

class AppRoutes {
  static const String splashRoute = '/';
  static const String mainRoute = '/main';

  static final routes = [
    GetPage(name: splashRoute, page: () => const AuthWrapper()),
    GetPage(
      name: mainRoute,
      page: () => const MainScreenWrapper(),
      binding: NavigationBinding(),
      middlewares: [AuthGuard()],
    ),
    ...authRoutes,
    ...profileRoutes,
    ...settingsRoutes,
    GetPage(
      name: '/access-denied',
      page: () => const AccessDeniedScreen(),
    ),
  ];
}
