/// The typed native failure on iOS.
class IosWasmException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const IosWasmException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'IosWasmException($code, recoverable: $recoverable): $message';
}
