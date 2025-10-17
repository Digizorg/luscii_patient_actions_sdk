import 'package:luscii_patient_actions_sdk/model/luscii_sdk_launchable_status.dart';

/// A Luscii action coming from the Luscii SDK.
class LusciiSdkAction {
  /// Creates a new [LusciiSdkAction] with the given [id], [name],
  /// [launchableStatus], and [isLaunchable].
  LusciiSdkAction({
    required this.id,
    required this.name,
    required this.launchableStatus,
    required this.isLaunchable,
    this.icon,
    this.completedAt,
    this.isPlanned,
    this.isSelfCare,
    this.isExtra,
  });

  /// Creates a new [LusciiSdkAction] from the given [map].
  factory LusciiSdkAction.fromMap(Map<dynamic, dynamic> map) {
    // Assign values to explicitly typed variables
    final id = map['id'] as String?;
    final name = map['name'] as String?;
    final icon = map['icon'] as String?;
    final isLaunchable = map['isLaunchable'] as bool?;
    final launchableStatus = map['launchableStatus'] as String?;
    final isPlanned = map['isPlanned'] as bool?;
    final isSelfCare = map['isSelfCare'] as bool?;
    final isExtra = map['isExtra'] as bool?;

    // Check for required fields and their types
    if (id == null) {
      throw ArgumentError(
        "Expected 'id' to be a non-null String, but got "
        // ignore: avoid_dynamic_calls
        "${map['id']?.runtimeType}",
      );
    }
    if (name == null) {
      throw ArgumentError(
        "Expected 'name' to be a non-null String, but got "
        // ignore: avoid_dynamic_calls
        "${map['name']?.runtimeType}",
      );
    }
    if (icon == null) {
      throw ArgumentError(
        "Expected 'icon' to be a non-null String, but got "
        // ignore: avoid_dynamic_calls
        "${map['icon']?.runtimeType}",
      );
    }
    if (isLaunchable == null) {
      throw ArgumentError(
        "Expected 'isLaunchable' to be a non-null bool, but got "
        // ignore: avoid_dynamic_calls
        "${map['isLaunchable']?.runtimeType}",
      );
    }
    if (launchableStatus == null) {
      throw ArgumentError(
        "Expected 'launchableStatus' to be a non-null String, but got "
        // ignore: avoid_dynamic_calls
        "${map['launchableStatus']?.runtimeType}",
      );
    }

    return LusciiSdkAction(
      id: id,
      name: name,
      icon: icon,
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['completedAt'] as double).toInt() * 1000,
            )
          : null,
      launchableStatus: _parseLaunchableStatus(launchableStatus),
      isLaunchable: isLaunchable,
      isPlanned: isPlanned,
      isSelfCare: isSelfCare,
      isExtra: isExtra,
    );
  }

  /// The unique identifier of the action.
  final String id;

  /// The name of the action.
  final String name;

  /// The icon of the action.
  final String? icon;

  /// The date and time when the action was completed.
  final DateTime? completedAt;

  /// The status of the action.
  final LusciiSdkLaunchableStatus launchableStatus;

  /// Whether the action is launchable.
  final bool isLaunchable;

  /// Whether this action is planned.
  /// Note that this only works on Android
  final bool? isPlanned;

  /// Whether this is a self-care action, meaning it was returned
  /// from Luscii.getSelfCareActions.
  /// Note that isPlanned can still be true if isSelfCare is true.
  /// Note that this only works on Android
  final bool? isSelfCare;

  /// Whether this is a planned action that was completed as
  /// an extra self-care action.
  /// Note that this only works on Android
  final bool? isExtra;

  // Helper method to parse the launchableStatus
  static LusciiSdkLaunchableStatus _parseLaunchableStatus(String status) {
    if (status == 'launchable') {
      return LaunchableSdkStatusLaunchable();
    }

    final date = _parseDateFromStatus(status);
    if (status.startsWith('completed:')) {
      return LaunchableSdkStatusCompleted(date);
    } else if (status.startsWith('after:')) {
      return LaunchableSdkStatusAfter(date);
    } else if (status.startsWith('before:')) {
      return LaunchableSdkStatusBefore(date);
    }
    throw Exception('Unknown LaunchableStatus: $status');
  }

  static DateTime _parseDateFromStatus(String status) {
    final timestamp = double.parse(status.split(':')[1]).toInt();
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}
