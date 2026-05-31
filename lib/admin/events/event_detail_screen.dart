import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/admin/form/event_form_binding.dart';
import 'package:grc/admin/form/event_form_screen.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/exception_handler.dart';

class EventDetailScreen extends HookWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final event = useState<RunEventModel?>(Get.arguments as RunEventModel?);

    Future<void> openEdit() async {
      final current = event.value;
      if (current == null) return;

      final updated = await Get.to<RunEventModel>(
        () => const EventFormScreen(),
        binding: EventFormBinding(),
        arguments: current,
      );
      if (updated != null) {
        event.value = updated;
      }
    }

    final data = event.value;

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          if (data != null && authState.isAdminMode)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit event',
              onPressed: openEdit,
            ),
        ],
      ),
      body: data == null
          ? const Center(child: Text('Event not found'))
          : MutationLoadingOverlay(
              mutationKey: _statusMutationKey(data.status),
              child: Column(
                children: [
                  Expanded(child: _EventDetailBody(event: data)),
                  if (authState.isAdminMode)
                    _AdminStatusActions(
                      event: data,
                      onUpdated: (updated) => event.value = updated,
                    ),
                ],
              ),
            ),
    );
  }

  static List<String> _statusMutationKey(String? status) {
    final normalized = status?.toLowerCase();
    if (normalized == 'published') return QueryKeys.closeEvent;
    return QueryKeys.publishEvent;
  }
}

class _EventDetailBody extends StatelessWidget {
  final RunEventModel event;

  const _EventDetailBody({required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.coverImages.isNotEmpty) ...[
            LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = constraints.maxWidth;
                return SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: event.coverImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final url = event.coverImages[index];
                      if (url.isEmpty) return const SizedBox.shrink();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          width: imageWidth,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: imageWidth,
                            height: 200,
                            color: const Color(AppColors.divider),
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _StatusChip(status: event.status),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            event.description,
            style: const TextStyle(
              color: Color(AppColors.textSecondary),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Event date',
            value: _formatDate(event.eventDate),
          ),
          _DetailRow(
            icon: Icons.access_time_outlined,
            label: 'Reporting time',
            value: event.reportingTime ?? '—',
          ),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: _locationLabel(event),
          ),
          _DetailRow(
            icon: Icons.payments_outlined,
            label: 'Price',
            value: event.price != null
                ? '₹${event.price!.toStringAsFixed(0)}'
                : '—',
          ),
          _DetailRow(
            icon: Icons.groups_outlined,
            label: 'Max participants',
            value: event.maxParticipants?.toString() ?? '—',
          ),
        ],
      ),
    );
  }

  static String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      return DateTime.parse(iso).toLocal().toString().split(' ').first;
    } catch (_) {
      return iso.length >= 10 ? iso.substring(0, 10) : iso;
    }
  }

  static String _locationLabel(RunEventModel event) {
    final loc = event.location;
    if (loc == null) return '—';
    final parts = [
      loc.address,
      if (loc.city.isNotEmpty || loc.state.isNotEmpty)
        '${loc.city}${loc.state.isNotEmpty ? ', ${loc.state}' : ''}',
    ].where((p) => p.trim().isNotEmpty);
    return parts.join('\n');
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = (status ?? 'draft').toUpperCase();
    Color color;
    switch (status) {
      case 'published':
        color = const Color(AppColors.success);
      case 'closed':
        color = const Color(AppColors.textSecondary);
      default:
        color = const Color(AppColors.primary);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(AppColors.textSecondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminStatusActions extends HookWidget {
  final RunEventModel event;
  final ValueChanged<RunEventModel> onUpdated;

  const _AdminStatusActions({
    required this.event,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final client = useQueryClient();
    final status = event.status?.toLowerCase();
    final canPublish = status == null || status == 'draft';
    final canClose = status == 'published';

    if (!canPublish && !canClose) {
      return const SizedBox.shrink();
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
        await client.invalidateQueries(queryKey: QueryKeys.adminEvents);
        if (result?.id != null) {
          await client.invalidateQueries(
            queryKey: QueryKeys.adminEvent(result!.id!),
          );
        }
        ExceptionHandler.showSuccessToast('Event published');
        if (result != null) onUpdated(result);
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
        await client.invalidateQueries(queryKey: QueryKeys.adminEvents);
        if (result?.id != null) {
          await client.invalidateQueries(
            queryKey: QueryKeys.adminEvent(result!.id!),
          );
        }
        ExceptionHandler.showSuccessToast('Event closed');
        if (result != null) onUpdated(result);
      },
    );

    Future<void> confirmClose() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Close event?'),
          content: const Text(
            'Registrations will stop. You can still view this event in your list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Close event'),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        closeMutation.mutate(null);
      }
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (canPublish)
              CustomButton(
                text: 'Publish event',
                icon: const Icon(Icons.publish_outlined, size: 20),
                isLoading: publishMutation.isPending,
                onPressed: publishMutation.isPending
                    ? null
                    : () => publishMutation.mutate(null),
              ),
            if (canPublish && canClose) const SizedBox(height: 12),
            if (canClose)
              CustomButton(
                text: 'Close event',
                isOutlined: true,
                icon: const Icon(Icons.lock_outline, size: 20),
                isLoading: closeMutation.isPending,
                onPressed: closeMutation.isPending ? null : confirmClose,
              ),
          ],
        ),
      ),
    );
  }
}
