import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/components/events/admin_event_actions.dart';
import 'package:grc/components/events/user_event_actions.dart';
import 'package:grc/components/shared/loading_overlay.dart';
import 'package:grc/registrations/event_registration_binding.dart';
import 'package:grc/registrations/event_registration_controller.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/utils/date_format_util.dart';
import 'package:grc/core/utils/map_launch_util.dart';
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
    final isAdminMode = authState.isAdminMode;
    final id = useMemoized(() => Get.parameters['id']);

    final detailQuery = useQuery<RunEventModel?, Object>(
      QueryKeys.adminEvent(id ?? ''),
      (_) async {
        final routeId = id;
        if (routeId == null || routeId.isEmpty) return null;
        return RunEventsService.instance.getEventById(routeId);
      },
      enabled: id != null && id.isNotEmpty,
    );

    final event = detailQuery.data;

    Future<void> openEdit() async {
      final eventId = event?.id ?? id;
      if (eventId == null || eventId.isEmpty) return;

      final result = await Get.toNamed(
        AppConstants.routes.adminEventFormEditPath(eventId),
      );
      if (result != null) {
        detailQuery.refetch();
      }
    }

    Future<void> openQuestionnaires() async {
      final eventId = event?.id ?? id;
      if (eventId == null || eventId.isEmpty) return;

      final result = await Get.toNamed(
        AppConstants.routes.adminEventQuestionnairesPath(eventId),
      );
      if (result != null) {
        detailQuery.refetch();
      }
    }

    Widget body;
    if (id == null || id.isEmpty) {
      body = const Center(child: Text('Event not found'));
    } else {
      body = QueryAsyncBody<RunEventModel?, dynamic>(
        state: detailQuery,
        onRetry: detailQuery.refetch,
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Event not found'));
          }
          return _buildDetailBody(
            data,
            isAdminMode,
            (_) => detailQuery.refetch(),
            onDeleted: () => Get.back(),
          );
        },
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
          if (event != null && isAdminMode) ...[
            IconButton(
              icon: const Icon(Icons.quiz_outlined),
              tooltip: 'Questionnaires',
              onPressed: openQuestionnaires,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit event',
              onPressed: openEdit,
            ),
          ],
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
    if (isAdminMode) {
      return Stack(
        children: [
          Positioned.fill(child: _EventDetailBody(event: data)),
          AdminEventActions(
            event: data,
            onUpdated: onUpdated,
            onDeleted: onDeleted,
          ),
        ],
      );
    }

    if (!Get.isRegistered<EventRegistrationController>()) {
      EventRegistrationBinding().dependencies();
    }
    final registrationController = Get.find<EventRegistrationController>();

    return Obx(
      () => LoadingOverlay(
        isLoading: registrationController.isLoading.value,
        child: Column(
          children: [
            Expanded(child: _EventDetailBody(event: data)),
            UserEventActions(event: data),
          ],
        ),
      ),
    );
  }
}

class _EventDetailBody extends StatelessWidget {
  final RunEventModel event;

  const _EventDetailBody({required this.event});

  @override
  Widget build(BuildContext context) {
    final canOpenLocation = canOpenEventLocationInMaps(event.location);

    return AdaptivePageContainer(
      maxWidth: 1140,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (event.coverImages.isNotEmpty) ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  final imageWidth = constraints.maxWidth;
                  return SizedBox(
                    height: 260,
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
                            height: 260,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: imageWidth,
                              height: 260,
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
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _StatusChip(status: event.displayStatusLabel),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Text(
                  event.description,
                  style: const TextStyle(
                    color: Color(AppColors.textSecondary),
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final twoCol = constraints.maxWidth >= 860;
                final tiles = [
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Event date',
                    value: formatIsoDateOnly(event.eventDate),
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
                    onTap: canOpenLocation
                        ? () => handleEventLocationTap(event.location)
                        : null,
                    showChevron: canOpenLocation,
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
                ];

                if (!twoCol) {
                  return Column(children: tiles);
                }

                final itemWidth = (constraints.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 0,
                  children: [
                    for (final tile in tiles)
                      SizedBox(width: itemWidth, child: tile),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
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
  final VoidCallback? onTap;
  final bool showChevron;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final isTappable = onTap != null;
    final valueColor = isTappable
        ? const Color(AppColors.primary)
        : const Color(AppColors.text);

    final content = Padding(
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
          if (showChevron)
            const Padding(
              padding: EdgeInsets.only(top: 18),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Color(AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );

    if (!isTappable) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(12),
        child: content,
      ),
    );
  }
}
