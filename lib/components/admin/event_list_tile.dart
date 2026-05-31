import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/constants.dart';

class AdminEventListTile extends StatelessWidget {
  final RunEventModel event;

  const AdminEventListTile({super.key, required this.event});

  Color _statusColor(String? status) {
    switch (status) {
      case 'published':
        return const Color(AppColors.success);
      case 'closed':
        return const Color(AppColors.textSecondary);
      default:
        return const Color(AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = event.eventDate;
    final dateLabel = date != null && date.length >= 10
        ? date.substring(0, 10)
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () =>
            Get.toNamed(AppConstants.routes.adminEventDetail, arguments: event),
        title: Text(event.title),
        subtitle: Text('$dateLabel · ${event.cityLabel}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(event.status).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            (event.status ?? 'draft').toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _statusColor(event.status),
            ),
          ),
        ),
      ),
    );
  }
}
