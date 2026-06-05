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

class RegistrationDetailScreen extends HookWidget {
  const RegistrationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participantId = Get.arguments as String?;
    final payController = useMemoized(
      () {
        if (!Get.isRegistered<EventRegistrationController>()) {
          Get.put(EventRegistrationController());
        }
        return Get.find<EventRegistrationController>();
      },
      const [],
    );

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
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: false,
      ),
      body: QueryAsyncBody<RunEventParticipantModel?, dynamic>(
        state: detailQuery,
        onRetry: detailQuery.refetch,
        data: (p) {
          if (p == null) {
            return const Center(child: Text('Registration not found'));
          }
          return _DetailContent(
            participant: p,
            payController: payController,
          );
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
          const SizedBox(height: 16),
          _CompactEventSection(event: event),
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
    final phone = user?.phone?.trim();
    final contact = participant.displayContact;
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
                  backgroundImage:
                      avatar != null ? NetworkImage(avatar) : null,
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _StatusChip(label: _label(status), color: tone.foreground),
                        if (payment.isNotEmpty)
                          _StatusChip(
                            label: _label(payment),
                            color: const Color(AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (email != null && email.isNotEmpty ||
              phone != null && phone.isNotEmpty ||
              (contact.isNotEmpty && contact != email)) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(AppColors.divider)),
            const SizedBox(height: 16),
            if (email != null && email.isNotEmpty)
              _CompactContactRow(
                icon: Icons.email_outlined,
                value: email,
              ),
            if (phone != null && phone.isNotEmpty)
              _CompactContactRow(
                icon: Icons.phone_outlined,
                value: phone,
              )
            else if (contact.isNotEmpty && contact != email)
              _CompactContactRow(
                icon: Icons.alternate_email_rounded,
                value: contact,
              ),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tone.border),
            ),
            child: Row(
              children: [
                Icon(tone.icon, size: 20, color: tone.foreground),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tone.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: tone.foreground,
                        ),
                      ),
                      Text(
                        tone.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: tone.foreground.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Registration',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(AppColors.textSecondary),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          _CompactInfoRow(
            label: 'Registration ID',
            value: _shortId(participant.id),
          ),
          _CompactInfoRow(label: 'Status', value: _label(participant.status)),
          _CompactInfoRow(
            label: 'Payment',
            value: _label(participant.paymentStatus),
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
              value: _formatDateTime(participant.submittedAt!),
            ),
          if (participant.paidAt != null)
            _CompactInfoRow(
              label: 'Paid on',
              value: _formatDateTime(participant.paidAt!),
            ),
          if (participant.isPendingPayment &&
              participant.paymentExpiresAt != null)
            _CompactInfoRow(
              label: 'Pay before',
              value: _formatDateTime(participant.paymentExpiresAt!),
              valueColor: const Color(AppColors.error),
            ),
        ],
      ),
    );
  }
}

class _CompactContactRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _CompactContactRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppColors.text),
              ),
            ),
          ),
        ],
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
  final RunEventModel? event;

  const _CompactEventSection({required this.event});

  @override
  Widget build(BuildContext context) {
    final location = event?.location;
    final locationLabel = location == null
        ? null
        : [
            location.city,
            location.state,
          ].where((s) => s.isNotEmpty).join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(AppColors.textSecondary),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event?.title ?? 'Event',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(AppColors.text),
            ),
          ),
          if (event?.eventDate != null) ...[
            const SizedBox(height: 6),
            _CompactEventMeta(
              icon: Icons.calendar_today_outlined,
              text: _formatDate(event!.eventDate!),
            ),
          ],
          if (event?.reportingTime != null) ...[
            const SizedBox(height: 4),
            _CompactEventMeta(
              icon: Icons.schedule_outlined,
              text: 'Report by ${event!.reportingTime}',
            ),
          ],
          if (locationLabel != null && locationLabel.isNotEmpty) ...[
            const SizedBox(height: 4),
            _CompactEventMeta(
              icon: Icons.location_on_outlined,
              text: locationLabel,
            ),
          ],
          if (location?.address != null && location!.address.isNotEmpty) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                location.address,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(AppColors.textSecondary),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactEventMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CompactEventMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(AppColors.textSecondary)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(AppColors.textSecondary),
            ),
          ),
        ),
      ],
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

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _StatusTone {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;

  const _StatusTone({
    required this.title,
    required this.subtitle,
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
      subtitle: 'You are registered for this event',
      icon: Icons.verified_rounded,
      foreground: Color(AppColors.success),
      background: Color(0xFFECFDF5),
      border: Color(0xFFA7F3D0),
    );
  }
  if (status == 'pending_payment') {
    return const _StatusTone(
      title: 'Payment pending',
      subtitle: 'Complete payment to confirm your spot',
      icon: Icons.hourglass_top_rounded,
      foreground: Color(AppColors.primary),
      background: Color(0xFFEEF2FF),
      border: Color(0xFFC7D2FE),
    );
  }
  if (status == 'cancelled') {
    return const _StatusTone(
      title: 'Registration cancelled',
      subtitle: 'This registration is no longer active',
      icon: Icons.cancel_outlined,
      foreground: Color(AppColors.error),
      background: Color(0xFFFEF2F2),
      border: Color(0xFFFECACA),
    );
  }
  if (status == 'draft') {
    return const _StatusTone(
      title: 'Draft registration',
      subtitle: 'Finish and submit your registration',
      icon: Icons.edit_note_rounded,
      foreground: Color(AppColors.textSecondary),
      background: Color(AppColors.surface),
      border: Color(AppColors.divider),
    );
  }
  return _StatusTone(
    title: _label(status),
    subtitle: 'Payment: ${_label(payment)}',
    icon: Icons.info_outline_rounded,
    foreground: const Color(AppColors.secondary),
    background: const Color(0xFFF0FDFA),
    border: const Color(0xFF99F6E4),
  );
}

String _label(String? value) {
  if (value == null || value.isEmpty) return '—';
  return value.replaceAll('_', ' ');
}

String _shortId(String? id) {
  if (id == null || id.isEmpty) return '—';
  if (id.length <= 8) return id.toUpperCase();
  return id.substring(id.length - 8).toUpperCase();
}

String _formatDate(String iso) {
  try {
    final d = DateTime.parse(iso).toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  } catch (_) {
    return iso;
  }
}

String _formatDateTime(String iso) {
  try {
    final d = DateTime.parse(iso).toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final period = d.hour >= 12 ? 'PM' : 'AM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, $hour:$minute $period';
  } catch (_) {
    return iso;
  }
}

String _formatAnswer(dynamic raw) {
  if (raw == null) return '—';
  if (raw is List) return raw.join(', ');
  if (raw is bool) return raw ? 'Yes' : 'No';
  return raw.toString();
}
