import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/utils/date_format_util.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';

class HomeUpcomingSlotCard extends StatelessWidget {
  final RunEventParticipantModel participant;

  const HomeUpcomingSlotCard({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final event = participant.runEventModel;
    final title = event?.title ?? 'Event';
    final dateLabel = formatEventDate(event?.eventDate);
    final reportingTime = event?.reportingTime?.trim();
    final location = event?.location;
    final city = location?.city.isNotEmpty == true
        ? location!.city
        : event?.cityLabel;
    String? coverUrl;
    for (final url in event?.coverImages ?? const <String>[]) {
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
          final id = participant.id;
          if (id == null) return;
          Get.toNamed(AppConstants.routes.registrationDetail, arguments: id);
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
                _SlotCoverImage(url: coverUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      _SlotMetaRow(
                        icon: Icons.calendar_today_outlined,
                        text: dateLabel,
                      ),
                      if (reportingTime != null && reportingTime.isNotEmpty)
                        _SlotMetaRow(
                          icon: Icons.access_time_outlined,
                          text: reportingTime,
                        ),
                      if (city != null && city.isNotEmpty)
                        _SlotMetaRow(
                          icon: Icons.location_on_outlined,
                          text: city,
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _SlotStatusChip(
                            label: _statusLabel(participant),
                            color: _statusColor(participant),
                          ),
                          if (participant.totalAmount != null)
                            _SlotStatusChip(
                              label:
                                  '₹${participant.totalAmount!.toStringAsFixed(0)}',
                              color: const Color(AppColors.textSecondary),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(RunEventParticipantModel participant) {
    if (participant.isPendingPayment) return 'Payment pending';
    if (participant.isSubmitted && participant.isPaid) return 'Confirmed';
    if (participant.isSubmitted) return 'Registered';
    return (participant.status ?? 'registered').replaceAll('_', ' ');
  }

  Color _statusColor(RunEventParticipantModel participant) {
    if (participant.isPendingPayment) return const Color(AppColors.primary);
    if (participant.isSubmitted) return const Color(AppColors.success);
    return const Color(AppColors.textSecondary);
  }
}

class _SlotCoverImage extends StatelessWidget {
  final String? url;

  const _SlotCoverImage({this.url});

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

class _SlotMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SlotMetaRow({required this.icon, required this.text});

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

class _SlotStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SlotStatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
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
