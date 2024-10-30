import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_android/luscii_patient_actions_sdk_android.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LusciiPatientActionsSdkAndroid', () {
    const kPlatformName = 'Android';
    late LusciiPatientActionsSdkAndroid lusciiPatientActionsSdk;
    late List<MethodCall> log;

    setUp(() async {
      lusciiPatientActionsSdk = LusciiPatientActionsSdkAndroid();

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
      LusciiPatientActionsSdkAndroid.registerWith();
      expect(
        LusciiPatientActionsSdkPlatform.instance,
        isA<LusciiPatientActionsSdkAndroid>(),
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
