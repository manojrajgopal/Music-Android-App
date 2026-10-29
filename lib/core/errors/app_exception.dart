/// A failure with a message that is safe to show to the user.
class AppException implements Exception {
  const AppException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'AppException($code): $message';
}

/// Converts any error into user-facing text without leaking internals.
String friendlyError(Object error) {
  if (error is AppException) return error.message;
  return 'Something went wrong. Please try again.';
}
