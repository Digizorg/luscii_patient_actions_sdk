package nl.digizorg.extensions

import com.luscii.sdk.actions.Action

fun Action.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id.toString(),
        "name" to name,
        "icon" to icon?.toString(), // Convert URL to string
        "completedAt" to completedAt?.toEpochSecond(), // Convert ZonedDateTime to timestamp (seconds since epoch)
        "launchableStatus" to serializeLaunchableStatus(),
        "isLaunchable" to isLaunchable()
    )
}

private fun Action.serializeLaunchableStatus(): String {
    return when (val status = getLaunchableStatus()) {
        is Action.LaunchableStatus.Launchable -> {
            when (status) {
                is Action.LaunchableStatus.CompletedAt -> {
                    val epochSecond = status.date.toEpochSecond()
                    "completed:$epochSecond"
                }
                else -> "launchable"
            }
        }
        is Action.LaunchableStatus.NotLaunchable -> {
            when (status) {
                is Action.LaunchableStatus.LaunchableAfter -> {
                    val epochSecond = status.date.toEpochSecond()
                    "after:$epochSecond"
                }
                is Action.LaunchableStatus.LaunchableBefore -> {
                    val epochSecond = status.date.toEpochSecond()
                    "before:$epochSecond"
                }
                else -> "not_launchable"
            }
        }
        else -> "unknown"
    }
}