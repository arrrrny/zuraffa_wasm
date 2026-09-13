/// The typed native failure on macOS.
class MacosWasmException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const MacosWasmException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'MacosWasmException($code, recoverable: $recoverable): $message';
}
