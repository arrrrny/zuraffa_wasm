import 'package:zuraffa/zuraffa.dart';
import 'package:zuraffa_wasm/zuraffa_wasm.dart';

import 'macos_wasm_channel.dart';
import 'macos_wasm_exception.dart';
import 'macos_wasm_port.dart';

/// Registers the macOS adapter on [GetIt.instance]: the
/// [WasmPort] over an injected channel. An injected [timeout] is
/// applied to the wired channel. Without a channel every call surfaces
/// the typed `channel_not_wired` failure.
void registerMacosWasmDependencies(
  GetIt getIt, {
  MacosWasmChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? MacosWasmChannel(
          invoke: (_, __) => throw const MacosWasmException(
            'channel_not_wired',
            'No macOS channel was injected — pass one to '
            'registerMacosWasmDependencies.',
            recoverable: false,
          ),
        )
      : (timeout == null)
          ? channel
          : MacosWasmChannel(
              invoke: channel.invoke,
              timeout: timeout,
            );
  getIt.registerLazySingleton<WasmPort>(
    () => MacosWasmPort(channel: wired),
  );
}
