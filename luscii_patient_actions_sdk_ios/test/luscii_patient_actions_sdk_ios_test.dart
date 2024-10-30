import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_ios/luscii_patient_actions_sdk_ios.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LusciiPatientActionsSdkIOS', () {
    const kPlatformName = 'iOS';
    late LusciiPatientActionsSdkIOS lusciiPatientActionsSdk;
    late List<MethodCall> log;

    setUp(() async {
      lusciiPatientActionsSdk = LusciiPatientActionsSdkIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(lusciiPatientActionsSdk.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
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

    // test('getPlatformName returns correct name', () async {
    //   final name = await lusciiPatientActionsSdk.getPlatformName();
    //   expect(
    //     log,
    //     <Matcher>[isMethodCall('getPlatformName', arguments: null)],
    //   );
    //   expect(name, equals(kPlatformName));
    // });
  });
}
