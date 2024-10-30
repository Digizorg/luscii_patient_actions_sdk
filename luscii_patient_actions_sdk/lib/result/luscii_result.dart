/// The result of a Luscii request.
sealed class LusciiResult<S, LusciiSdkError> {
  const LusciiResult();
}

/// The result of a Luscii request that was successful.
final class LusciiSuccess<S, LusciiSdkError>
    extends LusciiResult<S, LusciiSdkError> {
  /// Creates a new [LusciiSuccess] with the given [value].
  const LusciiSuccess(this.value);

  /// The value of the successful result.
  final S value;
}

/// The result of a Luscii request that failed.
final class LusciiFailure<S, LusciiSdkError>
    extends LusciiResult<S, LusciiSdkError> {
  /// Creates a new [LusciiFailure] with the given [exception].
  const LusciiFailure(this.exception);

  /// The exception that caused the request to fail.
  final LusciiSdkError exception;
}

/// This class is used when the SDK returns no response.
/// It's similar to the `void` type
class LusciiNoResponse {
  /// Creates a new [LusciiNoResponse].
  const LusciiNoResponse();
}
