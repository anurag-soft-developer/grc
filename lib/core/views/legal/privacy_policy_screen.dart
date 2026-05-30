import 'package:flutter/material.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/views/legal/legal_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String _lastUpdated = 'May 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Privacy policy')),
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
            const LegalSection(
              title: '1. Information we collect',
              body:
                  'We collect information you provide (such as name, email, and phone), registration and event activity needed to operate the service, and technical data such as device type and diagnostics to improve reliability and security.',
            ),
            const LegalSection(
              title: '2. How we use information',
              body:
                  'We use your information to provide event registration, account security features (including two-factor authentication), customer support, fraud prevention, and product improvement. We do not sell your personal information.',
            ),
            const LegalSection(
              title: '3. Sharing',
              body:
                  'We may share limited data with event organizers to fulfil your registration, with service providers who assist our operations under strict agreements, or when required by law.',
            ),
            const LegalSection(
              title: '4. Security',
              body:
                  'We implement reasonable technical and organizational measures to protect your data. No method of transmission over the internet is completely secure.',
            ),
            const LegalSection(
              title: '5. Your choices',
              body:
                  'You can update profile information in the app, change your password, manage two-factor authentication in Settings, and contact us to exercise applicable rights such as access or deletion where the law requires.',
            ),
            const LegalSection(
              title: '6. Contact',
              body:
                  'Privacy questions: privacy@example.com.',
            ),
          ],
        ),
      ),
    );
  }
}
