import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

/// The Android implementation of [LusciiPatientActionsSdkPlatform].
class LusciiPatientActionsSdkAndroid extends LusciiPatientActionsSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('luscii_patient_actions_sdk_android');

  /// Registers this class as the default
  /// instance of [LusciiPatientActionsSdkPlatform]
  static void registerWith() {
    LusciiPatientActionsSdkPlatform.instance = LusciiPatientActionsSdkAndroid();
  }

  @override
  Future<void> authenticate(String apiKey) {
    // TODO: implement authenticate
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getActions() {
    // TODO: implement getActions
    throw UnimplementedError();
  }

  @override
  Future<void> launchAction(String actionId) {
    // TODO: implement launchAction
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>> actionFlowStream() {
    // TODO: implement actionFlowStream
    throw UnimplementedError();
  }
}
