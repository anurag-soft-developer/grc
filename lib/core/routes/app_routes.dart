import 'package:get/get.dart';
import 'package:grc/bindings/main_screen_wrapper_binding.dart';
import 'package:grc/core/components/bottom_navigation_panel/main_screen_wrapper.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/guards/auth_guard.dart';
import 'package:grc/core/routes/admin_routes.dart';
import 'package:grc/core/routes/auth_routes.dart';
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
  static const String mainRoute = '/main';

  static final routes = [
    GetPage(name: splashRoute, page: () => const AuthWrapper()),
    GetPage(
      name: mainRoute,
      page: () => const MainScreenWrapper(),
      binding: NavigationBinding(),
      middlewares: [AuthGuard()],
    ),
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
