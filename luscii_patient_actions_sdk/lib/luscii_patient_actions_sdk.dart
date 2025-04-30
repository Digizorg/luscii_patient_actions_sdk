import 'package:flutter/services.dart';
import 'package:luscii_patient_actions_sdk/error/luscii_sdk_error.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_action.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_action_response.dart';
import 'package:luscii_patient_actions_sdk/result/luscii_sdk_result.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

LusciiPatientActionsSdkPlatform get _platform =>
    LusciiPatientActionsSdkPlatform.instance;

/// Initialize the SDK.
Future<LusciiSdkResult<LusciiSdkNoResponse, LusciiSdkError>> initialize({
  bool androidDynamicTheming = false,
}) async {
  try {
    await _platform.initialize(androidDynamicTheming: androidDynamicTheming);
    return const LusciiSdkSuccess(LusciiSdkNoResponse());
  } on PlatformException catch (e) {
    return LusciiSdkFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Authenticate the user with the given token.
Future<LusciiSdkResult<LusciiSdkNoResponse, LusciiSdkError>> authenticate(
  String apiKey,
) async {
  try {
    await _platform.authenticate(apiKey);
    return const LusciiSdkSuccess(LusciiSdkNoResponse());
  } on PlatformException catch (e) {
    return LusciiSdkFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Get the actions for the authenticated user.
Future<LusciiSdkResult<List<LusciiSdkAction>, LusciiSdkError>>
    getActions() async {
  try {
    final actions = await _platform.getActions();
    return LusciiSdkSuccess(
      actions
          .map(
            (action) =>
                LusciiSdkAction.fromMap(action as Map<dynamic, dynamic>),
          )
          .toList(growable: false),
    );
  } on LusciiSdkException catch (_) {
    return LusciiSdkFailure(
      LusciiSdkError(
        LusciiSdkErrorType.invalidResponse,
        'Invalid response from native platform',
      ),
    );
  } on PlatformException catch (e) {
    return LusciiSdkFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Launch the action with the given ID.
Future<LusciiSdkResult<LusciiSdkNoResponse, LusciiSdkError>> launchAction(
  String actionId,
) async {
  try {
    await _platform.launchAction(actionId);
    return const LusciiSdkSuccess(LusciiSdkNoResponse());
  } on PlatformException catch (e) {
    return LusciiSdkFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Listen to updates the action stream results.
Stream<LusciiSdkResult<LusciiSdkActionResponse, LusciiSdkError>>
    actionFlowStream() {
  return _platform.actionFlowStream().map((event) {
    try {
      return LusciiSdkSuccess(
        LusciiSdkActionResponse.fromMap(event as Map<dynamic, dynamic>),
      );
    } on LusciiSdkException catch (e) {
      return LusciiSdkFailure(LusciiSdkError.fromErrorCode('4', e.reason));
    } on PlatformException catch (e) {
      return LusciiSdkFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
    }
  });
}
