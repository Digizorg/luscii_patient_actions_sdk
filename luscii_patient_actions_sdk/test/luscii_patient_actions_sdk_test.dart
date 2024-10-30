import 'package:flutter_test/flutter_test.dart';
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

    setUp(() {
      lusciiPatientActionsSdkPlatform = MockLusciiPatientActionsSdkPlatform();
      LusciiPatientActionsSdkPlatform.instance =
          lusciiPatientActionsSdkPlatform;
    });

    // group('getPlatformName', () {
    //   test('returns correct name when platform implementation exists',
    //       () async {
    //     const platformName = '__test_platform__';
    //     when(
    //       () => lusciiPatientActionsSdkPlatform.getPlatformName(),
    //     ).thenAnswer((_) async => platformName);

    //     final actualPlatformName = await getPlatformName();
    //     expect(actualPlatformName, equals(platformName));
    //   });

    //   test('throws exception when platform implementation is missing',
    //       () async {
    //     when(
    //       () => lusciiPatientActionsSdkPlatform.getPlatformName(),
    //     ).thenAnswer((_) async => null);

    //     expect(getPlatformName, throwsException);
    //   });
    // });
  });
}
