import 'package:luscii_patient_actions_sdk_platform_interface/error/luscii_sdk_exception.dart';

/// The response of a Luscii action.
class LusciiActionResponse {
  /// Creates a new [LusciiActionResponse] with the
  /// given [actionId] and [status].
  LusciiActionResponse({
    required this.actionId,
    required this.status,
  });

  /// Creates a new [LusciiActionResponse] from a map.
  factory LusciiActionResponse.fromMap(Map<dynamic, dynamic> map) {
    // Assign values to explicitly typed variables
    final actionId = map['actionID'] as String?;
    final status = map['status'] as String?;

    // Check for required fields and their types
    if (actionId == null) {
      throw ArgumentError(
        "Expected 'actionId' to be a non-null String, but got "
        // ignore: avoid_dynamic_calls
        "${map['actionId']?.runtimeType}",
      );
    }
    if (status == null) {
      throw ArgumentError(
        "Expected 'status' to be a non-null String, but got "
        // ignore: avoid_dynamic_calls
        "${map['status']?.runtimeType}",
      );
    }

    if (status.contains('error')) {
      throw LusciiSdkException(reason: status);
    }

    return LusciiActionResponse(
      actionId: actionId,
      status: status == 'completed'
          ? LusciiActionResponseStatus.completed
          : LusciiActionResponseStatus.cancelled,
    );
  }

  /// The ID of the action.
  final String actionId;

  /// The status of the action.
  final LusciiActionResponseStatus status;
}

/// The status of a Luscii action response.
enum LusciiActionResponseStatus {
  /// The action is completed
  completed,

  /// The action is cancelled
  cancelled,
}
