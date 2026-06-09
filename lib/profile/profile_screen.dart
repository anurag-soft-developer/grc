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
import 'package:grc/components/shared/loading_overlay.dart';

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
      if (data == null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authState.setUser(data);
      });
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

    return Obx(
      () => LoadingOverlay(
        isLoading: authState.isSigningOut.value,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (user.isEmailVerified != true) ...[
              _VerifyEmailBanner(email: user.email),
              const SizedBox(height: 20),
            ],
            _ProfileHeaderCard(user: user),
            const SizedBox(height: 20),
            Obx(() {
              if (!authState.isAdmin) return const SizedBox.shrink();
              final adminMode = authState.isAdminMode;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ProfileSectionCard(
                    children: [
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        secondary: _ColorfulIcon(
                          icon: adminMode
                              ? Icons.admin_panel_settings_rounded
                              : Icons.person_rounded,
                          color: const Color(0xFF7C3AED),
                        ),
                        title: Text(adminMode ? 'Admin mode' : 'User mode'),
                        subtitle: Text(
                          adminMode
                              ? 'Switch to user mode'
                              : 'Switch to admin mode',
                          style: const TextStyle(
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        value: adminMode,
                        onChanged: authState.isSigningOut.value
                            ? null
                            : (_) => authState.setAppMode(
                                adminMode ? AppMode.user : AppMode.admin,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
            _ProfileSectionCard(
              children: [
                _ProfileActionTile(
                  icon: Icons.edit_rounded,
                  color: const Color(AppColors.primary),
                  title: 'Edit profile',
                  onTap: authState.isSigningOut.value
                      ? null
                      : () => Get.toNamed(AppConstants.routes.editProfile),
                ),
                const _ProfileTileDivider(),
                _ProfileActionTile(
                  icon: Icons.settings_rounded,
                  color: const Color(AppColors.secondary),
                  title: 'Settings',
                  onTap: authState.isSigningOut.value
                      ? null
                      : () => Get.toNamed(AppConstants.routes.settings),
                ),
                const _ProfileTileDivider(),
                _ProfileActionTile(
                  icon: Icons.logout_rounded,
                  color: const Color(AppColors.error),
                  title: authState.isSigningOut.value
                      ? 'Signing out...'
                      : 'Sign out',
                  titleColor: const Color(AppColors.error),
                  onTap: authState.isSigningOut.value ? null : authState.signOut,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final UserModel user;

  const _ProfileHeaderCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = user.avatar != null && user.avatar!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(AppColors.primary).withValues(alpha: 0.7),
                  const Color(AppColors.secondary).withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: const Color(AppColors.surface),
              backgroundImage: hasAvatar ? NetworkImage(user.avatar!) : null,
              child: hasAvatar
                  ? null
                  : Icon(
                      Icons.person_rounded,
                      size: 44,
                      color: const Color(AppColors.primary).withValues(
                        alpha: 0.6,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(AppColors.text),
              letterSpacing: -0.3,
            ),
          ),
          if (user.email != null) ...[
            const SizedBox(height: 8),
            _EmailRow(
              email: user.email!,
              isVerified: user.isEmailVerified == true,
            ),
          ],
          if (user.twoFactorEnabled == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(AppColors.success).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_rounded,
                    size: 16,
                    color: Color(AppColors.success),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '2FA enabled',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(AppColors.background),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(AppColors.textSecondary),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmailRow extends StatelessWidget {
  final String email;
  final bool isVerified;

  const _EmailRow({required this.email, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isVerified) ...[
          const Icon(
            Icons.verified_rounded,
            size: 18,
            color: Color(AppColors.primary),
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(AppColors.textSecondary),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _VerifyEmailBanner extends StatelessWidget {
  final String? email;

  const _VerifyEmailBanner({required this.email});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF7ED),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppConstants.routes.verifyEmail,
          arguments: {'email': email},
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFDBA74).withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              _ColorfulIcon(
                icon: Icons.mark_email_unread_rounded,
                color: const Color(0xFFF97316),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your email',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(AppColors.text),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tap to complete verification',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFF97316),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileSectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(AppColors.divider)),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.color,
    required this.title,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _ColorfulIcon(icon: icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor ?? const Color(AppColors.text),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: const Color(AppColors.textSecondary).withValues(alpha: 0.6),
      ),
      onTap: onTap,
    );
  }
}

class _ColorfulIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ColorfulIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _ProfileTileDivider extends StatelessWidget {
  const _ProfileTileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 68),
      child: Divider(height: 1, color: Color(AppColors.divider)),
    );
  }
}
