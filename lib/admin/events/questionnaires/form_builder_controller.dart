import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/questionnaires/custom_question_key_util.dart';
import 'package:grc/admin/events/questionnaires/event_question_draft.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/registrations/model/custom_question_model.dart';

class FormBuilderController extends GetxController {
  late RunEventModel event;
  final RxList<EventQuestionDraft> drafts = <EventQuestionDraft>[].obs;

  String? get eventId => event.id;

  void initFromArguments() {
    final args = Get.arguments;
    if (args is! RunEventModel) {
      throw ArgumentError('RunEventModel required');
    }
    event = args;
    _loadDrafts(event.customQuestions);
  }

  void _loadDrafts(List<CustomQuestionModel> questions) {
    _clearDrafts();
    final sorted = List<CustomQuestionModel>.from(questions)
      ..sort((a, b) => a.order.compareTo(b.order));
    for (var i = 0; i < sorted.length; i++) {
      final draft = EventQuestionDraft.fromModel(sorted[i]);
      draft.order = i;
      drafts.add(draft);
    }
  }

  void addQuestion() {
    drafts.add(EventQuestionDraft(order: drafts.length));
  }

  void removeQuestion(int index) {
    if (index < 0 || index >= drafts.length) return;
    drafts[index].dispose();
    drafts.removeAt(index);
    for (var i = 0; i < drafts.length; i++) {
      drafts[i].order = i;
    }
  }

  String? validateAll() {
    for (var i = 0; i < drafts.length; i++) {
      final error = drafts[i].validationError();
      if (error != null) return 'Question ${i + 1}: $error';
    }
    return null;
  }

  List<CustomQuestionModel>? buildPayload() {
    final validationError = validateAll();
    if (validationError != null) return null;

    assignQuestionKeys(drafts);
    final models = <CustomQuestionModel>[];
    for (final draft in drafts) {
      final key = draft.existingKey?.trim().isNotEmpty == true
          ? draft.existingKey!.trim()
          : draft.assignedKey;
      if (key == null || key.isEmpty) return null;
      final model = draft.toModel(key);
      if (model == null) return null;
      models.add(model);
    }
    return models;
  }

  Future<RunEventModel?> save() async {
    final id = eventId;
    if (id == null || id.isEmpty) return null;

    final questions = buildPayload();
    if (questions == null) return null;

    return RunEventsService.instance.updateCustomQuestions(
      id,
      UpdateRunEventCustomQuestionsInput(customQuestions: questions),
    );
  }

  void _clearDrafts() {
    for (final d in drafts) {
      d.dispose();
    }
    drafts.clear();
  }

  @override
  void onClose() {
    _clearDrafts();
    super.onClose();
  }
}
