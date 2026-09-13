import 'wasm_exception.dart';

/// A WebAssembly scalar value crossing the platform boundary.
///
/// The scaffold ships the four numeric types; the migration extends the
/// family (reference types, vectors) without breaking the contract.
sealed class WasmValue {
  const WasmValue();

  /// Encodes this value into the primitive representation transported over
  /// the platform channel. i64 travels as a decimal string — channel
  /// payloads cannot carry a BigInt losslessly.
  Object encode() => switch (this) {
        WasmI32(:final value) => value,
        WasmI64(:final value) => value.toString(),
        WasmF32(:final value) => value,
        WasmF64(:final value) => value,
      };

  /// Decodes a channel payload into a [WasmValue]: ints decode as
  /// i32, doubles as f64, and decimal strings as i64.
  static WasmValue decode(Object? raw) {
    if (raw is int) return WasmI32(raw);
    if (raw is double) return WasmF64(raw);
    if (raw is String) return WasmI64(BigInt.parse(raw));
    throw WasmException(
      'malformed_value',
      'Cannot decode "$raw" into a WasmValue.',
      recoverable: false,
    );
  }
}

/// A 32-bit integer value.
class WasmI32 extends WasmValue {
  final int value;

  const WasmI32(this.value);
}

/// A 64-bit integer value (transported as a decimal string).
class WasmI64 extends WasmValue {
  final BigInt value;

  const WasmI64(this.value);
}

/// A 32-bit float value.
class WasmF32 extends WasmValue {
  final double value;

  const WasmF32(this.value);
}

/// A 64-bit float value.
class WasmF64 extends WasmValue {
  final double value;

  const WasmF64(this.value);
}
