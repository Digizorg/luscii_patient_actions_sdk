/// The status of a Luscii launchable.
sealed class LusciiSdkLaunchableStatus {}

/// The Luscii launchable is launchable.
class LaunchableSdkStatusLaunchable extends LusciiSdkLaunchableStatus {}

/// The Luscii launchable is completed.
class LaunchableSdkStatusCompleted extends LusciiSdkLaunchableStatus {
  /// Creates a new [LaunchableSdkStatusCompleted] with the given [completedAt].
  LaunchableSdkStatusCompleted(this.completedAt);

  /// The date and time when the Luscii launchable was completed.
  final DateTime completedAt;
}

/// The Luscii can be launched before the given date.
class LaunchableSdkStatusBefore extends LusciiSdkLaunchableStatus {
  /// Creates a new [LaunchableSdkStatusBefore] with the given [beforeDate].
  LaunchableSdkStatusBefore(this.beforeDate);

  /// The date and time before which the Luscii launchable can be launched.
  final DateTime beforeDate;
}

/// The Luscii can be launched after the given date.
class LaunchableSdkStatusAfter extends LusciiSdkLaunchableStatus {
  /// Creates a new [LaunchableSdkStatusAfter] with the given [afterDate].
  LaunchableSdkStatusAfter(this.afterDate);

  /// The date and time after which the Luscii launchable can be launched.
  final DateTime afterDate;
}
