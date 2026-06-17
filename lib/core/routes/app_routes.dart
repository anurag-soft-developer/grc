import 'package:get/get.dart';
import 'package:grc/bindings/main_screen_wrapper_binding.dart';
import 'package:grc/core/components/bottom_navigation_panel/main_screen_wrapper.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/guards/auth_guard.dart';
import 'package:grc/core/routes/admin_routes.dart';
import 'package:grc/core/routes/auth_routes.dart';
import 'package:grc/core/routes/main_tab_routes.dart';
import 'package:grc/core/routes/profile_routes.dart';
import 'package:grc/core/routes/settings_routes.dart';
import 'package:grc/events/event_detail_screen.dart';
import 'package:grc/core/views/access_denied_screen.dart';
import 'package:grc/core/views/splash_screen.dart';
import 'package:grc/registrations/event_registration_binding.dart';
import 'package:grc/components/registration/event_registration_form_screen.dart';
import 'package:grc/registrations/registration_detail_screen.dart';

class AppRoutes {
  static const String splashRoute = '/';
  static const String mainRoute = MainTabRoutes.legacyMain;

  static GetPage _mainTabPage(String name) {
    return GetPage(
      name: name,
      page: () => const MainScreenWrapper(),
      binding: NavigationBinding(),
      middlewares: [AuthGuard()],
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    );
  }

  static final routes = [
    GetPage(name: splashRoute, page: () => const AuthWrapper()),
    _mainTabPage(mainRoute),
    _mainTabPage(MainTabRoutes.home),
    _mainTabPage(MainTabRoutes.events),
    _mainTabPage(MainTabRoutes.registrations),
    _mainTabPage(MainTabRoutes.profile),
    _mainTabPage(MainTabRoutes.dashboard),
    _mainTabPage(MainTabRoutes.myEvents),
    GetPage(
      name: AppConstants.routes.eventDetail,
      page: () => const EventDetailScreen(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppConstants.routes.registrationForm,
      page: () => const EventRegistrationFormScreen(),
      binding: EventRegistrationBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppConstants.routes.registrationDetail,
      page: () => const RegistrationDetailScreen(),
      binding: EventRegistrationBinding(),
      middlewares: [AuthGuard()],
    ),
    ...authRoutes,
    ...adminRoutes,
    ...profileRoutes,
    ...settingsRoutes,
    GetPage(name: '/access-denied', page: () => const AccessDeniedScreen()),
  ];
}
