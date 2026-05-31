import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/models/user/user_ref_field_instance.dart';

/// Decodes `createdBy` as a user id ([String]) or populated [UserModel].
class UserRefHook extends MappingHook {
  const UserRefHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) return null;
    if (value is String) return UserRefFieldInstance(value);
    if (value is Map) {
      return UserRefFieldInstance(
        UserModelMapper.fromMap(Map<String, dynamic>.from(value)),
      );
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is! UserRefFieldInstance) return value;
    if (value.isIdOnly) return value.getId();
    final user = value.getModel();
    if (user != null) return user.toMap();
    return null;
  }
}
