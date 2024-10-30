import 'package:luscii_patient_actions_sdk/model/luscii_launchable_status.dart';

/// A Luscii action coming from the Luscii SDK.
class LusciiAction {
  /// Creates a new [LusciiAction] with the given [id], [name],
  /// [launchableStatus], and [isLaunchable].
  LusciiAction({
    required this.id,
    required this.name,
    required this.launchableStatus,
    required this.isLaunchable,
    this.icon,
    this.completedAt,
  });

  /// Creates a new [LusciiAction] from the given [map].
  factory LusciiAction.fromMap(Map<dynamic, dynamic> map) {
    // Assign values to explicitly typed variables
    final id = map['id'] as String?;
    final name = map['name'] as String?;
    final icon = map['icon'] as String?;
    final isLaunchable = map['isLaunchable'] as bool?;
    final launchableStatus = map['launchableStatus'] as String?;

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

    return LusciiAction(
      id: id,
      name: name,
      icon: icon,
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['completedAt'] as num).toInt() * 1000,
            )
          : null,
      launchableStatus: _parseLaunchableStatus(launchableStatus),
      isLaunchable: isLaunchable,
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
  final LusciiLaunchableStatus launchableStatus;

  /// Whether the action is launchable.
  final bool isLaunchable;

  // Helper method to parse the launchableStatus
  static LusciiLaunchableStatus _parseLaunchableStatus(String status) {
    if (status == 'launchable') {
      return LaunchableStatusLaunchable();
    }

    final date = _parseDateFromStatus(status);
    if (status.startsWith('completed:')) {
      return LaunchableStatusCompleted(date);
    } else if (status.startsWith('after:')) {
      return LaunchableStatusAfter(date);
    } else if (status.startsWith('before:')) {
      return LaunchableStatusBefore(date);
    }
    throw Exception('Unknown LaunchableStatus: $status');
  }

  static DateTime _parseDateFromStatus(String status) {
    final timestamp = int.parse(status.split(':')[1]);
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}
