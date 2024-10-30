import 'package:flutter_test/flutter_test.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

class LusciiPatientActionsSdkMock extends LusciiPatientActionsSdkPlatform {
  @override
  Future<void> authenticate(String apiKey) {
    // Successful authentication
    return Future.value();
  }

  @override
  Future<List<dynamic>> getActions() {
    return Future.value([
      {
        'icon': 'https://example.com/icon.png',
        'completedAt': null,
        'id': '3F2C7A8D-1B4E-3DF9-C248-95E0BCF741D6',
        'launchableStatus': 'launchable',
        'isLaunchable': true,
        'name': 'Temperature',
      }
    ]);
  }

  @override
  Future<void> launchAction(String actionId) {
    return Future.value();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('LusciiPatientActionsSdkPlatformInterface', () {
    late LusciiPatientActionsSdkPlatform lusciiPatientActionsSdkPlatform;

    setUp(() {
      lusciiPatientActionsSdkPlatform = LusciiPatientActionsSdkMock();
      LusciiPatientActionsSdkPlatform.instance =
          lusciiPatientActionsSdkPlatform;
    });

    group('authenticate', () {
      test('should authenticate the user with the given token', () async {
        await lusciiPatientActionsSdkPlatform.authenticate('apiKey');
      });

      test('should get the actions for the authenticated user', () async {
        final actions = await lusciiPatientActionsSdkPlatform.getActions();
        expect(actions, isNotEmpty);
      });

      test('should launch the action with the given ID', () async {
        await lusciiPatientActionsSdkPlatform.launchAction(
          '3F2C7A8D-1B4E-3DF9-C248-95E0BCF741D6',
        );
      });
    });
  });
}
