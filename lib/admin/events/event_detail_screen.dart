import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/admin/form/event_form_binding.dart';
import 'package:grc/admin/form/event_form_screen.dart';
import 'package:grc/components/events/admin_event_actions.dart';
import 'package:grc/components/events/user_event_actions.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';

class EventDetailScreen extends HookWidget {
  const EventDetailScreen({super.key});

  static const _adminMutationKeys = [
    QueryKeys.publishEvent,
    QueryKeys.closeEvent,
    QueryKeys.archiveEvent,
    QueryKeys.pauseEventRegistrations,
    QueryKeys.resumeEventRegistrations,
    QueryKeys.deleteEvent,
  ];

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthStateController>();
    final event = useState<RunEventModel?>(Get.arguments as RunEventModel?);
    final isAdminMode = authState.isAdminMode;
    final eventId = event.value?.id;

    final adminDetailQuery = useQuery<RunEventModel?, Object>(
      QueryKeys.adminEvent(eventId ?? ''),
      (_) async {
        final id = eventId;
        if (id == null) return null;
        return RunEventsService.instance.getEventById(id);
      },
      enabled: isAdminMode && eventId != null,
    );

    useEffect(() {
      final fresh = adminDetailQuery.data;
      if (fresh != null) {
        event.value = fresh;
      }
      return null;
    }, [adminDetailQuery.data]);

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

    Widget body;
    if (data == null) {
      body = const Center(child: Text('Event not found'));
    } else {
      body = _buildDetailBody(
        data,
        isAdminMode,
        (updated) => event.value = updated,
        onDeleted: () => Get.back(),
      );
    }

    if (isAdminMode) {
      body = MutationLoadingOverlay(
        mutationKeys: _adminMutationKeys,
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          if (data != null && isAdminMode)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit event',
              onPressed: openEdit,
            ),
        ],
      ),
      body: body,
    );
  }

  static Widget _buildDetailBody(
    RunEventModel data,
    bool isAdminMode,
    ValueChanged<RunEventModel> onUpdated, {
    VoidCallback? onDeleted,
  }) {
    return Column(
      children: [
        Expanded(child: _EventDetailBody(event: data)),
        if (isAdminMode)
          AdminEventActions(
            event: data,
            onUpdated: onUpdated,
            onDeleted: onDeleted,
          )
        else
          UserEventActions(event: data),
      ],
    );
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
              _StatusChip(status: event.displayStatusLabel),
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
    final Color color;
    switch (status) {
      case 'published':
        color = const Color(AppColors.success);
      case 'closed':
        color = const Color(AppColors.textSecondary);
      case 'archived':
        color = const Color(AppColors.textSecondary);
      case 'paused':
        color = const Color(AppColors.secondary);
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
