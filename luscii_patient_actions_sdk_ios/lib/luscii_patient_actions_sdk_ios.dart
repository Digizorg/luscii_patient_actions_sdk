import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

/// The iOS implementation of [LusciiPatientActionsSdkPlatform].
class LusciiPatientActionsSdkIOS extends LusciiPatientActionsSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('luscii_patient_actions_sdk_ios');

  /// The event channel used to listen to the native platform.
  @visibleForTesting
  final eventChannel = const EventChannel(
    'luscii_patient_actions_sdk_ios/events',
  );

  /// Registers this class as the default
  /// instance of [LusciiPatientActionsSdkPlatform]
  static void registerWith() {
    LusciiPatientActionsSdkPlatform.instance = LusciiPatientActionsSdkIOS();
  }

  @override
  Future<void> initialize({bool androidDynamicTheming = false}) async {
    // iOS does not support dynamic theming
    // and does not require initialization
    return Future.value();
  }

  @override
  Future<void> authenticate(String apiKey) async {
    await methodChannel.invokeMethod<Map<String, dynamic>>(
      'authenticate',
      apiKey,
    );
  }

  @override
  Future<List<dynamic>> getActions() async {
    final actions = await methodChannel.invokeMethod<List<dynamic>>(
      'getActions',
    );

    if (actions is! List) {
      throw LusciiSdkException(reason: 'Invalid response from native platform');
    }
    return actions;
  }

  @override
  Future<void> launchAction(String actionId) async {
    await methodChannel.invokeMethod<Map<String, dynamic>>(
      'launchAction',
      actionId,
    );
  }

  @override
  Stream<Map<String, dynamic>> actionFlowStream() {
    return eventChannel.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event as Map);
    });
  }
}
