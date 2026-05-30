import 'package:get/get.dart';
import 'package:grc/bindings/edit_profile_binding.dart';
import 'package:grc/bindings/profile_binding.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/guards/auth_guard.dart';
import 'package:grc/profile/edit_profile_screen.dart';
import 'package:grc/profile/profile_screen.dart';

final profileRoutes = [
  GetPage(
    name: AppConstants.routes.profile,
    page: () => const ProfileScreen(),
    binding: ProfileBinding(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: AppConstants.routes.editProfile,
    page: () => const EditProfileScreen(),
    binding: EditProfileBinding(),
    middlewares: [AuthGuard()],
  ),
];
