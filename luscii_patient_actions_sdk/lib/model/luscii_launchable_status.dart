/// The status of a Luscii launchable.
sealed class LusciiLaunchableStatus {}

/// The Luscii launchable is launchable.
class LaunchableStatusLaunchable extends LusciiLaunchableStatus {}

/// The Luscii launchable is completed.
class LaunchableStatusCompleted extends LusciiLaunchableStatus {
  /// Creates a new [LaunchableStatusCompleted] with the given [completedAt].
  LaunchableStatusCompleted(this.completedAt);

  /// The date and time when the Luscii launchable was completed.
  final DateTime completedAt;
}

/// The Luscii can be launched before the given date.
class LaunchableStatusBefore extends LusciiLaunchableStatus {
  /// Creates a new [LaunchableStatusBefore] with the given [beforeDate].
  LaunchableStatusBefore(this.beforeDate);

  /// The date and time before which the Luscii launchable can be launched.
  final DateTime beforeDate;
}

/// The Luscii can be launched after the given date.
class LaunchableStatusAfter extends LusciiLaunchableStatus {
  /// Creates a new [LaunchableStatusAfter] with the given [afterDate].
  LaunchableStatusAfter(this.afterDate);

  /// The date and time after which the Luscii launchable can be launched.
  final DateTime afterDate;
}
