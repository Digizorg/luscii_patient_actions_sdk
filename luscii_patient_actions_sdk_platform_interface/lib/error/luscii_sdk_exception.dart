/// Exception class for the Luscii SDK
class LusciiSdkException implements Exception {
  /// Creates a new [LusciiSdkException] with the given [reason].
  LusciiSdkException({required this.reason});

  /// The reason for the error.
  final String reason;
}
