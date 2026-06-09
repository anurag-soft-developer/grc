import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/registrations/event_registration_controller.dart';
import 'package:grc/registrations/model/custom_question_model.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/date_format_util.dart';

class RegistrationDetailScreen extends HookWidget {
  const RegistrationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Capture once — Get.arguments is global and changes when child routes
    // (e.g. event detail) are pushed, so re-reading on rebuild causes cast errors.
    final participantId = useMemoized(() {
      final args = Get.arguments;
      return args is String ? args : null;
    });
    final payController = useMemoized(() {
      if (!Get.isRegistered<EventRegistrationController>()) {
        Get.put(EventRegistrationController());
      }
      return Get.find<EventRegistrationController>();
    }, const []);

    final detailQuery = useQuery<RunEventParticipantModel?, Object>(
      QueryKeys.registrationDetail(participantId ?? ''),
      (_) async {
        final id = participantId;
        if (id == null || id.isEmpty) return null;
        return RunEventParticipantsService.instance.getById(id);
      },
      enabled: participantId != null && participantId.isNotEmpty,
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Registration'), centerTitle: false),
      body: QueryAsyncBody<RunEventParticipantModel?, dynamic>(
        state: detailQuery,
        onRetry: detailQuery.refetch,
        data: (p) {
          if (p == null) {
            return const Center(child: Text('Registration not found'));
          }
          return _DetailContent(participant: p, payController: payController);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final RunEventParticipantModel participant;
  final EventRegistrationController payController;

  const _DetailContent({
    required this.participant,
    required this.payController,
  });

  @override
  Widget build(BuildContext context) {
    final event = participant.runEventModel;
    final questions = event?.customQuestions ?? const <CustomQuestionModel>[];
    final answeredQuestions = questions.where((q) {
      final raw = participant.customQuestionResponses[q.key];
      return raw != null && raw != '' && !(raw is List && raw.isEmpty);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PrimaryDetailsCard(participant: participant),
          if (answeredQuestions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Your answers',
              icon: Icons.quiz_outlined,
              children: answeredQuestions.map((q) {
                final raw = participant.customQuestionResponses[q.key];
                return _DetailTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: q.label,
                  value: _formatAnswer(raw),
                );
              }).toList(),
            ),
          ],
          if (event != null) ...[
            const SizedBox(height: 16),
            _CompactEventSection(event: event),
          ],
          if (participant.isPendingPayment) ...[
            const SizedBox(height: 24),
            Obx(
              () => CustomButton(
                text: payController.isSubmitting.value
                    ? 'Please wait...'
                    : 'Pay now',
                icon: const Icon(
                  Icons.lock_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: payController.isSubmitting.value
                    ? null
                    : () => payController.payNowFromDetail(participant),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrimaryDetailsCard extends StatelessWidget {
  final RunEventParticipantModel participant;

  const _PrimaryDetailsCard({required this.participant});

  @override
  Widget build(BuildContext context) {
    final user = participant.userModel;
    final avatar = participant.displayAvatar;
    final email = user?.email?.trim();
    final contact = participant.displayContact;
    final contactLabel = (email != null && email.isNotEmpty)
        ? email
        : (contact.isNotEmpty ? contact : null);
    final contactIcon = (email != null && email.isNotEmpty)
        ? Icons.email_outlined
        : Icons.phone_outlined;
    final status = participant.status ?? 'unknown';
    final payment = participant.paymentStatus ?? 'pending';
    final tone = _statusTone(status, payment);

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
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(AppColors.primary).withValues(alpha: 0.7),
                      const Color(AppColors.secondary).withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(AppColors.surface),
                  backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                  child: avatar != null
                      ? null
                      : Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: const Color(
                            AppColors.primary,
                          ).withValues(alpha: 0.6),
                        ),
                ),
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
                    if (contactLabel != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            contactIcon,
                            size: 14,
                            color: const Color(AppColors.textSecondary),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contactLabel,
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
          // _CompactInfoRow(
          //   label: 'Registration ID',
          //   value: _shortId(participant.id),
          // ),
          _CompactInfoChipRow(
            label: 'Status',
            chipLabel: _label(participant.status),
            chipColor: tone.foreground,
          ),
          _CompactInfoChipRow(
            label: 'Payment',
            chipLabel: _label(participant.paymentStatus),
            chipColor: _paymentChipColor(participant.paymentStatus),
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

class _CompactEventSection extends StatelessWidget {
  final RunEventModel event;

  const _CompactEventSection({required this.event});

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
        onTap: () =>
            Get.toNamed(AppConstants.routes.eventDetail, arguments: event),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(AppColors.primary)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(AppColors.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(AppColors.background),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.text),
                    height: 1.35,
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

class _StatusTone {
  final String title;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;

  const _StatusTone({
    required this.title,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.border,
  });
}

_StatusTone _statusTone(String status, String payment) {
  if (status == 'submitted' && payment == 'paid') {
    return const _StatusTone(
      title: 'Registration confirmed',
      icon: Icons.verified_rounded,
      foreground: Color(AppColors.success),
      background: Color(0xFFECFDF5),
      border: Color(0xFFA7F3D0),
    );
  }
  if (status == 'pending_payment') {
    return const _StatusTone(
      title: 'Payment pending',
      icon: Icons.hourglass_top_rounded,
      foreground: Color(AppColors.primary),
      background: Color(0xFFEEF2FF),
      border: Color(0xFFC7D2FE),
    );
  }
  if (status == 'cancelled') {
    return const _StatusTone(
      title: 'Registration cancelled',
      icon: Icons.cancel_outlined,
      foreground: Color(AppColors.error),
      background: Color(0xFFFEF2F2),
      border: Color(0xFFFECACA),
    );
  }
  if (status == 'draft') {
    return const _StatusTone(
      title: 'Draft registration',
      icon: Icons.edit_note_rounded,
      foreground: Color(AppColors.textSecondary),
      background: Color(AppColors.surface),
      border: Color(AppColors.divider),
    );
  }
  return _StatusTone(
    title: _label(status),
    icon: Icons.info_outline_rounded,
    foreground: const Color(AppColors.secondary),
    background: const Color(0xFFF0FDFA),
    border: const Color(0xFF99F6E4),
  );
}

String _label(String? value) {
  if (value == null || value.isEmpty) return '—';
  return value.replaceAll('_', ' ').capitalizeFirst ?? '';
}

Color _paymentChipColor(String? paymentStatus) {
  switch (paymentStatus) {
    case 'paid':
      return const Color(AppColors.success);
    case 'pending':
      return const Color(AppColors.primary);
    case 'failed':
      return const Color(AppColors.error);
    case 'refunded':
      return const Color(AppColors.textSecondary);
    default:
      return const Color(AppColors.textSecondary);
  }
}

// String _shortId(String? id) {
//   if (id == null || id.isEmpty) return '—';
//   if (id.length <= 8) return id.toUpperCase();
//   return id.substring(id.length - 8).toUpperCase();
// }

String _formatAnswer(dynamic raw) {
  if (raw == null) return '—';
  if (raw is List) return raw.join(', ');
  if (raw is bool) return raw ? 'Yes' : 'No';
  return raw.toString();
}
