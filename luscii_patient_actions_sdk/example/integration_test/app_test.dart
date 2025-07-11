import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_example/main.dart' as app;
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Get actions flow test', ($) async {
    await app.initApp();
    await $.pumpWidgetAndSettle(const app.MyApp());

    // Verify the app started correctly
    expect($('LusciiPatientActionsSdk Example'), findsOneWidget);
    expect($('Get actions'), findsOneWidget);

    // Tap on the "Get actions" button
    await $('Get actions').tap();

    // Wait for the API call to complete and UI to update
    await Future<void>.delayed(
      const Duration(seconds: 10),
    ); // Give API call time to complete

    // First, check for error messages
    // if there's an error, the test should fail
    if ($('Error:').exists) {
      // If we found an error message, this is a test failure
      fail('SDK returned an error');
    }

    // If no error, verify that either actions
    // are shown or a "No actions" message is displayed
    // This makes the test resilient regardless of what the backend returns
    var actionsVisible = false;

    if ($('Action ').exists) {
      actionsVisible = true;
    } else {
      $('No actions available').exists
          ? actionsVisible = true
          : actionsVisible = false;
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
