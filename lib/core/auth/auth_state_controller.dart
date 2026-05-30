import 'package:get/get.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/app_routes.dart';

/// Local session snapshot only — no API loading flags here.
class AuthStateController extends GetxController {
  static AuthStateController get instance => Get.find();

  final AuthRepository _authRepository = Get.find();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  final RxBool _isLoggedIn = false.obs;

  UserModel? get user => _user.value;
  bool get isLoggedIn => _isLoggedIn.value;

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
  }

  void setUser(UserModel user) {
    _user.value = user;
    _isLoggedIn.value = true;
  }

  void clearSession() {
    _user.value = null;
    _isLoggedIn.value = false;
  }

  Future<void> signOut() async {
    await _authRepository.logout();
    clearSession();
    Get.offAllNamed(AppConstants.routes.login);
  }
}
