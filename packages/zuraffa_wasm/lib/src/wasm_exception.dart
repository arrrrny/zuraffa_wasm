/// The typed failure surfaced by the zuraffa_wasm port and service.
class WasmException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const WasmException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'WasmException($code, recoverable: $recoverable): $message';
}
