import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import 'legal_document_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String _privacyEmail = 'privacy@schoolscoringapp.ph';
  static const String _hotline = '+63 2 8123 4567';
  static const String _lastUpdated = 'Last Updated: April 15, 2026';

  @override
  Widget build(BuildContext context) {
    return LegalDocumentScreen(
      title: 'Privacy Policy',
      lastUpdated: _lastUpdated,
      icon: Icons.privacy_tip_outlined,
      introParagraphs: const [
        'This Privacy Policy describes how ${AppStrings.appName} ("we," "us," or "our") collects, uses, and shares your personal information in compliance with the Data Privacy Act of 2012.',
      ],
      sections: const [
        LegalSectionData(
          title: '2. Information We Collect',
          bullets: [
            'Account Info: Name, email address, phone number, and password.',
            'Device Data: IP address, operating system, device ID, and browser type.',
            'Permissions: Camera, microphone, or location data if required for functionality.',
          ],
        ),
        LegalSectionData(
          title: '3. How We Use Your Information',
          bullets: [
            'Provide, operate, and maintain the app.',
            'Improve user experience and app performance.',
            'Process transactions (if applicable).',
            'Send marketing communications, with the option to opt out at any time.',
          ],
        ),
        LegalSectionData(
          title: '4. Sharing of Information',
          paragraphs: [
            'We do not sell your personal data. We may share data with trusted third-party service providers, affiliates, or if required by law.',
          ],
        ),
        LegalSectionData(
          title: '5. Data Retention and Security',
          paragraphs: [
            'We retain personal information only for as long as necessary to fulfill the purposes outlined. Data is secured using encryption, but no method is 100% secure. Personal data is generally stored for five (5) years before secure disposal.',
          ],
        ),
        LegalSectionData(
          title: '6. Your Rights as a Data Subject',
          bullets: [
            'Access: Obtain confirmation that we hold your data.',
            'Correct: Update inaccurate or incomplete data.',
            'Withdraw Consent: Stop us from processing your data, which may limit app functionality.',
          ],
        ),
        LegalSectionData(
          title: '7. Contact Us',
          bullets: ['Email: $_privacyEmail', 'Phone: $_hotline'],
          isHighlighted: true,
        ),
        LegalSectionData(
          title: '8. Updates to Policy',
          paragraphs: [
            'We may update this policy occasionally, with significant changes posted within the app.',
          ],
        ),
      ],
    );
  }
}
