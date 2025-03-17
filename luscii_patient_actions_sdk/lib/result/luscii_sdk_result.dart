/// The result of a Luscii request.
sealed class LusciiSdkResult<S, LusciiSdkError> {
  const LusciiSdkResult();
}

/// The result of a Luscii request that was successful.
final class LusciiSdkSuccess<S, LusciiSdkError>
    extends LusciiSdkResult<S, LusciiSdkError> {
  /// Creates a new [LusciiSdkSuccess] with the given [value].
  const LusciiSdkSuccess(this.value);

  /// The value of the successful result.
  final S value;
}

/// The result of a Luscii request that failed.
final class LusciiSdkFailure<S, LusciiSdkError>
    extends LusciiSdkResult<S, LusciiSdkError> {
  /// Creates a new [LusciiSdkFailure] with the given [exception].
  const LusciiSdkFailure(this.exception);

  /// The exception that caused the request to fail.
  final LusciiSdkError exception;
}

/// This class is used when the SDK returns no response.
/// It's similar to the `void` type
class LusciiSdkNoResponse {
  /// Creates a new [LusciiSdkNoResponse].
  const LusciiSdkNoResponse();
}
