// Kanged from https://github.com/james-alex/blake2

import 'dart:typed_data';

/// The base class containing the shared values and methods of the
/// [Blake2b] and [Blake2s] hashing algorithms.
abstract class BlakeBase {
  /// The length of the digest, defaults to `32`.
  int get digestLength;

  /// If set, [key] is used for the first round of compression.
  Uint8List get key;

  /// If set, [salt] is used to modify the initialization vector.
  Uint8List get salt;

  /// If set, [personalization] acts as a second [salt].
  Uint8List get personalization;

  /// Initialization vector
  List<int> get iv;

  /// Offsets for each round within the memory block.
  Uint8List get sigma;

  /// The hash of the key + all of the values added via `update()`.
  List<int> _hash;

  /// The bit-length of the integers being used in the hashing function.
  ///
  /// BLAKE2b uses 64-bit, and BLAKE2s uses 32-bit.
  int get bitLength;

  /// The buffer block's length
  int get _blockSize => bitLength * 2;

  /// Buffer block
  List<int> _block;

  /// Resets the hash to its initial state, effectively
  /// clearing all values added via `update()`.
  void reset() {
    final keyLength = (key == null) ? 0 : key.length;

    final hash = List<int>.filled(8, null);

    for (var i = 0; i < hash.length; i++) {
      hash[i] = iv[i];
      if (salt != null) hash[i] ^= salt[i];
      if (personalization != null) hash[i] ^= personalization[i];
    }

    final block = List<int>.filled(_blockSize, 0);

    if (bitLength == 32) {
      _hash = Uint32List.fromList(hash);
      _block = Uint32List.fromList(block);
    } else {
      _hash = Uint64List.fromList(hash);
      _block = Uint64List.fromList(block);
    }

    // If [key] exists, make the first round with it.
    if (keyLength > 0) {
      update(key);
      _pointer = _blockSize;
    }
  }

  int _pointer = 0;

  int _counter = 0;

  /// Calculates the digest of all data passed via `update()`.
  Uint8List digest() {
    final digest = Uint8List(digestLength);

    _counter += _pointer;

    // Clear block
    while (_pointer < _blockSize) {
      _block[_pointer++] = 0;
    }

    // Compress
    _compress(true);

    // Little-endian convert and store
    for (var i = 0; i < digestLength; i++) {
      digest[i] = _hash[i >> 2] >> (8 * (i & 3));
    }

    return digest;
  }

  /// Returns the calculated digest as a string.
  String digestToString() => String.fromCharCodes(digest());

  /// Update hash content with the given data.
  void update(Uint8List data) {
    assert(data != null);

    for (var i = 0; i < data.length; i++) {
      if (_pointer == _blockSize) {
        _counter += _pointer;
        _compress(false);
        _pointer = 0;
      }

      // Copy input array to input block.
      _block[_pointer++] = data[i];
    }
  }

  /// Converts [data] to a [Uint8List] and passes it to `update()`.
  void updateWithString(String data) {
    assert(data != null);

    update(Uint8List.fromList(data.codeUnits));
  }

  /// Compression function
  void _compress(bool isLast) {
    assert(isLast != null);

    List<int> v;
    List<int> m;

    final vm = List<int>.filled(16, 0);

    if (bitLength == 32) {
      v = Uint32List.fromList(vm);
      m = Uint32List.fromList(vm);
    } else {
      v = Uint64List.fromList(vm);
      m = Uint64List.fromList(vm);
    }

    for (var i = 0; i < 8; i++) {
      v[i] = _hash[i];
      v[i + 8] = iv[i];
    }

    v[12] ^= _counter;
    v[13] ^= _counter;

    if (isLast) {
      v[14] ^= ~v[14];
    }

    // Get Little-endian words
    for (var i = 0; i < 16; i++) {
      m[i] = _get32(_block, i * 4);
    }

    void _gamma(int a, int b, int c, int d, int x, int y) {
      v[a] += v[b] + x;
      v[d] = _rotateRight(v[d] ^ v[a], 16, bitLength);

      v[c] += v[d];
      v[b] = _rotateRight(v[b] ^ v[c], 12, bitLength);

      v[a] += v[b] + y;
      v[d] = _rotateRight(v[d] ^ v[a], 8, bitLength);

      v[c] += v[d];
      v[b] = _rotateRight(v[b] ^ v[c], 7, bitLength);
    }

    final compressionRounds = (bitLength == 32) ? 10 : 12;

    for (var i = 0; i < compressionRounds; i++) {
      _gamma(0, 4, 8, 12, m[sigma[i * 16]], m[sigma[i * 16 + 1]]);
      _gamma(1, 5, 9, 13, m[sigma[i * 16 + 2]], m[sigma[i * 16 + 3]]);
      _gamma(2, 6, 10, 14, m[sigma[i * 16 + 4]], m[sigma[i * 16 + 5]]);
      _gamma(3, 7, 11, 15, m[sigma[i * 16 + 6]], m[sigma[i * 16 + 7]]);
      _gamma(0, 5, 10, 15, m[sigma[i * 16 + 8]], m[sigma[i * 16 + 9]]);
      _gamma(1, 6, 11, 12, m[sigma[i * 16 + 10]], m[sigma[i * 16 + 11]]);
      _gamma(2, 7, 8, 13, m[sigma[i * 16 + 12]], m[sigma[i * 16 + 13]]);
      _gamma(3, 4, 9, 14, m[sigma[i * 16 + 14]], m[sigma[i * 16 + 15]]);
    }

    for (var i = 0; i < 8; i++) {
      _hash[i] ^= v[i] ^ v[i + 8];
    }
  }

  /// Convert 4 bytes to Little-endian word.
  int _get32(List<int> data, int index) {
    assert(data != null);
    assert(index != null);

    return data[index + 1] ^
        (data[index + 1] << 8) ^
        (data[index + 1] << 16) ^
        (data[index] << 24);
  }

  /// Cyclic right rotation
  int _rotateRight(int data, int shift, int length) {
    assert(data != null);
    assert(shift != null);

    return (data >> shift) ^ (data << (length - shift));
  }
}

// This is just a fake blake class
class Blake2 extends BlakeBase {
  @override
  int get bitLength => null;

  @override
  int get digestLength => null;

  @override
  List<int> get iv => null;

  @override
  Uint8List get key => null;

  @override
  Uint8List get personalization => null;

  @override
  Uint8List get salt => null;

  @override
  Uint8List get sigma => null;
}
