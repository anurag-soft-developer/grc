import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/utils/exception_handler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Security'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change password'),
            onTap: () => Get.toNamed(AppConstants.routes.changePassword),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Two-factor authentication'),
            onTap: () => Get.toNamed(AppConstants.routes.twoFactorAuth),
          ),
          if (user?.isEmailVerified != true)
            ListTile(
              leading: const Icon(Icons.mark_email_unread_outlined),
              title: const Text('Verify email'),
              onTap: () => Get.toNamed(
                AppConstants.routes.verifyEmail,
                arguments: {'email': user?.email},
              ),
            ),
          const _SectionHeader('Account'),
          if (user?.email != null)
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(user!.email!),
              subtitle: const Text('Email (read-only)'),
            ),
          const _SectionHeader('Legal'),
          ListTile(
            title: const Text('Terms of service'),
            onTap: () => ExceptionHandler.showInfoToast('Coming soon'),
          ),
          ListTile(
            title: const Text('Privacy policy'),
            onTap: () => ExceptionHandler.showInfoToast('Coming soon'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(AppColors.error)),
            title: const Text('Sign out'),
            onTap: authState.signOut,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textSecondary),
        ),
      ),
    );
  }
}
