import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_ios/luscii_patient_actions_sdk_ios.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LusciiPatientActionsSdkIOS', () {
    late LusciiPatientActionsSdkIOS lusciiPatientActionsSdk;
    late List<MethodCall> log;
    final mockActions = [
      {'id': 'action1', 'name': 'Action 1', 'description': 'First action'},
      {'id': 'action2', 'name': 'Action 2', 'description': 'Second action'},
    ];

    setUp(() async {
      lusciiPatientActionsSdk = LusciiPatientActionsSdkIOS();
      log = <MethodCall>[];

      // Set up method channel mock
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(lusciiPatientActionsSdk.methodChannel, (
            methodCall,
          ) async {
            log.add(methodCall);
            switch (methodCall.method) {
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
      LusciiPatientActionsSdkIOS.registerWith();
      expect(
        LusciiPatientActionsSdkPlatform.instance,
        isA<LusciiPatientActionsSdkIOS>(),
      );
    });

    test('initialize completes successfully', () async {
      await expectLater(lusciiPatientActionsSdk.initialize(), completes);
      // Initialize is a no-op on iOS, so no method call should be logged
      expect(log, isEmpty);
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

    test('getTodayActions throws exception on invalid response', () async {
      // Override the mock to return null instead of a list
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(lusciiPatientActionsSdk.methodChannel, (
            methodCall,
          ) async {
            log.add(methodCall);
            if (methodCall.method == 'getTodayActions') {
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
