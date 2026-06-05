import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_analytics_model.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/admin/stat_card.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/query/query_keys.dart';

class EventAnalyticsScreen extends HookWidget {
  const EventAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = Get.arguments as RunEventModel?;
    final eventId = event?.id;
    final eventTitle = event?.title ?? 'Event';

    final analyticsQuery = useQuery<RunEventAnalyticsModel?, Object>(
      QueryKeys.eventAnalytics(eventId ?? ''),
      (_) async {
        final id = eventId;
        if (id == null || id.isEmpty) return null;
        return RunEventsService.instance.getEventAnalytics(id);
      },
      enabled: eventId != null && eventId.isNotEmpty,
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: Text('Analytics · $eventTitle')),
      body: eventId == null
          ? const Center(child: Text('Event not found'))
          : QueryAsyncBody<RunEventAnalyticsModel?, dynamic>(
              state: analyticsQuery,
              onRetry: analyticsQuery.refetch,
              data: (data) {
                if (data == null) {
                  return const Center(child: Text('Analytics not available'));
                }
                return _AnalyticsBody(analytics: data);
              },
            ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  final RunEventAnalyticsModel analytics;

  const _AnalyticsBody({required this.analytics});

  String _formatCapacity() {
    final max = analytics.maxParticipants;
    if (max == null) return '${analytics.registeredCount} registered';
    return '${analytics.registeredCount} / $max';
  }

  String _formatRevenue() {
    final symbol = analytics.currency == 'INR' ? '₹' : '${analytics.currency} ';
    return '$symbol${analytics.revenue.totalCollected.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final capacityLabel = analytics.capacityPercent != null
        ? '${analytics.capacityPercent}%'
        : '—';

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          analytics.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Capacity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            AdminStatCard(
              label: 'Registered',
              value: _formatCapacity(),
              icon: Icons.groups_outlined,
            ),
            AdminStatCard(
              label: 'Capacity used',
              value: capacityLabel,
              icon: Icons.pie_chart_outline,
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'By status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            AdminStatCard(
              label: 'Submitted',
              value: '${analytics.byStatus.submitted}',
              icon: Icons.check_circle_outline,
            ),
            AdminStatCard(
              label: 'Pending payment',
              value: '${analytics.byStatus.pendingPayment}',
              icon: Icons.hourglass_empty_outlined,
            ),
            AdminStatCard(
              label: 'Draft',
              value: '${analytics.byStatus.draft}',
              icon: Icons.edit_note_outlined,
            ),
            AdminStatCard(
              label: 'Cancelled',
              value: '${analytics.byStatus.cancelled}',
              icon: Icons.cancel_outlined,
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Payments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            AdminStatCard(
              label: 'Paid',
              value: '${analytics.byPaymentStatus.paid}',
              icon: Icons.payments_outlined,
            ),
            AdminStatCard(
              label: 'Pending',
              value: '${analytics.byPaymentStatus.pending}',
              icon: Icons.schedule_outlined,
            ),
            AdminStatCard(
              label: 'Failed',
              value: '${analytics.byPaymentStatus.failed}',
              icon: Icons.error_outline,
            ),
            AdminStatCard(
              label: 'Refunded',
              value: '${analytics.byPaymentStatus.refunded}',
              icon: Icons.replay_outlined,
            ),
            AdminStatCard(
              label: 'Total revenue',
              value: _formatRevenue(),
              icon: Icons.account_balance_wallet_outlined,
            ),
            AdminStatCard(
              label: 'Paid registrations',
              value: '${analytics.revenue.paidRegistrations}',
              icon: Icons.receipt_long_outlined,
            ),
          ],
        ),
      ],
    );
  }
}
