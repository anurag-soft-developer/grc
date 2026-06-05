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

  String? get _coverImageUrl {
    for (final url in event.coverImages) {
      if (url.isNotEmpty) return url;
    }
    return null;
  }

  Widget _coverThumbnail() {
    const size = 56.0;
    final url = _coverImageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url != null
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _coverPlaceholder(size),
            )
          : _coverPlaceholder(size),
    );
  }

  Widget _coverPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      color: const Color(AppColors.divider),
      child: const Icon(
        Icons.event_outlined,
        color: Color(AppColors.textSecondary),
      ),
    );
  }

  String get _priceLabel {
    if (event.price == null) return '—';
    if (event.price == 0) return 'Free';
    return '₹${event.price!.toStringAsFixed(0)}';
  }

  String get _registrationsLabel {
    final count = event.registeredCount ?? 0;
    return count == 1 ? '1 registration' : '$count registrations';
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: _coverThumbnail(),
        onTap: () =>
            Get.toNamed(AppConstants.routes.adminEventDetail, arguments: event),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$dateLabel · ${event.cityLabel}'),
            const SizedBox(height: 4),
            Text(
              '$_priceLabel · $_registrationsLabel',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(AppColors.primary),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(
              event.displayStatusLabel,
            ).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            event.displayStatusLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _statusColor(event.displayStatusLabel),
            ),
          ),
        ),
      ),
    );
  }
}
