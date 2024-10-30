/// This class represents an error that occurred while using the Luscii SDK.
class LusciiSdkError {
  /// Creates a new [LusciiSdkError] with the given [type] and [reason].
  LusciiSdkError(this.type, this.reason);

  /// Creates a new [LusciiSdkError] from the given [errorCode] and [reason].
  factory LusciiSdkError.fromErrorCode(String errorCode, String? reason) {
    return LusciiSdkError(LusciiSdkErrorType.fromErrorCode(errorCode), reason);
  }

  /// The type of the error.
  final LusciiSdkErrorType type;

  /// The reason for the error.
  final String? reason;
}

/// The type of a [LusciiSdkError].
enum LusciiSdkErrorType {
  /// An unknown error occurred.
  unknown,

  /// The arguments provided to the SDK were invalid.
  invalidArguments,

  /// The API key provided to the SDK was invalid.
  invalidApiKey,

  /// The user is not authorized to perform the requested action.
  unauthorized,

  /// The response from the SDK was invalid.
  invalidResponse;

  factory LusciiSdkErrorType.fromErrorCode(String errorCode) {
    switch (errorCode) {
      case '1':
        return LusciiSdkErrorType.invalidArguments;
      case '2':
        return LusciiSdkErrorType.invalidApiKey;
      case '3':
        return LusciiSdkErrorType.unauthorized;
      case '4':
        return LusciiSdkErrorType.invalidResponse;
      default:
        return LusciiSdkErrorType.unknown;
    }
  }
}
