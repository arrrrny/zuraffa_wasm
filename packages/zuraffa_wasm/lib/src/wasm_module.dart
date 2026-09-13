/// A compiled WebAssembly module, bound to [id] inside the owning
/// engine/adapter until unloaded.
class WasmModule {
  final String id;
  final int byteLength;

  const WasmModule({required this.id, required this.byteLength});
}
