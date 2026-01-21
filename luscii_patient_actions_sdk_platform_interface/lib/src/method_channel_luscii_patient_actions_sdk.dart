import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

/// An implementation of [LusciiPatientActionsSdkPlatform] that uses method
/// channels.
class MethodChannelLusciiPatientActionsSdk
    extends LusciiPatientActionsSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('luscii_patient_actions_sdk');

  /// The event channel used to listen to the native platform.
  @visibleForTesting
  final eventChannel = const EventChannel('luscii_patient_actions_sdk/events');

  @override
  Future<void> initialize({
    bool androidDynamicTheming = false,
    LusciiEnvironment iOSEnvironment = LusciiEnvironment.production,
  }) async {
    await methodChannel.invokeMethod<void>('initialize', <String, dynamic>{
      'androidDynamicTheming': androidDynamicTheming,
      'iOSEnvironment': iOSEnvironment.name,
    });
  }

  @override
  Future<void> authenticate(String apiKey) async {
    await methodChannel.invokeMethod<Map<String, dynamic>>(
      'authenticate',
      apiKey,
    );
  }

  @override
  Future<List<dynamic>> getTodayActions() async {
    final actions = await methodChannel.invokeMethod<List<dynamic>>(
      'getTodayActions',
    );

    if (actions is! List) {
      throw LusciiSdkException(reason: 'Invalid response from native platform');
    }
    return actions;
  }

  @override
  Future<List<dynamic>> getSelfcareActions() async {
    final actions = await methodChannel.invokeMethod<List<dynamic>>(
      'getSelfcareActions',
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
