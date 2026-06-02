import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/exception_handler.dart';

class AdminEventActions extends HookWidget {
  static const _buttonHeight = 40.0;
  static const _rowSpacing = 8.0;
  static const _iconSize = 16.0;
  static const _fontSize = 12.0;

  static double _rowButtonWidth(double maxWidth, int count) {
    if (count == 0) return 0;
    final gaps = (count - 1) * _rowSpacing;
    return (maxWidth - gaps) / count;
  }

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
    final client = useQueryClient();
    final status = event.status?.toLowerCase();
    final canPublish = status == null || status == 'draft';
    final canPause = event.isOpenForRegistration;
    final canResume =
        status == 'published' && !event.isClosed && event.registrationsPaused;
    final canClose = status == 'published' && !event.isClosed;
    final canArchive = !event.archive;
    final canDelete = event.registeredCount == 0;

    if (!canPublish &&
        !canPause &&
        !canResume &&
        !canClose &&
        !canArchive &&
        !canDelete) {
      return const SizedBox.shrink();
    }

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

    Widget actionButton({
      required double width,
      required String text,
      required VoidCallback? onPressed,
      required bool isLoading,
      bool isOutlined = false,
      Widget? icon,
    }) {
      return SizedBox(
        width: width,
        child: CustomButton(
          text: text,
          icon: icon,
          height: _buttonHeight,
          fontSize: _fontSize,
          isOutlined: isOutlined,
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      );
    }

    final actionBuilders = <Widget Function(double width)>[
      if (canPublish)
        (width) => actionButton(
          width: width,
          text: 'Publish',
          icon: const Icon(Icons.publish_outlined, size: _iconSize),
          isLoading: publishMutation.isPending,
          onPressed: isBusy ? null : confirmPublish,
        ),
      if (canPause)
        (width) => actionButton(
          width: width,
          text: 'Pause',
          isOutlined: true,
          icon: const Icon(Icons.pause_circle_outline, size: _iconSize),
          isLoading: pauseMutation.isPending,
          onPressed: isBusy ? null : confirmPause,
        ),
      if (canResume)
        (width) => actionButton(
          width: width,
          text: 'Resume',
          icon: const Icon(Icons.play_circle_outline, size: _iconSize),
          isLoading: resumeMutation.isPending,
          onPressed: isBusy ? null : confirmResume,
        ),
      if (canClose)
        (width) => actionButton(
          width: width,
          text: 'Close',
          isOutlined: true,
          icon: const Icon(Icons.lock_outline, size: _iconSize),
          isLoading: closeMutation.isPending,
          onPressed: isBusy ? null : confirmClose,
        ),
      if (canArchive)
        (width) => actionButton(
          width: width,
          text: 'Archive',
          isOutlined: true,
          icon: const Icon(Icons.archive_outlined, size: _iconSize),
          isLoading: archiveMutation.isPending,
          onPressed: isBusy ? null : confirmArchive,
        ),
      if (canDelete)
        (width) => actionButton(
          width: width,
          text: 'Delete',
          isOutlined: true,
          icon: Icon(
            Icons.delete_forever_outlined,
            size: _iconSize,
            color: Theme.of(context).colorScheme.error,
          ),
          isLoading: deleteMutation.isPending,
          onPressed: isBusy ? null : confirmDelete,
        ),
    ];

    final firstRowCount = (actionBuilders.length / 2).ceil();
    final firstRowBuilders = actionBuilders.sublist(0, firstRowCount);
    final secondRowBuilders = actionBuilders.sublist(firstRowCount);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final firstRowWidth = _rowButtonWidth(
              maxWidth,
              firstRowBuilders.length,
            );
            final secondRowWidth = _rowButtonWidth(
              maxWidth,
              secondRowBuilders.length,
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ActionButtonRow(
                  buttonWidth: firstRowWidth,
                  builders: firstRowBuilders,
                ),
                if (secondRowBuilders.isNotEmpty) ...[
                  const SizedBox(height: _rowSpacing),
                  _ActionButtonRow(
                    buttonWidth: secondRowWidth,
                    builders: secondRowBuilders,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActionButtonRow extends StatelessWidget {
  final double buttonWidth;
  final List<Widget Function(double width)> builders;

  const _ActionButtonRow({required this.buttonWidth, required this.builders});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < builders.length; i++) ...[
          if (i > 0) const SizedBox(width: AdminEventActions._rowSpacing),
          builders[i](buttonWidth),
        ],
      ],
    );
  }
}
