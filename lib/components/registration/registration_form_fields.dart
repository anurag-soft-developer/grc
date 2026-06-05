import 'package:flutter/material.dart';
import 'package:grc/components/questionnaires/form_renderer.dart';
import 'package:grc/registrations/event_registration_controller.dart';
import 'package:grc/registrations/model/custom_question_model.dart';

class RegistrationCustomQuestions extends StatelessWidget {
  final List<CustomQuestionModel> questions;
  final EventRegistrationController controller;

  const RegistrationCustomQuestions({
    super.key,
    required this.questions,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: FormRenderer(
        questions: questions,
        answers: controller.customAnswers,
        fieldErrors: controller.fieldErrors,
        sectionTitle: questions.isEmpty ? null : 'Registration questions',
        sectionSubtitle: questions.isEmpty
            ? null
            : 'Please answer the following questions.',
        onAnswerChanged: (key, _) {
          controller.clearFieldError(key);
          controller.notifyFormChanged();
        },
      ),
    );
  }
}
