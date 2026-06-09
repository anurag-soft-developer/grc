import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/services/auth_storage_service.dart';

/// Local session snapshot only — no API loading flags here.
class AuthStateController extends GetxController {
  static AuthStateController get instance => Get.find();

  final AuthRepository _authRepository = Get.find();
  final AuthStorageService _storage = AuthStorageService();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  final RxBool _isLoggedIn = false.obs;
  final RxBool isSigningOut = false.obs;
  final Rx<AppMode> appMode = AppMode.user.obs;

  UserModel? get user => _user.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isAdmin => user?.isAdmin == true;
  bool get isAdminMode => isAdmin && appMode.value == AppMode.admin;

  @override
  void onInit() {
    super.onInit();
    _hydrateFromStorage();
  }

  Future<void> _hydrateFromStorage() async {
    final stored = await _authRepository.getStoredUser();
    if (stored != null) {
      _user.value = stored;
      _isLoggedIn.value = true;
    }
    await _hydrateAppMode();
  }

  Future<void> _hydrateAppMode() async {
    final stored = await _storage.getAppMode();
    final next = isAdmin && stored == AppMode.admin
        ? AppMode.admin
        : AppMode.user;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appMode.value = next;
    });
  }

  void setUser(UserModel user) {
    _user.value = user;
    _isLoggedIn.value = true;
    if (!user.isAdmin) {
      _applyAppMode(AppMode.user, persist: true);
    }
  }

  void clearSession() {
    _user.value = null;
    _isLoggedIn.value = false;
    appMode.value = AppMode.user;
  }

  Future<void> setAppMode(AppMode mode) async {
    if (mode == AppMode.admin && !isAdmin) return;
    await _applyAppMode(mode, persist: true);
    if (Get.isRegistered<NavigationController>()) {
      Get.find<NavigationController>().resetToFirstTab();
    }
  }

  Future<void> _applyAppMode(AppMode mode, {required bool persist}) async {
    appMode.value = mode;
    if (persist) {
      await _storage.setAppMode(mode);
    }
  }

  Future<void> signOut() async {
    if (isSigningOut.value) return;
    isSigningOut.value = true;
    try {
      await _authRepository.logout();
      clearSession();
      Get.offAllNamed(AppConstants.routes.login);
    } finally {
      isSigningOut.value = false;
    }
  }
}
