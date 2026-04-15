import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import 'legal_document_screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  static const String _companyName = 'Courtside Digital Solutions Inc.';
  static const String _privacyEmail = 'privacy@schoolscoringapp.ph';
  static const String _supportEmail = 'support@schoolscoringapp.ph';
  static const String _businessAddress =
      '123 Courtside Avenue, Quezon City, Metro Manila, Philippines';
  static const String _jurisdictionCity = 'Quezon City';
  static const String _lastUpdated = 'Last Updated: April 16, 2026';

  @override
  Widget build(BuildContext context) {
    return LegalDocumentScreen(
      title: 'Terms and Conditions',
      lastUpdated: _lastUpdated,
      icon: Icons.gavel_outlined,
      introParagraphs: const [
        'Welcome to ${AppStrings.appName}! These Terms and Conditions ("Terms") govern your use of the ${AppStrings.appName} mobile application (the "App"), owned and operated by $_companyName, a business entity organized and existing under the laws of the Republic of the Philippines.',
        'By downloading, installing, or using the App, you agree to be bound by these Terms. If you do not agree, please discontinue use immediately.',
      ],
      sections: const [
        LegalSectionData(
          title: '1. Eligibility',
          paragraphs: [
            'You must be at least 18 years of age to create an account. Users under 18 must have the express consent and supervision of a parent or legal guardian who agrees to be bound by these Terms.',
          ],
        ),
        LegalSectionData(
          title: '2. User Accounts and Security',
          bullets: [
            'Accuracy: You agree to provide true, accurate, and current information during registration.',
            'Responsibility: You are solely responsible for maintaining the confidentiality of your login credentials. Any activity under your account is deemed your responsibility.',
            'Prohibitions: You may not impersonate others, use offensive usernames, or create multiple accounts for fraudulent purposes.',
          ],
        ),
        LegalSectionData(
          title: '3. Data Privacy (RA 10173)',
          paragraphs: [
            'In compliance with the Data Privacy Act of 2012 (DPA) of the Philippines, we are committed to protecting your personal information.',
          ],
          bullets: [
            'Collection: We collect data such as your name, contact details, and location for purposes of stats tracking.',
            'Consent: By using the App, you consent to the processing of your data as outlined in our Privacy Policy.',
            'Rights: You have the right to access, correct, or request the deletion of your personal data by contacting our Data Protection Officer at $_privacyEmail.',
          ],
        ),
        LegalSectionData(
          title: '4. Code of Conduct and Sportsmanship',
          paragraphs: [
            'Users agree to use the App in a manner consistent with the spirit of the game. You shall not:',
          ],
          bullets: [
            'Use the App for illegal gambling or betting.',
            'Post defamatory, obscene, or threatening content.',
            'Harass, bully, or discriminate against other players, teams, or officials.',
          ],
        ),
        LegalSectionData(
          title: '5. Waiver and Limitation of Liability',
          bullets: [
            'Physical Injury: Basketball is a physical sport. ${AppStrings.appName} is a digital platform and is not liable for any physical injuries, medical conditions, or accidents sustained by users during games or at facilities found through the App.',
            'Loss of Property: We are not responsible for any lost or stolen items at basketball venues.',
            'App Reliability: The App is provided "as is." We do not guarantee that the service will be uninterrupted or error-free.',
          ],
        ),
        LegalSectionData(
          title: '6. Intellectual Property',
          paragraphs: [
            'All content, trademarks, logos, and software code within the App are the exclusive property of $_companyName. Unauthorized copying, modification, or distribution is strictly prohibited.',
          ],
        ),
        LegalSectionData(
          title: 'Account Suspension and Termination',
          paragraphs: [
            'We reserve the right to suspend or terminate your account without prior notice if you violate these Terms or engage in activities that harm the community or the App\'s reputation.',
          ],
          isHighlighted: true,
        ),
        LegalSectionData(
          title: '7. Governing Law and Jurisdiction',
          paragraphs: [
            'These Terms are governed by the laws of the Republic of the Philippines. Any legal action arising from these Terms shall be filed exclusively in the proper courts of $_jurisdictionCity, Philippines.',
          ],
        ),
        LegalSectionData(
          title: '8. Amendments',
          paragraphs: [
            'We may update these Terms from time to time. Continued use of the App after changes are posted constitutes your acceptance of the new Terms.',
          ],
        ),
        LegalSectionData(
          title: '9. Contact Us',
          bullets: ['Email: $_supportEmail', 'Address: $_businessAddress'],
        ),
      ],
    );
  }
}
