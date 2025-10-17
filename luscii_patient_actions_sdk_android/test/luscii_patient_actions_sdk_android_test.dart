import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_android/luscii_patient_actions_sdk_android.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LusciiPatientActionsSdkAndroid', () {
    late LusciiPatientActionsSdkAndroid lusciiPatientActionsSdk;
    late List<MethodCall> log;
    final mockActions = [
      {'id': 'action1', 'name': 'Action 1', 'description': 'First action'},
      {'id': 'action2', 'name': 'Action 2', 'description': 'Second action'},
    ];

    setUp(() async {
      lusciiPatientActionsSdk = LusciiPatientActionsSdkAndroid();
      log = <MethodCall>[];

      // Set up method channel mock
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(lusciiPatientActionsSdk.methodChannel, (
            methodCall,
          ) async {
            log.add(methodCall);
            switch (methodCall.method) {
              case 'initialize':
                return null;
              case 'authenticate':
                return null;
              case 'getTodayActions':
                return mockActions;
              case 'launchAction':
                return null;
              default:
                return null;
            }
          });
    });

    test('can be registered', () {
      LusciiPatientActionsSdkAndroid.registerWith();
      expect(
        LusciiPatientActionsSdkPlatform.instance,
        isA<LusciiPatientActionsSdkAndroid>(),
      );
    });

    test('initialize sends correct method call with parameters', () async {
      // Test with default value
      await lusciiPatientActionsSdk.initialize();

      expect(log, hasLength(1));
      expect(log.first.method, 'initialize');
      expect(log.first.arguments, {'androidDynamicTheming': false});

      // Clear log and test with custom value
      log.clear();
      await lusciiPatientActionsSdk.initialize(androidDynamicTheming: true);

      expect(log, hasLength(1));
      expect(log.first.method, 'initialize');
      expect(log.first.arguments, {'androidDynamicTheming': true});
    });

    test('authenticate sends correct method call', () async {
      const apiKey = 'test-api-key';
      await lusciiPatientActionsSdk.authenticate(apiKey);

      expect(log, hasLength(1));
      expect(log.first.method, 'authenticate');
      expect(log.first.arguments, apiKey);
    });

    test('getTodayActions returns list of actions', () async {
      final result = await lusciiPatientActionsSdk.getTodayActions();

      expect(log, hasLength(1));
      expect(log.first.method, 'getTodayActions');
      expect(result, equals(mockActions));
    });

    test('getActions throws exception on invalid response', () async {
      // Override the mock to return null instead of a list
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(lusciiPatientActionsSdk.methodChannel, (
            methodCall,
          ) async {
            log.add(methodCall);
            if (methodCall.method == 'getActions') {
              return null;
            }
            return null;
          });

      expect(
        () => lusciiPatientActionsSdk.getTodayActions(),
        throwsA(isA<LusciiSdkException>()),
      );
    });

    test('launchAction sends correct method call', () async {
      const actionId = 'action1';
      await lusciiPatientActionsSdk.launchAction(actionId);

      expect(log, hasLength(1));
      expect(log.first.method, 'launchAction');
      expect(log.first.arguments, actionId);
    });

    test('actionFlowStream returns a Stream', () async {
      final stream = lusciiPatientActionsSdk.actionFlowStream();
      expect(stream, isA<Stream<Map<String, dynamic>>>());
    });
  });
}
