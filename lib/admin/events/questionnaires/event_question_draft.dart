import 'package:flutter/material.dart';
import 'package:grc/registrations/model/custom_question_model.dart';
import 'package:grc/registrations/model/custom_question_type.dart';

class EventQuestionDraft {
  EventQuestionDraft({
    String? existingKey,
    String? label,
    this.type = CustomQuestionType.text,
    List<String>? options,
    this.required = false,
    this.order = 0,
  })  : existingKey = existingKey,
        labelController = TextEditingController(text: label ?? '') {
    if (options != null) {
      for (final option in options) {
        optionControllers.add(TextEditingController(text: option));
      }
    }
  }

  final String? existingKey;
  String? assignedKey;
  final TextEditingController labelController;
  final List<TextEditingController> optionControllers = [];
  CustomQuestionType type;
  bool required;
  int order;

  factory EventQuestionDraft.fromModel(CustomQuestionModel q) {
    return EventQuestionDraft(
      existingKey: q.key,
      label: q.label,
      type: q.type,
      options: q.options,
      required: q.required,
      order: q.order,
    );
  }

  void dispose() {
    labelController.dispose();
    _disposeOptionControllers();
  }

  void _disposeOptionControllers() {
    for (final c in optionControllers) {
      c.dispose();
    }
    optionControllers.clear();
  }

  void ensureOptionFields() {
    if (type.needsOptions && optionControllers.isEmpty) {
      optionControllers.add(TextEditingController());
    }
  }

  void onTypeChanged(CustomQuestionType newType) {
    type = newType;
    if (newType.needsOptions) {
      ensureOptionFields();
    } else {
      _disposeOptionControllers();
    }
  }

  void addOption() {
    optionControllers.add(TextEditingController());
  }

  void removeOption(int index) {
    if (index < 0 || index >= optionControllers.length) return;
    optionControllers[index].dispose();
    optionControllers.removeAt(index);
  }

  List<String> get parsedOptions => optionControllers
      .map((c) => c.text.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  String? validationError() {
    final label = labelController.text.trim();
    if (label.isEmpty) return 'Label is required';
    if (type.needsOptions && parsedOptions.isEmpty) {
      return 'Add at least one option';
    }
    return null;
  }

  CustomQuestionModel? toModel(String key) {
    if (validationError() != null) return null;
    return CustomQuestionModel(
      key: key,
      label: labelController.text.trim(),
      type: type,
      options: parsedOptions,
      required: required,
      order: order,
    );
  }
}
