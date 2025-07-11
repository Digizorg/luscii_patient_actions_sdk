import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_example/main.dart' as app;
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Get actions flow test', ($) async {
    // Enable verbose logging for tests
    await app.initApp();
    await $.pumpWidgetAndSettle(const app.MyApp());

    // Verify the app started correctly
    expect($('LusciiPatientActionsSdk Example'), findsOneWidget);
    expect($('Get actions'), findsOneWidget);

    // Add debug output for CI troubleshooting
    debugPrint('Test starting - app loaded successfully');

    // Tap on the "Get actions" button
    await $('Get actions').tap();

    // Give the UI a moment to start processing
    await $.pumpAndSettle();

    // Wait for the API call to complete with a more robust approach
    // Use a longer timeout for slower CI environments
    var apiCallCompleted = false;
    var attempts = 0;
    const maxAttempts = 30; // 30 seconds total timeout

    while (!apiCallCompleted && attempts < maxAttempts) {
      await Future<void>.delayed(const Duration(seconds: 1));
      attempts++;

      // Pump the widget tree to ensure UI updates are reflected
      await $.pumpAndSettle();

      // Check if we have any of the expected final states
      if ($('Error:').exists ||
          $('No actions available').exists ||
          $('Action').exists ||
          $('Press "Get actions" to retrieve your actions').exists) {
        apiCallCompleted = true;
      }

      // Log progress every 5 seconds for CI debugging
      if (attempts % 5 == 0) {
        debugPrint('Test waiting... attempt $attempts/$maxAttempts');
      }
    }

    // Add debug information for CI troubleshooting
    if (!apiCallCompleted) {
      debugPrint('API call timeout - checking current UI state...');
      debugPrint('Error message exists: ${$('Error:').exists}');
      debugPrint(
        'No actions message exists: ${$('No actions available').exists}',
      );
      debugPrint('Action text exists: ${$('Action').exists}');
      debugPrint(
        'Initial message exists: ${$('Press "Get actions" to retrieve your actions').exists}',
      );

      // Try to find what text is actually visible
      try {
        final finder = find.byType(Text);
        final widgets = $.tester.widgetList(finder);
        debugPrint('Found ${widgets.length} Text widgets:');
        for (final widget in widgets.take(10)) {
          // Limit to first 10 to avoid spam
          if (widget is Text && widget.data != null) {
            debugPrint('  Text: "${widget.data}"');
          }
        }
      } catch (e) {
        debugPrint('Could not enumerate Text widgets: $e');
      }

      fail(
        'API call did not complete within timeout. Current UI state unknown.',
      );
    }

    debugPrint('API call completed after $attempts seconds');

    // First, check for error messages
    if ($('Error:').exists) {
      // If we found an error message, this is a test failure
      fail('SDK returned an error');
    }

    // If no error, verify that either actions are shown or a "No actions" message is displayed
    // This makes the test resilient regardless of what the backend returns
    var actionsVisible = false;

    // Check for actions more broadly - look for any text containing "Action"
    if ($('Action').exists) {
      actionsVisible = true;
    } else if ($('No actions available').exists) {
      actionsVisible = true;
    }

    // Verify that either we have actions or a no actions message
    expect(
      actionsVisible,
      isTrue,
      reason:
          'Either actions or "No actions available" message should be visible. '
          'Check if API call completed successfully and UI updated correctly.',
    );
  });
}
