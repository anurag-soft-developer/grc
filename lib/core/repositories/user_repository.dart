import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/services/api_service.dart';
import 'package:grc/core/services/auth_storage_service.dart';
import 'package:grc/core/utils/exception_handler.dart';

class UserRepository {
  final ApiService _api = ApiService();
  final AuthStorageService _storage = AuthStorageService();

  Future<UserModel?> getProfile() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.user.profile,
    );
    if (response == null) return null;
    return UserModel.fromMap(response);
  }

  Future<UserModel?> updateProfile({
    String? fullName,
    String? bio,
    String? phone,
    String? avatar,
  }) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.user.profile,
      data: {
        if (fullName != null) 'fullName': fullName,
        if (bio != null) 'bio': bio,
        if (phone != null) 'phone': phone,
        if (avatar != null) 'avatar': avatar,
      },
    );
    if (response == null) return null;
    final user = UserModel.fromMap(response);
    await _storage.saveUser(user);
    ExceptionHandler.showSuccessToast(AppConstants.successMessages.profileUpdate);
    return user;
  }
}
