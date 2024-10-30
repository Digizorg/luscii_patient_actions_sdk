import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/src/method_channel_luscii_patient_actions_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelLusciiPatientActionsSdk', () {
    late MethodChannelLusciiPatientActionsSdk methodChannel;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannel = MethodChannelLusciiPatientActionsSdk();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannel.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    // test('getPlatformName', () async {
    //   final platformName = await methodChannel.getPlatformName();
    //   expect(
    //     log,
    //     <Matcher>[isMethodCall('getPlatformName', arguments: null)],
    //   );
    //   expect(platformName, equals(kPlatformName));
    // });
  });
}
