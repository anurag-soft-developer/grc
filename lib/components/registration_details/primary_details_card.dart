import 'package:flutter/material.dart';
import 'package:grc/core/components/shared/previewable_avatar.dart';
import 'package:grc/components/registration_details/status_helpers.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/utils/date_format_util.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';

class PrimaryDetailsCard extends StatelessWidget {
  final RunEventParticipantModel participant;

  const PrimaryDetailsCard({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final avatar = participant.displayAvatar;
    final status = participant.status ?? 'unknown';
    final payment = participant.paymentStatus ?? 'pending';
    final tone = registrationStatusTone(status, payment);
    final canPreviewAvatar = avatar != null && avatar.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreviewableAvatar(
                imageUrl: avatar,
                enablePreview: canPreviewAvatar,
                radius: 36,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participant.displayFullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(AppColors.text),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: Color(AppColors.textSecondary),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            participant.displayEmail,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(AppColors.textSecondary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Color(AppColors.textSecondary),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            participant.displayPhone,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(AppColors.textSecondary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: tone.border),
            ),
            child: Row(
              children: [
                Icon(tone.icon, size: 18, color: tone.foreground),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tone.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: tone.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(AppColors.textSecondary),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          _CompactInfoChipRow(
            label: 'Status',
            chipLabel: registrationLabel(participant.status),
            chipColor: tone.foreground,
          ),
          _CompactInfoChipRow(
            label: 'Payment',
            chipLabel: registrationLabel(participant.paymentStatus),
            chipColor: paymentChipColor(participant.paymentStatus),
          ),
          if (participant.totalAmount != null)
            _CompactInfoRow(
              label: 'Amount',
              value: '₹${participant.totalAmount!.toStringAsFixed(0)}',
            ),
          if (participant.invoiceId != null)
            _CompactInfoRow(label: 'Invoice', value: participant.invoiceId!),
          if (participant.submittedAt != null)
            _CompactInfoRow(
              label: 'Submitted',
              value: formatEventDateTime(participant.submittedAt),
            ),
          if (participant.paidAt != null)
            _CompactInfoRow(
              label: 'Paid on',
              value: formatEventDateTime(participant.paidAt),
            ),
          if (participant.isPendingPayment &&
              participant.paymentExpiresAt != null)
            _CompactInfoRow(
              label: 'Pay before',
              value: formatEventDateTime(participant.paymentExpiresAt),
              valueColor: const Color(AppColors.error),
            ),
        ],
      ),
    );
  }
}

class _CompactInfoChipRow extends StatelessWidget {
  final String label;
  final String chipLabel;
  final Color chipColor;

  const _CompactInfoChipRow({
    required this.label,
    required this.chipLabel,
    required this.chipColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ),
          Expanded(
            child: _StatusChip(label: chipLabel, color: chipColor),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _CompactInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _CompactInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(AppColors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
