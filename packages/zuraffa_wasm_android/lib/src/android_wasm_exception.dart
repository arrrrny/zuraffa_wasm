/// The typed native failure on Android.
class AndroidWasmException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const AndroidWasmException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'AndroidWasmException($code, recoverable: $recoverable): $message';
}
