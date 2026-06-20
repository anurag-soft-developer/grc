import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/registration_details/compact_event_section.dart';
import 'package:grc/components/registration_details/detail_tile.dart';
import 'package:grc/components/registration_details/primary_details_card.dart';
import 'package:grc/components/registration_details/section_card.dart';
import 'package:grc/components/registration_details/status_helpers.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/registrations/event_registration_controller.dart';
import 'package:grc/registrations/model/custom_question_model.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

class RegistrationDetailScreen extends HookWidget {
  const RegistrationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = useMemoized(() => Get.parameters['id']);
    final payController = useMemoized(() {
      if (!Get.isRegistered<EventRegistrationController>()) {
        Get.put(EventRegistrationController());
      }
      return Get.find<EventRegistrationController>();
    }, const []);

    final detailQuery = useQuery<RunEventParticipantModel?, Object>(
      QueryKeys.registrationDetail(id ?? ''),
      (_) async {
        final routeId = id;
        if (routeId == null || routeId.isEmpty) return null;
        return RunEventParticipantsService.instance.getById(routeId);
      },
      enabled: id != null && id.isNotEmpty,
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

    final sideContent = <Widget>[
      if (answeredQuestions.isNotEmpty)
        RegistrationSectionCard(
          title: 'Your answers',
          icon: Icons.quiz_outlined,
          children: answeredQuestions.map((q) {
            final raw = participant.customQuestionResponses[q.key];
            return RegistrationDetailTile(
              icon: Icons.chat_bubble_outline_rounded,
              label: q.label,
              value: formatRegistrationAnswer(raw),
            );
          }).toList(),
        ),
      if (event != null) ...[
        if (answeredQuestions.isNotEmpty) const SizedBox(height: 16),
        CompactEventSection(event: event),
      ],
      if (participant.isPendingPayment) ...[
        if (answeredQuestions.isNotEmpty || event != null)
          const SizedBox(height: 24),
        Obx(
          () => CustomButton(
            text: payController.isSubmitting.value
                ? 'Please wait...'
                : 'Pay now',
            icon: const Icon(Icons.lock_rounded, size: 20, color: Colors.white),
            onPressed: payController.isSubmitting.value
                ? null
                : () => payController.payNowFromDetail(participant),
          ),
        ),
      ],
    ];

    return AdaptivePageContainer(
      maxWidth: 1160,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 960;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: PrimaryDetailsCard(participant: participant),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: sideContent,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryDetailsCard(participant: participant),
                      if (sideContent.isNotEmpty) const SizedBox(height: 16),
                      ...sideContent,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
