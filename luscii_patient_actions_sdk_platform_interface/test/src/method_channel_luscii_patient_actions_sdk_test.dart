import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/src/method_channel_luscii_patient_actions_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelLusciiPatientActionsSdk', () {
    late MethodChannelLusciiPatientActionsSdk methodChannel;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannel = MethodChannelLusciiPatientActionsSdk();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel.methodChannel, (
            methodCall,
          ) async {
            log.add(methodCall);
            switch (methodCall.method) {
              case 'initialize':
                return null;
              case 'authenticate':
                return null;
              case 'logout':
                return null;
              case 'getTodayActions':
                return <dynamic>['action1', 'action2'];
              case 'getSelfCareActions':
                return <dynamic>['selfCare1', 'selfCare2'];
              case 'launchAction':
                return null;
              default:
                return null;
            }
          });
    });

    tearDown(log.clear);

    group('initialize', () {
      test('calls method channel with correct default arguments', () async {
        await methodChannel.initialize();

        expect(log, hasLength(1));
        expect(log.first.method, 'initialize');
        expect(log.first.arguments, <String, dynamic>{
          'useDynamicColors': false,
          'iOSEnvironment': 'production',
        });
      });

      test('calls method channel with custom arguments', () async {
        await methodChannel.initialize(
          androidDynamicTheming: true,
          iOSEnvironment: LusciiEnvironment.acceptance,
        );

        expect(log, hasLength(1));
        expect(log.first.method, 'initialize');
        expect(log.first.arguments, <String, dynamic>{
          'useDynamicColors': true,
          'iOSEnvironment': 'acceptance',
        });
      });

      test('throws PlatformException on failure', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              throw PlatformException(code: 'ERROR', message: 'init failed');
            });

        expect(
          () => methodChannel.initialize(),
          throwsA(isA<PlatformException>()),
        );
      });
    });

    group('authenticate', () {
      test('calls method channel with the API key', () async {
        await methodChannel.authenticate('test-api-key');

        expect(log, hasLength(1));
        expect(log.first.method, 'authenticate');
        expect(log.first.arguments, 'test-api-key');
      });

      test('throws PlatformException on failure', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              throw PlatformException(code: 'ERROR', message: 'auth failed');
            });

        expect(
          () => methodChannel.authenticate('test-api-key'),
          throwsA(isA<PlatformException>()),
        );
      });
    });

    group('logout', () {
      test('calls method channel without arguments', () async {
        await methodChannel.logout();

        expect(log, hasLength(1));
        expect(log.first.method, 'logout');
        expect(log.first.arguments, isNull);
      });

      test('throws PlatformException on failure', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              throw PlatformException(code: 'ERROR', message: 'logout failed');
            });

        expect(() => methodChannel.logout(), throwsA(isA<PlatformException>()));
      });
    });

    group('getTodayActions', () {
      test('returns list of actions', () async {
        final actions = await methodChannel.getTodayActions();

        expect(log, hasLength(1));
        expect(log.first.method, 'getTodayActions');
        expect(actions, ['action1', 'action2']);
      });

      test('throws LusciiSdkException when response is null', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              return null;
            });

        expect(
          () => methodChannel.getTodayActions(),
          throwsA(isA<LusciiSdkException>()),
        );
      });
    });

    group('getSelfCareActions', () {
      test('returns list of actions', () async {
        final actions = await methodChannel.getSelfCareActions();

        expect(log, hasLength(1));
        expect(log.first.method, 'getSelfCareActions');
        expect(actions, ['selfCare1', 'selfCare2']);
      });

      test('throws LusciiSdkException when response is null', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              return null;
            });

        expect(
          () => methodChannel.getSelfCareActions(),
          throwsA(isA<LusciiSdkException>()),
        );
      });
    });

    group('getExtraActions', () {
      test('returns list of actions', () async {
        final actions = await methodChannel.getExtraActions();

        expect(log, hasLength(1));
        // Note: getExtraActions() currently invokes 'getSelfCareActions'
        // on the method channel — this appears to be a bug in the
        // implementation, but we test the actual behaviour here.
        expect(log.first.method, 'getSelfCareActions');
        expect(actions, ['selfCare1', 'selfCare2']);
      });

      test('throws LusciiSdkException when response is null', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              return null;
            });

        expect(
          () => methodChannel.getExtraActions(),
          throwsA(isA<LusciiSdkException>()),
        );
      });
    });

    group('launchAction', () {
      test('calls method channel with the action ID', () async {
        await methodChannel.launchAction('action-123');

        expect(log, hasLength(1));
        expect(log.first.method, 'launchAction');
        expect(log.first.arguments, 'action-123');
      });

      test('throws PlatformException on failure', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel.methodChannel, (
              methodCall,
            ) async {
              throw PlatformException(code: 'ERROR', message: 'launch failed');
            });

        expect(
          () => methodChannel.launchAction('action-123'),
          throwsA(isA<PlatformException>()),
        );
      });
    });
  });
}
