import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/questionnaires/form_renderer.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/registrations/model/custom_question_type.dart';

class EventQuestionnairesPreviewScreen extends HookWidget {
  const EventQuestionnairesPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = useMemoized(() => Get.parameters['id']);
    final previewAnswers = useMemoized(() => <String, dynamic>{}, const []);
    final formRevision = useState(0);

    final eventQuery = useQuery<RunEventModel?, Object>(
      QueryKeys.adminEvent(id ?? ''),
      (_) async {
        final routeId = id;
        if (routeId == null || routeId.isEmpty) return null;
        return RunEventsService.instance.getEventById(routeId);
      },
      enabled: id != null && id!.isNotEmpty,
    );

    Future<void> openEditor(String id) async {
      final updated = await Get.toNamed<RunEventModel>(
        AppConstants.routes.adminFormBuilderPath(id),
      );
      if (updated != null) {
        eventQuery.refetch();
      }
    }

    if (id == null || id!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registration questions')),
        body: const Center(child: Text('Event not found')),
      );
    }

    return QueryAsyncBody<RunEventModel?, dynamic>(
      state: eventQuery,
      onRetry: eventQuery.refetch,
      data: (data) {
        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Registration questions')),
            body: const Center(child: Text('Event not found')),
          );
        }

        final id = data.id;
        final questions = data.customQuestions;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            Get.back(result: data);
          },
          child: Scaffold(
            backgroundColor: const Color(AppColors.background),
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0.5,
              backgroundColor: const Color(AppColors.surface),
              foregroundColor: const Color(AppColors.text),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: const Color(AppColors.text),
                onPressed: () => Get.back(result: data),
              ),
              title: _PreviewAppBarTitle(eventTitle: data.title),
              actions: [
                if (id != null)
                  IconButton(
                    onPressed: () => openEditor(id),
                    tooltip: 'Edit form',
                    icon: const Icon(Icons.edit_outlined),
                    color: const Color(AppColors.primary),
                  ),
              ],
            ),
            body: AdaptivePageContainer(
              maxWidth: 920,
              alignment: Alignment.topCenter,
              child: questions.isEmpty
                  ? _EmptyPreview(
                      onEdit: id != null ? () => openEditor(id) : () {},
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                      child: FormRenderer(
                        key: ValueKey(formRevision.value),
                        questions: questions,
                        answers: previewAnswers,
                        sectionTitle: 'Registration form',
                        sectionSubtitle:
                            'Fill in the fields below to preview the participant experience.',
                        onAnswerChanged: (key, _) {
                          final question = questions
                              .where((q) => q.key == key)
                              .firstOrNull;
                          if (question == null) return;
                          final needsRebuild = switch (question.type) {
                            CustomQuestionType.radio ||
                            CustomQuestionType.checkbox ||
                            CustomQuestionType.select =>
                              true,
                            _ => false,
                          };
                          if (needsRebuild) formRevision.value++;
                        },
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _PreviewAppBarTitle extends StatelessWidget {
  final String eventTitle;

  const _PreviewAppBarTitle({required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          eventTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(AppColors.text),
          ),
        ),
        const Text(
          'Registration form',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  final VoidCallback onEdit;

  const _EmptyPreview({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 48,
            color: const Color(AppColors.primary).withValues(alpha: 0.35),
          ),
          const SizedBox(height: 12),
          const Text(
            'No questions yet',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(AppColors.text),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add fields participants fill during registration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit questions'),
          ),
        ],
      ),
    );
  }
}
