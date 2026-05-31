import 'package:get/get.dart';
import 'package:grc/admin/form/event_form_screen.dart';
import 'package:grc/admin/events/event_detail_screen.dart';
import 'package:grc/admin/form/event_form_binding.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/guards/auth_guard.dart';

final List<GetPage<dynamic>> adminRoutes = [
  GetPage(
    name: AppConstants.routes.eventForm,
    page: () => const EventFormScreen(),
    binding: EventFormBinding(),
    preventDuplicates: false,
    middlewares: [
      AuthGuard(),
      RoleGuard(allowedRoles: ['admin']),
    ],
  ),
  GetPage(
    name: AppConstants.routes.adminEventDetail,
    page: () => const EventDetailScreen(),
    middlewares: [
      AuthGuard(),
      RoleGuard(allowedRoles: ['admin']),
    ],
  ),
];
