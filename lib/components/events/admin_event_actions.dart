import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/exception_handler.dart';

enum _MenuItemType { action, navigation }

class _AdminActionItem {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color iconColor;
  final _MenuItemType type;
  final bool isDestructive;
  final String? subtitle;

  const _AdminActionItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
    required this.type,
    this.isLoading = false,
    this.isDestructive = false,
    this.subtitle,
  });
}

class AdminEventActions extends HookWidget {
  static const _menuMaxWidth = 300.0;
  static const _fabMargin = 16.0;
  static const _menuGapAboveFab = 12.0;

  final RunEventModel event;
  final ValueChanged<RunEventModel> onUpdated;
  final VoidCallback? onDeleted;

  const AdminEventActions({
    super.key,
    required this.event,
    required this.onUpdated,
    this.onDeleted,
  });

  static Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  RunEventModel _mergeUpdate(RunEventModel result) {
    if (result.registeredCount != null) return result;
    return result.copyWith(registeredCount: event.registeredCount);
  }

  @override
  Widget build(BuildContext context) {
    final isMenuOpen = useState(false);
    final client = useQueryClient();
    final status = event.status?.toLowerCase();
    final canPublish = status == null || status == 'draft';
    final canPause = event.isOpenForRegistration;
    final canResume =
        status == 'published' && !event.isClosed && event.registrationsPaused;
    final canClose = status == 'published' && !event.isClosed;
    final canArchive = !event.archive;
    final canDelete = event.registeredCount == 0;

    void closeMenu() => isMenuOpen.value = false;
    void openMenu() => isMenuOpen.value = true;

    Future<void> invalidateCaches(String? eventId) async {
      await client.invalidateQueries(queryKey: QueryKeys.adminEvents);
      if (eventId != null) {
        await client.invalidateQueries(queryKey: QueryKeys.adminEvent(eventId));
      }
    }

    final publishMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) async {
        final id = event.id;
        if (id == null) throw Exception('Event id missing');
        final updated = await RunEventsService.instance.publishEvent(id);
        if (updated == null) throw Exception('Failed to publish event');
        return updated;
      },
      mutationKey: QueryKeys.publishEvent,
      onSuccess: (result, _, __, ___) async {
        await invalidateCaches(result?.id);
        ExceptionHandler.showSuccessToast('Event published');
        if (result != null) onUpdated(_mergeUpdate(result));
      },
    );

    final closeMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) async {
        final id = event.id;
        if (id == null) throw Exception('Event id missing');
        final updated = await RunEventsService.instance.closeEvent(id);
        if (updated == null) throw Exception('Failed to close event');
        return updated;
      },
      mutationKey: QueryKeys.closeEvent,
      onSuccess: (result, _, __, ___) async {
        await invalidateCaches(result?.id);
        ExceptionHandler.showSuccessToast('Event closed');
        if (result != null) onUpdated(_mergeUpdate(result));
      },
    );

    final archiveMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) async {
        final id = event.id;
        if (id == null) throw Exception('Event id missing');
        final updated = await RunEventsService.instance.archiveEvent(id);
        if (updated == null) throw Exception('Failed to archive event');
        return updated;
      },
      mutationKey: QueryKeys.archiveEvent,
      onSuccess: (result, _, __, ___) async {
        await invalidateCaches(result?.id);
        ExceptionHandler.showSuccessToast('Event archived');
        if (result != null) onUpdated(_mergeUpdate(result));
      },
    );

    final pauseMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) async {
        final id = event.id;
        if (id == null) throw Exception('Event id missing');
        final updated = await RunEventsService.instance.pauseRegistrations(id);
        if (updated == null) {
          throw Exception('Failed to pause registrations');
        }
        return updated;
      },
      mutationKey: QueryKeys.pauseEventRegistrations,
      onSuccess: (result, _, __, ___) async {
        await invalidateCaches(result?.id);
        ExceptionHandler.showSuccessToast('Registrations paused');
        if (result != null) onUpdated(_mergeUpdate(result));
      },
    );

    final resumeMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) async {
        final id = event.id;
        if (id == null) throw Exception('Event id missing');
        final updated = await RunEventsService.instance.resumeRegistrations(id);
        if (updated == null) {
          throw Exception('Failed to resume registrations');
        }
        return updated;
      },
      mutationKey: QueryKeys.resumeEventRegistrations,
      onSuccess: (result, _, __, ___) async {
        await invalidateCaches(result?.id);
        ExceptionHandler.showSuccessToast('Registrations resumed');
        if (result != null) onUpdated(_mergeUpdate(result));
      },
    );

    final deleteMutation = useMutation<bool, Object, void, void>(
      (_, __) async {
        final id = event.id;
        if (id == null) throw Exception('Event id missing');
        final ok = await RunEventsService.instance.deleteEvent(id);
        if (!ok) throw Exception('Failed to delete event');
        return ok;
      },
      mutationKey: QueryKeys.deleteEvent,
      onSuccess: (_, __, ___, ____) async {
        await invalidateCaches(event.id);
        ExceptionHandler.showSuccessToast('Event deleted');
        onDeleted?.call();
      },
    );

    final isBusy =
        publishMutation.isPending ||
        closeMutation.isPending ||
        archiveMutation.isPending ||
        pauseMutation.isPending ||
        resumeMutation.isPending ||
        deleteMutation.isPending;

    Future<void> confirmPublish() async {
      final ok = await _confirm(
        context,
        title: 'Publish event?',
        content:
            'This event will be visible to users and open for registration.',
        confirmLabel: 'Publish',
      );
      if (ok && context.mounted) publishMutation.mutate(null);
    }

    Future<void> confirmPause() async {
      final ok = await _confirm(
        context,
        title: 'Pause registrations?',
        content:
            'Users will not be able to register until you resume registrations.',
        confirmLabel: 'Pause',
      );
      if (ok && context.mounted) pauseMutation.mutate(null);
    }

    Future<void> confirmResume() async {
      final ok = await _confirm(
        context,
        title: 'Resume registrations?',
        content: 'Users will be able to register for this event again.',
        confirmLabel: 'Resume',
      );
      if (ok && context.mounted) resumeMutation.mutate(null);
    }

    Future<void> confirmClose() async {
      final ok = await _confirm(
        context,
        title: 'Close event?',
        content:
            'Registrations will stop. You can still view this event in your list.',
        confirmLabel: 'Close',
      );
      if (ok && context.mounted) closeMutation.mutate(null);
    }

    Future<void> confirmArchive() async {
      final ok = await _confirm(
        context,
        title: 'Archive event?',
        content:
            'This event will be hidden from the public events list. You can still manage it in admin.',
        confirmLabel: 'Archive',
      );
      if (ok && context.mounted) archiveMutation.mutate(null);
    }

    Future<void> confirmDelete() async {
      final ok = await _confirm(
        context,
        title: 'Delete event permanently?',
        content:
            'This cannot be undone. The event will be removed from your list.',
        confirmLabel: 'Delete',
      );
      if (ok && context.mounted) deleteMutation.mutate(null);
    }

    void openParticipants() {
      closeMenu();
      Get.toNamed(
        AppConstants.routes.adminEventParticipants,
        arguments: event,
      );
    }

    void openAnalytics() {
      closeMenu();
      Get.toNamed(AppConstants.routes.adminEventAnalytics, arguments: event);
    }

    const publishColor = Color(AppColors.success);
    const pauseColor = Color(0xFFF59E0B);
    const resumeColor = Color(0xFF06B6D4);
    const closeColor = Color(AppColors.textSecondary);
    const archiveColor = Color(0xFF8B5CF6);
    const deleteColor = Color(AppColors.error);
    const participantsColor = Color(AppColors.primary);
    const analyticsColor = Color(AppColors.secondary);

    final lifecycleActions = <_AdminActionItem>[
      if (canPublish)
        _AdminActionItem(
          label: 'Publish',
          icon: Icons.publish_outlined,
          iconColor: publishColor,
          type: _MenuItemType.action,
          isLoading: publishMutation.isPending,
          onPressed: isBusy ? null : confirmPublish,
        ),
      if (canPause)
        _AdminActionItem(
          label: 'Pause registrations',
          icon: Icons.pause_circle_outline,
          iconColor: pauseColor,
          type: _MenuItemType.action,
          isLoading: pauseMutation.isPending,
          onPressed: isBusy ? null : confirmPause,
        ),
      if (canResume)
        _AdminActionItem(
          label: 'Resume registrations',
          icon: Icons.play_circle_outline,
          iconColor: resumeColor,
          type: _MenuItemType.action,
          isLoading: resumeMutation.isPending,
          onPressed: isBusy ? null : confirmResume,
        ),
      if (canClose)
        _AdminActionItem(
          label: 'Close event',
          icon: Icons.lock_outline,
          iconColor: closeColor,
          type: _MenuItemType.action,
          isLoading: closeMutation.isPending,
          onPressed: isBusy ? null : confirmClose,
        ),
      if (canArchive)
        _AdminActionItem(
          label: 'Archive',
          icon: Icons.archive_outlined,
          iconColor: archiveColor,
          type: _MenuItemType.action,
          isLoading: archiveMutation.isPending,
          onPressed: isBusy ? null : confirmArchive,
        ),
      if (canDelete)
        _AdminActionItem(
          label: 'Delete',
          icon: Icons.delete_forever_outlined,
          iconColor: deleteColor,
          type: _MenuItemType.action,
          isDestructive: true,
          isLoading: deleteMutation.isPending,
          onPressed: isBusy ? null : confirmDelete,
        ),
    ];

    final registered = event.registeredCount;
    final participantsSubtitle = registered != null
        ? '$registered submitted registration${registered == 1 ? '' : 's'}'
        : 'View submitted registrations';

    final navigationActions = <_AdminActionItem>[
      _AdminActionItem(
        label: 'Participants',
        subtitle: participantsSubtitle,
        icon: Icons.people_outline,
        iconColor: participantsColor,
        type: _MenuItemType.navigation,
        onPressed: isBusy ? null : openParticipants,
      ),
      _AdminActionItem(
        label: 'Analytics',
        subtitle: 'Capacity, payments & revenue',
        icon: Icons.analytics_outlined,
        iconColor: analyticsColor,
        type: _MenuItemType.navigation,
        onPressed: isBusy ? null : openAnalytics,
      ),
    ];

    final fabBottom = _fabMargin + MediaQuery.paddingOf(context).bottom;
    const fabSize = 56.0;
    final menuBottom = fabBottom + fabSize + _menuGapAboveFab;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isMenuOpen.value)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: closeMenu,
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ),
        if (isMenuOpen.value)
          Positioned(
            right: _fabMargin,
            bottom: menuBottom,
            child: _ActionsMenuPanel(
              lifecycleActions: lifecycleActions,
              navigationActions: navigationActions,
              onClose: closeMenu,
            ),
          ),
        Positioned(
          right: _fabMargin,
          bottom: fabBottom,
          child: FloatingActionButton(
            elevation: 4,
            highlightElevation: 6,
            backgroundColor: const Color(AppColors.primary),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: isMenuOpen.value ? closeMenu : openMenu,
            tooltip: isMenuOpen.value ? 'Close menu' : 'Open menu',
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isMenuOpen.value ? Icons.close_rounded : Icons.tune_rounded,
                key: ValueKey(isMenuOpen.value),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionsMenuPanel extends StatelessWidget {
  final List<_AdminActionItem> lifecycleActions;
  final List<_AdminActionItem> navigationActions;
  final VoidCallback onClose;

  const _ActionsMenuPanel({
    required this.lifecycleActions,
    required this.navigationActions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: AdminEventActions._menuMaxWidth),
        decoration: BoxDecoration(
          color: const Color(AppColors.surface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(AppColors.divider)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(AppColors.divider)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.primary).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: Color(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: Color(AppColors.text),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      tooltip: 'Close',
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(AppColors.background),
                        foregroundColor: const Color(AppColors.textSecondary),
                      ),
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (lifecycleActions.isNotEmpty) ...[
                      const _MenuSectionLabel(title: 'Actions'),
                      const SizedBox(height: 8),
                      for (var i = 0; i < lifecycleActions.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        _ActionMenuTile(item: lifecycleActions[i]),
                      ],
                    ],
                    if (lifecycleActions.isNotEmpty &&
                        navigationActions.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          height: 1,
                          color: Color(AppColors.divider),
                        ),
                      ),
                    ],
                    if (navigationActions.isNotEmpty) ...[
                      const _MenuSectionLabel(title: 'Navigate'),
                      const SizedBox(height: 8),
                      for (var i = 0; i < navigationActions.length; i++) ...[
                        if (i > 0) const SizedBox(height: 6),
                        _NavigationMenuTile(item: navigationActions[i]),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuSectionLabel extends StatelessWidget {
  final String title;

  const _MenuSectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Color(AppColors.textSecondary),
      ),
    );
  }
}

class _ActionMenuTile extends StatelessWidget {
  final _AdminActionItem item;

  const _ActionMenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final borderColor = item.isDestructive
        ? item.iconColor.withValues(alpha: 0.45)
        : item.iconColor.withValues(alpha: 0.35);
    final bgColor = item.isDestructive
        ? item.iconColor.withValues(alpha: 0.06)
        : item.iconColor.withValues(alpha: 0.08);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.isLoading ? null : item.onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(item.icon, size: 20, color: item.iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: item.isDestructive
                          ? item.iconColor
                          : const Color(AppColors.text),
                    ),
                  ),
                ),
                if (item.isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: item.iconColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationMenuTile extends StatelessWidget {
  final _AdminActionItem item;

  const _NavigationMenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 22, color: item.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(AppColors.text),
                      ),
                    ),
                    if (item.subtitle != null && item.subtitle!.isNotEmpty)
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: item.iconColor.withValues(alpha: 0.85),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: item.iconColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
