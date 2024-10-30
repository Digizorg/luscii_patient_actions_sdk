import 'package:flutter/services.dart';
import 'package:luscii_patient_actions_sdk/error/luscii_sdk_error.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_action.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_action_response.dart';
import 'package:luscii_patient_actions_sdk/result/luscii_result.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';
import 'package:luscii_patient_actions_sdk_platform_interface/luscii_patient_actions_sdk_platform_interface.dart';

LusciiPatientActionsSdkPlatform get _platform =>
    LusciiPatientActionsSdkPlatform.instance;

/// Authenticate the user with the given token.
Future<LusciiResult<LusciiNoResponse, LusciiSdkError>> authenticate(
  String apiKey,
) async {
  try {
    await _platform.authenticate(apiKey);
    return const LusciiSuccess(LusciiNoResponse());
  } on PlatformException catch (e) {
    return LusciiFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Get the actions for the authenticated user.
Future<LusciiResult<List<LusciiAction>, LusciiSdkError>> getActions() async {
  try {
    final actions = await _platform.getActions();
    return LusciiSuccess(
      actions
          .map(
            (action) => LusciiAction.fromMap(action as Map<dynamic, dynamic>),
          )
          .toList(growable: false),
    );
  } on LusciiSdkException catch (_) {
    return LusciiFailure(
      LusciiSdkError(
        LusciiSdkErrorType.invalidResponse,
        'Invalid response from native platform',
      ),
    );
  } on PlatformException catch (e) {
    return LusciiFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Launch the action with the given ID.
Future<LusciiResult<LusciiNoResponse, LusciiSdkError>> launchAction(
  String actionId,
) async {
  try {
    await _platform.launchAction(actionId);
    return const LusciiSuccess(LusciiNoResponse());
  } on PlatformException catch (e) {
    return LusciiFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
  }
}

/// Listen to updates the action stream results.
Stream<LusciiResult<LusciiActionResponse, LusciiSdkError>> actionFlowStream() {
  return _platform.actionFlowStream().map((event) {
    try {
      return LusciiSuccess(
        LusciiActionResponse.fromMap(event as Map<dynamic, dynamic>),
      );
    } on LusciiSdkException catch (e) {
      return LusciiFailure(LusciiSdkError.fromErrorCode('4', e.reason));
    } on PlatformException catch (e) {
      return LusciiFailure(LusciiSdkError.fromErrorCode(e.code, e.message));
    }
  });
}
