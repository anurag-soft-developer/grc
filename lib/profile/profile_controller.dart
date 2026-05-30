import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/models/user/user_model.dart';

class ProfileController extends GetxController {
  final AuthStateController _authState = Get.find();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxList<String> avatarImageUrls = <String>[].obs;
  final Rxn<String> pendingAvatarLocalPath = Rxn<String>();
  final RxList<String> pendingRemoteAvatarDeletes = <String>[].obs;

  void initFromUser(UserModel? user) {
    if (user == null) return;
    fullNameController.text = user.fullName ?? '';
    phoneController.text = user.phone ?? '';
    bioController.text = user.bio ?? '';
    avatarImageUrls
      ..clear()
      ..addAll(user.avatar != null && user.avatar!.isNotEmpty
          ? [user.avatar!]
          : []);
  }

  void queueRemoteAvatarDeletion(String url) {
    pendingRemoteAvatarDeletes.add(url);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
