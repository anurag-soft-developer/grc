import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/repositories/user_repository.dart';

/// Profile tab inside main shell (uses cached user + optional refetch).
class ProfileTabScreen extends HookWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = Get.find<UserRepository>();
    final authState = Get.find<AuthStateController>();

    final profileQuery = useQuery(
      QueryKeys.profile,
      (_) => userRepo.getProfile(),
    );

    useEffect(() {
      final data = profileQuery.data;
      if (data != null) authState.setUser(data);
      return null;
    }, [profileQuery.data]);

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(AppConstants.routes.settings),
          ),
        ],
      ),
      body: QueryAsyncBody<UserModel?, dynamic>(
        state: profileQuery,
        onRetry: () => profileQuery.refetch(),
        data: (profile) {
          final user = profile ?? authState.user;
          if (user == null) {
            return const Center(child: Text('No profile data'));
          }
          return ProfileContent(user: user);
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const ProfileTabScreen();
}

class ProfileContent extends StatelessWidget {
  final UserModel user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (user.isEmailVerified != true)
          Card(
            color: const Color(AppColors.primary).withValues(alpha: 0.1),
            child: ListTile(
              leading: const Icon(Icons.mark_email_unread_outlined),
              title: const Text('Verify your email'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(
                AppConstants.routes.verifyEmail,
                arguments: {'email': user.email},
              ),
            ),
          ),
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                ? NetworkImage(user.avatar!)
                : null,
            child: user.avatar == null || user.avatar!.isEmpty
                ? const Icon(Icons.person, size: 48)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        if (user.email != null)
          Text(
            user.email!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(AppColors.textSecondary)),
          ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            if (user.isEmailVerified == true)
              const Chip(
                label: Text('Email verified'),
                avatar: Icon(Icons.verified, size: 16),
              ),
            if (user.twoFactorEnabled == true)
              const Chip(label: Text('2FA enabled')),
          ],
        ),
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(user.bio!),
        ],
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Edit profile'),
          onTap: () => Get.toNamed(AppConstants.routes.editProfile),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () => Get.toNamed(AppConstants.routes.settings),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Color(AppColors.error)),
          title: const Text('Sign out'),
          onTap: authState.signOut,
        ),
      ],
    );
  }
}
