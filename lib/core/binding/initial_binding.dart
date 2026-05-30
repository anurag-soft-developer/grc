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
    Get.put<QueryClient>(queryClient, permanent: true);
    Get.put<AuthRepository>(AuthRepository(), permanent: true);
    Get.put<UserRepository>(UserRepository(), permanent: true);
    Get.put<AuthStateController>(AuthStateController(), permanent: true);
  }
}
