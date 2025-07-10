import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_example/main.dart' as app;
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Get actions flow test', ($) async {
    await app.main();
    await $.pumpAndSettle();

    // Verify the app started correctly
    expect($('LusciiPatientActionsSdk Example'), findsOneWidget);
    expect($('Get actions'), findsOneWidget);

    // Tap on the "Get actions" button
    await $.tap(find.text('Get actions'));

    // Wait for the API call to complete and UI to update
    await $.pumpAndSettle();
    await Future<void>.delayed(
      const Duration(seconds: 5),
    ); // Give API call time to complete

    // First, check for error messages
    // if there's an error, the test should fail
    final errorFinder = find.textContaining('Error:', findRichText: true);
    if (errorFinder.evaluate().isNotEmpty) {
      // If we found an error message, this is a test failure
      fail('SDK returned an error');
    }

    // If no error, verify that either actions
    // are shown or a "No actions" message is displayed
    // This makes the test resilient regardless of what the backend returns
    var actionsVisible = false;

    try {
      // Check if any action is visible
      // "Action " followed by some text
      // should be present if actions were loaded
      final actionFinder = find.textContaining('Action ', findRichText: true);
      actionsVisible = actionFinder.evaluate().isNotEmpty;
      if (!actionsVisible) {
        // If no actions are found, check for the "No actions available" message
        final noActionsFinder = find.text('No actions available');
        actionsVisible = noActionsFinder.evaluate().isNotEmpty;
      }
    } catch (_) {
      // If no actions are found, then the
      // "No actions available" message should be displayed
      actionsVisible = find.text('No actions available').evaluate().isNotEmpty;
    }

    // Verify that either we have actions or a no actions message
    expect(
      actionsVisible,
      isTrue,
      reason:
          'Either actions or No actions available message should be visible',
    );
  });
}
