# zuraffa_wasm_ios

iOS adapter for the [zuraffa_wasm](https://github.com/arrrrny/zuraffa_wasm) federated monorepo:
the Wasm port over an injected platform channel, with the shared
envelope machinery from `zuraffa_wasm_platform` and a typed failure taxonomy
as pure data.

The channel transport is injected — no Flutter plugin boilerplate, no
native code in this repo. The consuming app (or a native shell) supplies
the `ChannelInvoke` seam:

```dart
import 'package:zuraffa/zuraffa.dart';
import 'package:zuraffa_wasm_ios/zuraffa_wasm_ios.dart';

void register() {
  registerIosWasmDependencies(
    GetIt.instance,
    channel: IosWasmChannel(
      invoke: (method, args) => nativeBridge.call(method, args),
    ),
  );
}
```

Without an injected channel every call surfaces the typed
`channel_not_wired` failure instead of hanging.

## Develop

```bash
dart pub get
dart test
```
