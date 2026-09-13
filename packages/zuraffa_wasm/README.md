# zuraffa_wasm

WebAssembly for the Zuraffa ecosystem: a pure-Dart port over an injected platform channel with federated android, ios, and macos adapters.

Part of the [zuraffa_wasm](https://github.com/arrrrny/zuraffa_wasm) federated monorepo, built on the
[Zuraffa](https://pub.dev/packages/zuraffa) framework.

## Use

```dart
final service = WasmService(port: myPlatformPort);
final module = await service.compile(id: 'demo', bytes: moduleBytes);
final results = await service.call(
    id: 'demo', export: 'run', args: [WasmI32(1)]);
await service.unload(id: 'demo');
```

Wire the platform adapter for the running platform first — e.g.
`registerAndroidWasmDependencies(getIt, channel: ...)` from
the adapter package — then resolve `WasmService`, or call
`registerWasmDependencies(getIt, port: ...)` directly. Without a
wired port every call surfaces the typed `port_not_wired` failure.

## Develop

```bash
dart pub get
dart test
```
