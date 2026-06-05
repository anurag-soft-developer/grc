import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/registrations/event_registration_controller.dart';
import 'package:grc/components/registration/registration_form_fields.dart';

class EventRegistrationFormScreen extends StatelessWidget {
  const EventRegistrationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventRegistrationController>();
    final event = controller.event;

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: Text(event?.title ?? 'Register')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final ctx = controller.context.value;
        if (ctx == null) {
          return const Center(child: Text('Registration unavailable'));
        }

        // Rebuild when radio/checkbox/select update customAnswers.
        final _ = controller.formRevision.value;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RegistrationCustomQuestions(
                      questions: controller.customQuestions,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: CustomButton(
                  text: controller.isSubmitting.value
                      ? 'Please wait...'
                      : 'Continue',
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitAndContinue,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
