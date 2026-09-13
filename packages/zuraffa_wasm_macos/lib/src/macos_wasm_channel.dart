import 'package:zuraffa_wasm_platform/zuraffa_wasm_platform.dart';

import 'macos_wasm_exception.dart';

/// The macOS channel: the shared
/// [PlatformWasmEnvelope] machinery with the macOS
/// taxonomy as a pure data set.
class MacosWasmChannel {
  /// Native codes that map recoverable; everything else (including
  /// unknown codes) is non-recoverable, preserved verbatim.
  static const Set<String> recoverableCodes = {
    'user_cancelled',
    'api_unavailable',
    'not_supported',
    'timeout',
  };

  final ChannelInvoke invoke;
  final Duration timeout;

  const MacosWasmChannel({
    required this.invoke,
    this.timeout = const Duration(seconds: 30),
  });

  Future<Map<String, Object?>?> call(
    String method,
    Map<String, Object?> args,
  ) =>
      PlatformWasmEnvelope(
        invoke: invoke,
        timeout: timeout,
        onTyped: MacosWasmException.new,
        mapNativeError: _mapNativeError,
        isTypedError: (error) => error is MacosWasmException,
      ).call(method, args);

  static Exception _mapNativeError(String code, String message) =>
      MacosWasmException(
        code,
        message,
        recoverable: recoverableCodes.contains(code),
      );
}
