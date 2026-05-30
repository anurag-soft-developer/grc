import 'package:flutter/material.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/views/legal/legal_section.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  static const String _lastUpdated = 'May 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Terms of service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: $_lastUpdated',
              style: const TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 24),
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
        ),
      ),
    );
  }
}
