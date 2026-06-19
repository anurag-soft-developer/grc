import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/repositories/user_repository.dart';

class InitialBinding extends Bindings {
  InitialBinding({required this.queryClient});

  final QueryClient queryClient;

  @override
  void dependencies() {
    if (!Get.isRegistered<QueryClient>()) {
      Get.put<QueryClient>(queryClient, permanent: true);
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(AuthRepository(), permanent: true);
    }
    if (!Get.isRegistered<UserRepository>()) {
      Get.put<UserRepository>(UserRepository(), permanent: true);
    }
    if (!Get.isRegistered<AuthStateController>()) {
      Get.put<AuthStateController>(AuthStateController(), permanent: true);
    }
  }
}
