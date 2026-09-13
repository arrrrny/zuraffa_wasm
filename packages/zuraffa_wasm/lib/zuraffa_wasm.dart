/// zuraffa_wasm — Wasm support for the Zuraffa ecosystem.
///
/// A pure-Dart port (`WasmPort`), a facade (`WasmService`),
/// typed failures, and DI registration. Platform adapters implement the
/// port over an injected platform channel — the shared envelope machinery
/// lives in `zuraffa_wasm_platform`.
library;

export 'src/wasm_exception.dart';
export 'src/wasm_module.dart';
export 'src/wasm_port.dart';
export 'src/wasm_service.dart';
export 'src/wasm_value.dart';
