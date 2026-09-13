import 'package:zuraffa_wasm_platform/zuraffa_wasm_platform.dart';

import 'android_wasm_exception.dart';

/// The Android channel: the shared
/// [PlatformWasmEnvelope] machinery with the Android
/// taxonomy as a pure data set.
class AndroidWasmChannel {
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

  const AndroidWasmChannel({
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
        onTyped: AndroidWasmException.new,
        mapNativeError: _mapNativeError,
        isTypedError: (error) => error is AndroidWasmException,
      ).call(method, args);

  static Exception _mapNativeError(String code, String message) =>
      AndroidWasmException(
        code,
        message,
        recoverable: recoverableCodes.contains(code),
      );
}
