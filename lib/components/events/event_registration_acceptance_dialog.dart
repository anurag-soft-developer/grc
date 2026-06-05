import 'package:flutter/material.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/views/legal/legal_section.dart';

class EventRegistrationAcceptanceDialog extends StatefulWidget {
  final RunEventModel event;

  const EventRegistrationAcceptanceDialog({
    super.key,
    required this.event,
  });

  static Future<bool> show(
    BuildContext context, {
    required RunEventModel event,
  }) async {
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EventRegistrationAcceptanceDialog(event: event),
    );
    return accepted ?? false;
  }

  @override
  State<EventRegistrationAcceptanceDialog> createState() =>
      _EventRegistrationAcceptanceDialogState();
}

class _EventRegistrationAcceptanceDialogState
    extends State<EventRegistrationAcceptanceDialog> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final guidelines = widget.event.guidelines;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 520,
        height: MediaQuery.sizeOf(context).height * 0.82,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(AppColors.text),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please review the guidelines and terms before registering.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(AppColors.textSecondary),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (guidelines.isNotEmpty) ...[
                      const _SectionHeading('Guidelines'),
                      const SizedBox(height: 8),
                      ...guidelines.map(
                        (g) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(AppColors.textSecondary),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  g,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Color(AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const _SectionHeading('Terms and conditions'),
                    const SizedBox(height: 8),
                    const _TermsContent(),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            CheckboxListTile(
              value: _accepted,
              onChanged: (value) => setState(() => _accepted = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text(
                'I have read and agree to the guidelines and terms & conditions',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(AppColors.text),
                  height: 1.35,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      isOutlined: true,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Continue',
                      onPressed: _accepted
                          ? () => Navigator.of(context).pop(true)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(AppColors.text),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LegalSection(
          title: '1. Agreement',
          body:
              'By accessing or using ${AppConstants.appName}, you agree to these Terms of Service. If you do not agree, please do not use the application.',
        ),
        const LegalSection(
          title: '2. Your account',
          body:
              'You are responsible for keeping your login credentials secure and for activity under your account. Information you provide must be accurate and kept up to date.',
        ),
        const LegalSection(
          title: '3. Events and registrations',
          body:
              'The app lets you browse events, submit registrations, and manage participation. Event rules, fees, refunds, and cancellations follow the policies shown at registration time and any instructions from event organizers.',
        ),
        const LegalSection(
          title: '4. Acceptable use',
          body:
              'You must not misuse the service, attempt unauthorized access, interfere with other users, or use the app for unlawful purposes. We may suspend or terminate access for violations.',
        ),
        const LegalSection(
          title: '5. Changes',
          body:
              'We may update these terms from time to time. Continued use after changes constitutes acceptance of the revised terms. Material changes may be communicated in the app or by email.',
        ),
        const LegalSection(
          title: '6. Contact',
          body:
              'Questions about these terms can be sent to support@example.com.',
        ),
      ],
    );
  }
}
