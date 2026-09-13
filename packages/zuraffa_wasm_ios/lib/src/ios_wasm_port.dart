import 'dart:typed_data';

import 'package:zuraffa_wasm/zuraffa_wasm.dart';

import 'ios_wasm_channel.dart';
import 'ios_wasm_exception.dart';

/// iOS [WasmPort] over the typed
/// [IosWasmChannel].
class IosWasmPort implements WasmPort {
  final IosWasmChannel channel;

  const IosWasmPort({required this.channel});

  @override
  Future<bool> isSupported() async {
    final result = await channel.call('isSupported', const {});
    return result?['supported'] == true;
  }

  @override
  Future<WasmModule> compile({
    required String id,
    required Uint8List bytes,
  }) async {
    final result = await channel.call('compile', {
      'id': id,
      'bytes': bytes,
    });
    return WasmModule(
      id: id,
      byteLength:
          (result?['byteLength'] as num?)?.toInt() ?? bytes.lengthInBytes,
    );
  }

  @override
  Future<List<WasmValue>> invoke({
    required String id,
    required String export,
    List<WasmValue> args = const [],
  }) async {
    final result = await channel.call('invoke', {
      'id': id,
      'export': export,
      'args': [for (final arg in args) arg.encode()],
    });
    final values = result?['values'];
    if (values is! List) {
      throw const IosWasmException(
        'malformed_response',
        'The invoke result carried no value list.',
        recoverable: false,
      );
    }
    return [for (final raw in values) WasmValue.decode(raw)];
  }

  @override
  Future<void> unload({required String id}) async {
    await channel.call('unload', {'id': id});
  }
}
