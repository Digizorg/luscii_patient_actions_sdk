package nl.digizorg.errors

enum class LusciiFlutterSdkError(val code: String, val message: String) {
    UNKNOWN("0", "Unknown error"),
    INVALID_ARGUMENTS("1", "Invalid arguments"),
    INVALID_API_KEY("2", "Invalid API Key"),
    UNAUTHORIZED("3", "Unauthorized"),
    NOT_INITIALIZED("4", "Luscii SDK not initialized"),
}