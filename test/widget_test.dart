import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:school_scoring_app/main.dart';
import 'package:school_scoring_app/core/constants/app_strings.dart';

void main() {
  testWidgets('App title smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SchoolScoringApp());

    // Verify that the app title is displayed.
    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text('Architecture setup complete!'), findsOneWidget);
  });
}
