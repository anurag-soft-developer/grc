import 'package:grc/core/models/user/user_model.dart';

/// Lean user id ([String]) or populated [UserModel] (e.g. run event `createdBy`).
class UserRefFieldInstance {
  final dynamic _user;

  const UserRefFieldInstance(this._user);

  String? getId() {
    if (_user is String) return _user;
    if (_user is UserModel) return _user.id;
    return null;
  }

  UserModel? getModel() {
    if (_user is UserModel) return _user;
    return null;
  }

  String? getName() {
    if (_user is UserModel) return _user.displayName;
    return null;
  }

  String getDisplayName() {
    final name = getName();
    if (name != null) return name;
    final id = getId();
    return id != null ? 'User $id' : 'Unknown user';
  }

  bool get isPopulated => _user is UserModel;

  bool get isIdOnly => _user is String;
}
