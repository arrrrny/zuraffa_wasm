import 'package:zuraffa/zuraffa.dart';
import 'package:zuraffa_wasm/zuraffa_wasm.dart';

import 'ios_wasm_channel.dart';
import 'ios_wasm_exception.dart';
import 'ios_wasm_port.dart';

/// Registers the iOS adapter on [GetIt.instance]: the
/// [WasmPort] over an injected channel. An injected [timeout] is
/// applied to the wired channel. Without a channel every call surfaces
/// the typed `channel_not_wired` failure.
void registerIosWasmDependencies(
  GetIt getIt, {
  IosWasmChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? IosWasmChannel(
          invoke: (_, __) => throw const IosWasmException(
            'channel_not_wired',
            'No iOS channel was injected — pass one to '
            'registerIosWasmDependencies.',
            recoverable: false,
          ),
        )
      : (timeout == null)
          ? channel
          : IosWasmChannel(
              invoke: channel.invoke,
              timeout: timeout,
            );
  getIt.registerLazySingleton<WasmPort>(
    () => IosWasmPort(channel: wired),
  );
}
