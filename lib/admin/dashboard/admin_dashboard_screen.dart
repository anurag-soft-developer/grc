import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/dashboard/admin_dashboard_controller.dart';
import 'package:grc/admin/dashboard/admin_dashboard_service.dart';
import 'package:grc/admin/dashboard/model/admin_dashboard_analytics_model.dart';
import 'package:grc/admin/dashboard/model/dashboard_date_range.dart';
import 'package:grc/admin/dashboard/widgets/dashboard_stat_card.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';

class AdminDashboardScreen extends HookWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();
    final preset = useState(DashboardDatePreset.thisMonth);

    final activeRange = useMemoized(
      () => preset.value.resolveRange(),
      [preset.value],
    );

    final fromKey = activeRange != null
        ? formatDashboardApiDate(activeRange.start)
        : null;
    final toKey =
        activeRange != null ? formatDashboardApiDate(activeRange.end) : null;

    final analyticsQuery = useQuery<AdminDashboardAnalyticsModel, Object>(
      QueryKeys.adminDashboardAnalytics(fromDate: fromKey, toDate: toKey),
      (_) => AdminDashboardService.instance.getAnalytics(range: activeRange),
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Dashboard')),
      body: QueryAsyncBody<AdminDashboardAnalyticsModel, dynamic>(
        state: analyticsQuery,
        onRetry: analyticsQuery.refetch,
        data: (analytics) => RefreshIndicator(
          onRefresh: () async => analyticsQuery.refetch(),
          color: const Color(AppColors.primary),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(AppColors.text),
                    ),
                  ),
                  _DateRangeSelect(
                    selected: preset.value,
                    onChanged: (value) {
                      if (value != null) preset.value = value;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.18,
                children: [
                  DashboardStatCard(
                    label: 'Total events',
                    value: '${analytics.totalEvents}',
                    icon: Icons.event_available_outlined,
                    accentColor: const Color(AppColors.primary),
                  ),
                  DashboardStatCard(
                    label: 'Registrations',
                    value: '${analytics.totalRegistrations}',
                    icon: Icons.people_alt_outlined,
                    accentColor: const Color(AppColors.secondary),
                  ),
                  DashboardStatCard(
                    label: 'Revenue',
                    value: _formatRevenue(analytics),
                    subtitle: '${analytics.revenue.paidRegistrations} paid',
                    icon: Icons.payments_outlined,
                    accentColor: const Color(AppColors.success),
                  ),
                  DashboardStatCard(
                    label: 'Paid registrations',
                    value: '${analytics.revenue.paidRegistrations}',
                    icon: Icons.receipt_long_outlined,
                    accentColor: const Color(0xFF8B5CF6),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Quick actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.text),
                ),
              ),
              const SizedBox(height: 14),
              _QuickActionTile(
                icon: Icons.calendar_month_outlined,
                title: 'Manage events',
                subtitle: 'View, edit, and publish your events',
                onTap: controller.openMyEventsTab,
              ),
              const SizedBox(height: 10),
              _QuickActionTile(
                icon: Icons.add_circle_outline,
                title: 'Create event',
                subtitle: 'Set up a new run or race',
                onTap: controller.openEventForm,
                filled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRevenue(AdminDashboardAnalyticsModel analytics) {
    final symbol = analytics.revenue.currency == 'INR'
        ? '₹'
        : '${analytics.revenue.currency} ';
    return '$symbol${analytics.revenue.totalCollected.toStringAsFixed(0)}';
  }
}

class _DateRangeSelect extends StatelessWidget {
  final DashboardDatePreset selected;
  final ValueChanged<DashboardDatePreset?> onChanged;

  const _DateRangeSelect({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(AppColors.divider)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DashboardDatePreset>(
          value: selected,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(AppColors.textSecondary),
          ),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(AppColors.text),
          ),
          borderRadius: BorderRadius.circular(10),
          items: DashboardDatePreset.values
              .map(
                (preset) => DropdownMenuItem(
                  value: preset,
                  child: Text(preset.label),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = filled
        ? const Color(AppColors.primary)
        : const Color(AppColors.text);

    return Material(
      color: filled
          ? const Color(AppColors.primary).withValues(alpha: 0.08)
          : const Color(AppColors.surface),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: filled
                  ? const Color(AppColors.primary).withValues(alpha: 0.18)
                  : const Color(AppColors.divider),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: filled
                      ? const Color(AppColors.primary).withValues(alpha: 0.14)
                      : const Color(AppColors.background),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: accent.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
