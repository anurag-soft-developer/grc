import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/config/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AdaptivePageContainer(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            const _SectionHeader('Security'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change password'),
                    onTap: () =>
                        Get.toNamed(AppConstants.routes.changePassword),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Two-factor authentication'),
                    onTap: () => Get.toNamed(AppConstants.routes.twoFactorAuth),
                  ),
                  if (user?.isEmailVerified != true) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.mark_email_unread_outlined),
                      title: const Text('Verify email'),
                      onTap: () => Get.toNamed(
                        AppConstants.routes.verifyEmailPath(email: user?.email),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const _SectionHeader('Account'),
            Card(
              child: Column(
                children: [
                  if (user?.email != null)
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(user!.email!),
                      subtitle: const Text('Email (read-only)'),
                    ),
                ],
              ),
            ),
            const _SectionHeader('Legal'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Terms of service'),
                    onTap: () =>
                        Get.toNamed(AppConstants.routes.termsOfService),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Privacy policy'),
                    onTap: () => Get.toNamed(AppConstants.routes.privacyPolicy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color(AppColors.error),
                ),
                title: const Text('Sign out'),
                onTap: authState.signOut,
              ),
            ),
          ],
        ),
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
