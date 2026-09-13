import 'dart:typed_data';

import 'package:zuraffa/zuraffa.dart';

import 'wasm_exception.dart';
import 'wasm_module.dart';
import 'wasm_port.dart';
import 'wasm_value.dart';

/// Facade over the [WasmPort]: owns the compiled-module registry
/// and turns lifecycle mistakes (double compile, call-before-compile)
/// into typed failures before they reach the platform.
class WasmService {
  final WasmPort port;
  final Map<String, WasmModule> _modules = {};

  WasmService({required this.port});

  /// The compiled modules currently held by this service.
  Set<String> get compiledModules => Set.unmodifiable(_modules.keys);

  Future<bool> supported() => port.isSupported();

  Future<WasmModule> compile({
    required String id,
    required Uint8List bytes,
  }) async {
    if (_modules.containsKey(id)) {
      throw WasmException(
        'already_compiled',
        'Module "$id" is already compiled — unload it first.',
        recoverable: false,
      );
    }
    final module = await port.compile(id: id, bytes: bytes);
    _modules[id] = module;
    return module;
  }

  Future<List<WasmValue>> call({
    required String id,
    required String export,
    List<WasmValue> args = const [],
  }) async {
    _requireCompiled(id);
    return port.invoke(id: id, export: export, args: args);
  }

  Future<void> unload({required String id}) async {
    _requireCompiled(id);
    await port.unload(id: id);
    _modules.remove(id);
  }

  void _requireCompiled(String id) {
    if (!_modules.containsKey(id)) {
      throw WasmException(
        'not_compiled',
        'Module "$id" is not compiled — call compile() first.',
        recoverable: false,
      );
    }
  }
}

/// A port placeholder registered when no platform adapter was wired:
/// every operation surfaces the typed `port_not_wired` failure instead of
/// a null dereference at resolve time.
class _UnwiredWasmPort implements WasmPort {
  const _UnwiredWasmPort();

  Never _unwired() => throw const WasmException(
        'port_not_wired',
        'No WasmPort was registered — wire the platform adapter '
        'for the running platform before resolving WasmService.',
        recoverable: false,
      );

  @override
  Future<bool> isSupported() async => _unwired();

  @override
  Future<WasmModule> compile({
    required String id,
    required Uint8List bytes,
  }) =>
      _unwired();

  @override
  Future<List<WasmValue>> invoke({
    required String id,
    required String export,
    List<WasmValue> args = const [],
  }) =>
      _unwired();

  @override
  Future<void> unload({required String id}) => _unwired();
}

/// Registers the zuraffa_wasm stack onto [getIt]: the [WasmPort] is
/// normally supplied by the platform adapter package for the running
/// platform (e.g. `registerAndroidWasmDependencies`). Without a
/// port the service resolves over the unwired placeholder and surfaces
/// typed `port_not_wired` failures.
void registerWasmDependencies(
  GetIt getIt, {
  WasmPort? port,
}) {
  getIt.registerLazySingleton<WasmService>(
    () => WasmService(port: port ?? const _UnwiredWasmPort()),
  );
}
