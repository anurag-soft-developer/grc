import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/utils/date_format_util.dart';

class CompactEventSection extends StatelessWidget {
  final RunEventModel event;

  const CompactEventSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final title = event.title;
    final dateLabel = formatEventDate(event.eventDate);
    final reportingTime = event.reportingTime?.trim();
    final location = event.location;
    final city = location?.city.isNotEmpty == true
        ? location!.city
        : event.cityLabel;

    String? coverUrl;
    for (final url in event.coverImages) {
      if (url.isNotEmpty) {
        coverUrl = url;
        break;
      }
    }

    return Material(
      color: const Color(AppColors.surface),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          final id = event.id;
          if (id == null) return;
          Get.toNamed(AppConstants.routes.eventDetailPath(id));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(AppColors.divider)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EventCoverThumb(url: coverUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(AppColors.textSecondary),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(AppColors.text),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _EventMetaRow(
                        icon: Icons.calendar_today_outlined,
                        text: dateLabel,
                      ),
                      if (reportingTime != null && reportingTime.isNotEmpty)
                        _EventMetaRow(
                          icon: Icons.access_time_outlined,
                          text: reportingTime,
                        ),
                      if (city.isNotEmpty)
                        _EventMetaRow(
                          icon: Icons.location_on_outlined,
                          text: city,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'View event details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(
                            AppColors.primary,
                          ).withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Color(AppColors.textSecondary),
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

class _EventCoverThumb extends StatelessWidget {
  final String? url;

  const _EventCoverThumb({this.url});

  @override
  Widget build(BuildContext context) {
    const size = 72.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: url != null
          ? Image.network(
              url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(size),
            )
          : _placeholder(size),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      color: const Color(AppColors.divider),
      child: const Icon(
        Icons.directions_run_outlined,
        color: Color(AppColors.textSecondary),
      ),
    );
  }
}

class _EventMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventMetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, size: 13, color: const Color(AppColors.textSecondary)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
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
}
