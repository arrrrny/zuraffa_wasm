import 'package:zuraffa/zuraffa.dart';
import 'package:zuraffa_wasm/zuraffa_wasm.dart';

import 'android_wasm_channel.dart';
import 'android_wasm_exception.dart';
import 'android_wasm_port.dart';

/// Registers the Android adapter on [GetIt.instance]: the
/// [WasmPort] over an injected channel. An injected [timeout] is
/// applied to the wired channel. Without a channel every call surfaces
/// the typed `channel_not_wired` failure.
void registerAndroidWasmDependencies(
  GetIt getIt, {
  AndroidWasmChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? AndroidWasmChannel(
          invoke: (_, __) => throw const AndroidWasmException(
            'channel_not_wired',
            'No Android channel was injected — pass one to '
            'registerAndroidWasmDependencies.',
            recoverable: false,
          ),
        )
      : (timeout == null)
          ? channel
          : AndroidWasmChannel(
              invoke: channel.invoke,
              timeout: timeout,
            );
  getIt.registerLazySingleton<WasmPort>(
    () => AndroidWasmPort(channel: wired),
  );
}
