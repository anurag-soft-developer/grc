import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/constants.dart';

class PublicEventListTile extends StatelessWidget {
  final RunEventModel event;

  const PublicEventListTile({super.key, required this.event});

  static const _coverWidth = 104.0;

  String? get _coverImageUrl {
    for (final url in event.coverImages) {
      if (url.isNotEmpty) return url;
    }
    return null;
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      return DateTime.parse(iso).toLocal().toString().split(' ').first;
    } catch (_) {
      return iso.length >= 10 ? iso.substring(0, 10) : iso;
    }
  }

  String get _locationLabel {
    final loc = event.location;
    if (loc == null) {
      return event.cityLabel.isNotEmpty ? event.cityLabel : '—';
    }
    if (loc.city.isNotEmpty && loc.state.isNotEmpty) {
      return '${loc.city}, ${loc.state}';
    }
    if (loc.city.isNotEmpty) return loc.city;
    if (loc.state.isNotEmpty) return loc.state;
    return '—';
  }

  String get _priceLabel {
    if (event.price == null) return '—';
    if (event.price == 0) return 'Free';
    return '₹${event.price!.toStringAsFixed(0)}';
  }

  String? get _capacityLabel {
    final max = event.maxParticipants;
    if (max == null) return null;
    final registered = event.registeredCount;
    if (registered != null) return '$registered / $max spots';
    return 'Up to $max spots';
  }

  Widget _coverImage() {
    final url = _coverImageUrl;

    if (url != null) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _coverPlaceholder(),
      );
    }
    return _coverPlaceholder();
  }

  Widget _coverPlaceholder() {
    return ColoredBox(
      color: const Color(AppColors.divider),
      child: Center(
        child: Icon(
          Icons.event_outlined,
          size: _coverWidth * 0.35,
          color: const Color(AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _metaLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(AppColors.textSecondary)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registrationBadge() {
    final String label;
    final Color color;
    if (event.isClosed) {
      label = 'CLOSED';
      color = const Color(AppColors.textSecondary);
    } else if (event.registrationsPaused) {
      label = 'PAUSED';
      color = const Color(AppColors.primary);
    } else if (event.isOpenForRegistration) {
      label = 'OPEN';
      color = const Color(AppColors.success);
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _content({
    required String? reportingTime,
    required String? capacityLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_coverWidth + 12, 12, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.text),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _registrationBadge(),
            ],
          ),
          const SizedBox(height: 8),
          _metaLine(
            Icons.calendar_today_outlined,
            _formatDate(event.eventDate),
          ),
          if (reportingTime != null && reportingTime.isNotEmpty)
            _metaLine(Icons.access_time_outlined, reportingTime),
          _metaLine(Icons.location_on_outlined, _locationLabel),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _priceLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(AppColors.primary),
                ),
              ),
              if (capacityLabel != null) ...[
                const SizedBox(width: 12),
                const Icon(
                  Icons.groups_outlined,
                  size: 14,
                  color: Color(AppColors.textSecondary),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    capacityLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppColors.textSecondary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportingTime = event.reportingTime?.trim();
    final capacityLabel = _capacityLabel;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            Get.toNamed(AppConstants.routes.eventDetail, arguments: event),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: _coverWidth,
              child: _coverImage(),
            ),
            _content(
              reportingTime: reportingTime,
              capacityLabel: capacityLabel,
            ),
          ],
        ),
      ),
    );
  }
}
