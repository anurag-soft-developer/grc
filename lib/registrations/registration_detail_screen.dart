import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/app_colors.dart';
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
      appBar: AppBar(title: const Text('Registration')),
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
    final event = participant.runEvent;
    final questions = event?.customQuestions ?? const <CustomQuestionModel>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            event?.title ?? 'Event',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _row('Status', participant.status),
          _row('Payment', participant.paymentStatus),
          if (participant.invoiceId != null)
            _row('Invoice', participant.invoiceId),
          if (participant.paidAt != null) _row('Paid at', participant.paidAt),
          if (participant.totalAmount != null)
            _row('Amount', '₹${participant.totalAmount}'),
          if (questions.isNotEmpty) ...[
            const Text(
              'Your answers',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...questions.map((q) {
              final raw = participant.customQuestionResponses[q.key];
              return _row(q.label, _formatAnswer(raw));
            }),
          ],
          if (participant.isPendingPayment) ...[
            const SizedBox(height: 24),
            Obx(
              () => CustomButton(
                text: payController.isSubmitting.value
                    ? 'Please wait...'
                    : 'Pay now',
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

  Widget _row(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Color(AppColors.textSecondary)),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatAnswer(dynamic raw) {
    if (raw == null) return '—';
    if (raw is List) return raw.join(', ');
    if (raw is bool) return raw ? 'Yes' : 'No';
    return raw.toString();
  }
}
