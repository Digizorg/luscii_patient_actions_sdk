import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk/error/luscii_sdk_error.dart';
import 'package:luscii_patient_actions_sdk/luscii_patient_actions_sdk.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_action.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_action_response.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_launchable_status.dart';
import 'package:luscii_patient_actions_sdk/result/luscii_sdk_result.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLusciiPatientActionsSdkPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements LusciiPatientActionsSdkPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LusciiPatientActionsSdk', () {
    late LusciiPatientActionsSdkPlatform lusciiPatientActionsSdkPlatform;
    final mockActions = [
      {
        'id': 'action1',
        'name': 'Action 1',
        'icon': 'icon1',
        'isLaunchable': true,
        'launchableStatus': 'launchable',
        'completedAt': 1720000000.0, // Using a proper timestamp as a double
      },
      {
        'id': 'action2',
        'name': 'Action 2',
        'icon': 'icon2',
        'isLaunchable': false,
        'launchableStatus': 'completed:1720000000',
        'completedAt': null,
      },
    ];

    final mockEventData = {'actionID': 'action1', 'status': 'completed'};

    setUp(() {
      lusciiPatientActionsSdkPlatform = MockLusciiPatientActionsSdkPlatform();
      LusciiPatientActionsSdkPlatform.instance =
          lusciiPatientActionsSdkPlatform;
    });

    test('initialize - success', () async {
      when(
        () => lusciiPatientActionsSdkPlatform.initialize(
          androidDynamicTheming: any(named: 'androidDynamicTheming'),
        ),
      ).thenAnswer((_) => Future.value());

      final result = await initialize(androidDynamicTheming: true);

      verify(
        () => lusciiPatientActionsSdkPlatform.initialize(
          androidDynamicTheming: true,
        ),
      ).called(1);

      expect(
        result,
        isA<LusciiSdkSuccess<LusciiSdkNoResponse, LusciiSdkError>>(),
      );
      final success =
          result as LusciiSdkSuccess<LusciiSdkNoResponse, LusciiSdkError>;
      expect(success.value, isA<LusciiSdkNoResponse>());
    });

    test('initialize - platform exception', () async {
      when(
        () => lusciiPatientActionsSdkPlatform.initialize(
          androidDynamicTheming: any(named: 'androidDynamicTheming'),
        ),
      ).thenThrow(PlatformException(code: '1', message: 'Invalid arguments'));

      final result = await initialize();

      expect(
        result,
        isA<LusciiSdkFailure<LusciiSdkNoResponse, LusciiSdkError>>(),
      );
      final failure =
          result as LusciiSdkFailure<LusciiSdkNoResponse, LusciiSdkError>;
      expect(failure.exception.type, LusciiSdkErrorType.invalidArguments);
      expect(failure.exception.reason, 'Invalid arguments');
    });

    test('authenticate - success', () async {
      const apiKey = 'test-api-key';

      when(
        () => lusciiPatientActionsSdkPlatform.authenticate(any()),
      ).thenAnswer((_) => Future.value());

      final result = await authenticate(apiKey);

      verify(
        () => lusciiPatientActionsSdkPlatform.authenticate(apiKey),
      ).called(1);

      expect(
        result,
        isA<LusciiSdkSuccess<LusciiSdkNoResponse, LusciiSdkError>>(),
      );
      final success =
          result as LusciiSdkSuccess<LusciiSdkNoResponse, LusciiSdkError>;
      expect(success.value, isA<LusciiSdkNoResponse>());
    });

    test('authenticate - platform exception', () async {
      const apiKey = 'invalid-api-key';

      when(
        () => lusciiPatientActionsSdkPlatform.authenticate(any()),
      ).thenThrow(PlatformException(code: '2', message: 'Invalid API key'));

      final result = await authenticate(apiKey);

      expect(
        result,
        isA<LusciiSdkFailure<LusciiSdkNoResponse, LusciiSdkError>>(),
      );
      final failure =
          result as LusciiSdkFailure<LusciiSdkNoResponse, LusciiSdkError>;
      expect(failure.exception.type, LusciiSdkErrorType.invalidApiKey);
      expect(failure.exception.reason, 'Invalid API key');
    });

    test('getActions - success', () async {
      when(
        () => lusciiPatientActionsSdkPlatform.getActions(),
      ).thenAnswer((_) => Future.value(mockActions));

      final result = await getActions();

      verify(() => lusciiPatientActionsSdkPlatform.getActions()).called(1);

      expect(
        result,
        isA<LusciiSdkSuccess<List<LusciiSdkAction>, LusciiSdkError>>(),
      );
      final success =
          result as LusciiSdkSuccess<List<LusciiSdkAction>, LusciiSdkError>;
      expect(success.value, isA<List<LusciiSdkAction>>());
      expect(success.value.length, 2);

      // Verify first action
      expect(success.value[0].id, 'action1');
      expect(success.value[0].name, 'Action 1');
      expect(success.value[0].icon, 'icon1');
      expect(success.value[0].isLaunchable, true);
      expect(
        success.value[0].launchableStatus,
        isA<LaunchableSdkStatusLaunchable>(),
      );
      expect(success.value[0].completedAt, isNotNull);

      // Verify second action
      expect(success.value[1].id, 'action2');
      expect(success.value[1].name, 'Action 2');
      expect(success.value[1].icon, 'icon2');
      expect(success.value[1].isLaunchable, false);
      expect(
        success.value[1].launchableStatus,
        isA<LaunchableSdkStatusCompleted>(),
      );
      expect(success.value[1].completedAt, isNull);
    });

    test('getActions - LusciiSdkException', () async {
      when(() => lusciiPatientActionsSdkPlatform.getActions()).thenThrow(
        LusciiSdkException(reason: 'Invalid response from native platform'),
      );

      final result = await getActions();

      expect(
        result,
        isA<LusciiSdkFailure<List<LusciiSdkAction>, LusciiSdkError>>(),
      );
      final failure =
          result as LusciiSdkFailure<List<LusciiSdkAction>, LusciiSdkError>;
      expect(failure.exception.type, LusciiSdkErrorType.invalidResponse);
      expect(failure.exception.reason, 'Invalid response from native platform');
    });

    test('getActions - platform exception', () async {
      when(
        () => lusciiPatientActionsSdkPlatform.getActions(),
      ).thenThrow(PlatformException(code: '3', message: 'Unauthorized'));

      final result = await getActions();

      expect(
        result,
        isA<LusciiSdkFailure<List<LusciiSdkAction>, LusciiSdkError>>(),
      );
      final failure =
          result as LusciiSdkFailure<List<LusciiSdkAction>, LusciiSdkError>;
      expect(failure.exception.type, LusciiSdkErrorType.unauthorized);
      expect(failure.exception.reason, 'Unauthorized');
    });

    test('launchAction - success', () async {
      const actionId = 'action1';

      when(
        () => lusciiPatientActionsSdkPlatform.launchAction(any()),
      ).thenAnswer((_) => Future.value());

      final result = await launchAction(actionId);

      verify(
        () => lusciiPatientActionsSdkPlatform.launchAction(actionId),
      ).called(1);

      expect(
        result,
        isA<LusciiSdkSuccess<LusciiSdkNoResponse, LusciiSdkError>>(),
      );
      final success =
          result as LusciiSdkSuccess<LusciiSdkNoResponse, LusciiSdkError>;
      expect(success.value, isA<LusciiSdkNoResponse>());
    });

    test('launchAction - platform exception', () async {
      const actionId = 'invalid-action';

      when(
        () => lusciiPatientActionsSdkPlatform.launchAction(any()),
      ).thenThrow(PlatformException(code: '1', message: 'Invalid action ID'));

      final result = await launchAction(actionId);

      expect(
        result,
        isA<LusciiSdkFailure<LusciiSdkNoResponse, LusciiSdkError>>(),
      );
      final failure =
          result as LusciiSdkFailure<LusciiSdkNoResponse, LusciiSdkError>;
      expect(failure.exception.type, LusciiSdkErrorType.invalidArguments);
      expect(failure.exception.reason, 'Invalid action ID');
    });

    test('actionFlowStream - success', () async {
      final streamController = StreamController<Map<String, dynamic>>();

      when(
        () => lusciiPatientActionsSdkPlatform.actionFlowStream(),
      ).thenAnswer((_) => streamController.stream);

      final stream = actionFlowStream();

      // Setup expectation before adding the event
      final expectation = expectLater(
        stream,
        emits(isA<LusciiSdkSuccess<LusciiSdkActionResponse, LusciiSdkError>>()),
      );

      // Add event to the stream
      streamController.add(mockEventData);

      // Wait for the expectation to complete
      await expectation;

      // Clean up
      await streamController.close();
    });

    test('actionFlowStream - error event', () async {
      final streamController = StreamController<Map<String, dynamic>>();
      final errorEventData = {
        'actionID': 'action1',
        'status': 'error: something went wrong',
      };

      when(
        () => lusciiPatientActionsSdkPlatform.actionFlowStream(),
      ).thenAnswer((_) => streamController.stream);

      final stream = actionFlowStream();

      // Setup expectation before adding the event
      final expectation = expectLater(
        stream,
        emits(isA<LusciiSdkFailure<LusciiSdkActionResponse, LusciiSdkError>>()),
      );

      // Add error event to the stream
      streamController.add(errorEventData);

      // Wait for the expectation to complete
      await expectation;

      // Clean up
      await streamController.close();
    });

    test('actionFlowStream - argument error handled correctly', () async {
      final streamController = StreamController<Map<String, dynamic>>();

      when(
        () => lusciiPatientActionsSdkPlatform.actionFlowStream(),
      ).thenAnswer((_) => streamController.stream);

      final stream = actionFlowStream();

      // Since ArgumentError doesn't get directly
      // caught in the actionFlowStream method,
      // we need to use try-catch in our test expectation
      expect(
        () async {
          // Simulate invalid data (missing required field 'actionID')
          streamController.add({'status': 'completed'});
          await for (final _ in stream) {
            break; // Only process the first event
          }
        },
        throwsArgumentError, // This should catch the ArgumentError thrown
      );

      // Clean up
      await streamController.close();
    });

    test('actionFlowStream - LusciiSdkException handled', () async {
      final streamController = StreamController<Map<String, dynamic>>();

      when(
        () => lusciiPatientActionsSdkPlatform.actionFlowStream(),
      ).thenAnswer((_) => streamController.stream);

      final stream = actionFlowStream();

      // Setup expectation for LusciiSdkException
      final expectation = expectLater(
        stream,
        emits(isA<LusciiSdkFailure<LusciiSdkActionResponse, LusciiSdkError>>()),
      );

      // Add data that will cause a LusciiSdkException
      streamController.add({
        'actionID': 'action1',
        'status': 'error: something went wrong',
      });

      // Wait for the expectation to complete
      await expectation;

      // Clean up
      await streamController.close();
    });
  });
}
