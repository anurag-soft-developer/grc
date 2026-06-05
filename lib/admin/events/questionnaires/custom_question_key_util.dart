import 'package:grc/admin/events/questionnaires/event_question_draft.dart';

String slugifyCustomQuestionKey(String label) {
  var base = label
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  if (base.isEmpty) base = 'question';
  return base;
}

/// Assigns stable keys: keeps [EventQuestionDraft.existingKey] when set.
List<EventQuestionDraft> assignQuestionKeys(List<EventQuestionDraft> drafts) {
  final used = <String>{};
  for (final draft in drafts) {
    final key = draft.existingKey?.trim();
    if (key != null && key.isNotEmpty) {
      used.add(key);
    }
  }

  for (final draft in drafts) {
    final preserved = draft.existingKey?.trim();
    if (preserved != null && preserved.isNotEmpty) {
      continue;
    }

    var base = slugifyCustomQuestionKey(draft.labelController.text.trim());
    var candidate = base;
    var n = 2;
    while (used.contains(candidate)) {
      candidate = '${base}_$n';
      n++;
    }
    draft.assignedKey = candidate;
    used.add(candidate);
  }

  return drafts;
}
