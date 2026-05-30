import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/avatar_image_input.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/user_repository.dart';
import 'package:grc/core/services/media_upload_service.dart';
import 'package:grc/profile/profile_controller.dart';

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final authState = Get.find<AuthStateController>();
    final userRepo = Get.find<UserRepository>();
    final client = useQueryClient();
    final avatarKey = useMemoized(() => GlobalKey<AvatarImageInputState>());

    useEffect(() {
      controller.initFromUser(authState.user);
      return null;
    }, const []);

    final saveMutation = useMutation<UserModel?, Object, void, void>(
      (_, __) async {
        if (!controller.formKey.currentState!.validate()) {
          throw Exception('Validation failed');
        }

        String? avatarUrl = await avatarKey.currentState?.uploadPendingIfNeeded();
        if (avatarUrl == null && controller.avatarImageUrls.isNotEmpty) {
          final u = controller.avatarImageUrls.first;
          if (u.startsWith('http')) avatarUrl = u;
        }

        final updated = await userRepo.updateProfile(
          fullName: controller.fullNameController.text.trim(),
          phone: controller.phoneController.text.trim(),
          bio: controller.bioController.text.trim(),
          avatar: avatarUrl,
        );

        if (updated != null && controller.pendingRemoteAvatarDeletes.isNotEmpty) {
          final keys = controller.pendingRemoteAvatarDeletes
              .map(MediaUploadService.inferObjectKeyFromPublicUrl)
              .whereType<String>()
              .toList();
          if (keys.isNotEmpty) {
            await MediaUploadService.instance.deleteObjects(keys);
          }
          controller.pendingRemoteAvatarDeletes.clear();
        }

        return updated;
      },
      mutationKey: QueryKeys.updateProfile,
      onSuccess: (user, _, __, ___) async {
        if (user != null) {
          authState.setUser(user);
          await client.invalidateQueries(queryKey: QueryKeys.profile);
          Get.back();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: MutationLoadingOverlay(
        mutationKey: QueryKeys.updateProfile,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                AvatarImageInput(
                  key: avatarKey,
                  imageUrls: controller.avatarImageUrls,
                  onDeferredRemoteRemoval: controller.queueRemoteAvatarDeletion,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: controller.fullNameController,
                  labelText: 'Full name',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.phoneController,
                  labelText: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.bioController,
                  labelText: 'Bio',
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Save',
                  onPressed: () => saveMutation.mutate(null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
