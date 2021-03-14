// Kanged from https://github.com/james-alex/blake2

import 'dart:typed_data';

import 'blake_base.dart';

/// The BLAKE2b (64-bit) flavor of the BLAKE2
/// cryptographic hash function.
class Blake2 extends BlakeBase {
  /// The BLAKE2s (32-bit) flavor of the BLAKE2
  /// cryptographic hash function.
  ///
  /// [digestLength] must not be null and must be `> 0`.
  ///
  /// [key] may be null, but if set, it will be used for the
  /// first round of compression.
  ///
  /// [salt], [personalization], and [iv] may be null
  /// or must `== 8` characters in length.
  Blake2({
    this.digestLength = 32,
    this.key,
    this.salt,
    this.personalization,
    Uint64List? iv,
  })  : assert(digestLength > 0 && digestLength <= 32),
        assert(salt == null || salt.length == 8),
        assert(personalization == null || personalization.length == 8),
        iv = iv ??
            Uint64List.fromList(<int>[
              0x6a09e667f3bcc908,
              0xbb67ae8584caa73b,
              0x3c6ef372fe94f82b,
              0xa54ff53a5f1d36f1,
              0x510e527fade682d1,
              0x9b05688c2b3e6c1f,
              0x1f83d9abfb41bd6b,
              0x5be0cd19137e2179,
            ]) {
    reset();
  }

  @override
  final Uint8List? key;

  @override
  final Uint8List? salt;

  @override
  final Uint8List? personalization;

  @override
  final int digestLength;

  @override
  Uint64List iv;

  @override
  final int bitLength = 64;

  @override
  final Uint8List sigma = Uint8List.fromList([
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    14,
    10,
    4,
    8,
    9,
    15,
    13,
    6,
    1,
    12,
    0,
    2,
    11,
    7,
    5,
    3,
    11,
    8,
    12,
    0,
    5,
    2,
    15,
    13,
    10,
    14,
    3,
    6,
    7,
    1,
    9,
    4,
    7,
    9,
    3,
    1,
    13,
    12,
    11,
    14,
    2,
    6,
    5,
    10,
    4,
    0,
    15,
    8,
    9,
    0,
    5,
    7,
    2,
    4,
    10,
    15,
    14,
    1,
    11,
    12,
    6,
    8,
    3,
    13,
    2,
    12,
    6,
    10,
    0,
    11,
    8,
    3,
    4,
    13,
    7,
    5,
    15,
    14,
    1,
    9,
    12,
    5,
    1,
    15,
    14,
    13,
    4,
    10,
    0,
    7,
    6,
    3,
    9,
    2,
    8,
    11,
    13,
    11,
    7,
    14,
    12,
    1,
    3,
    9,
    5,
    0,
    15,
    4,
    8,
    6,
    2,
    10,
    6,
    15,
    14,
    9,
    11,
    3,
    0,
    8,
    12,
    2,
    13,
    7,
    1,
    4,
    10,
    5,
    10,
    2,
    8,
    4,
    7,
    6,
    1,
    5,
    15,
    11,
    9,
    14,
    3,
    12,
    13,
    0,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    14,
    10,
    4,
    8,
    9,
    15,
    13,
    6,
    1,
    12,
    0,
    2,
    11,
    7,
    5,
    3,
  ]);

  /// Returns a [Blake2] instance using [Strings] for the
  /// [key], [salt], and [personalization] arguments.
  ///
  /// [key] may be null and can be up to 32 characters long.
  ///
  /// [salt] and [personalization] may be null and
  /// must both be 8 characters in length.
  factory Blake2.fromStrings({
    int digestLength = 32,
    String? key,
    String? salt,
    String? personalization,
    Uint64List? iv,
  }) {
    assert(digestLength > 0 && digestLength <= 32);
    assert(salt == null || salt.length == 8);
    assert(personalization == null || personalization.length == 8);
    assert(iv == null || iv.length == 8);

    return Blake2(
      digestLength: digestLength,
      key: (key == null) ? null : Uint8List.fromList(key.codeUnits),
      salt: (salt == null) ? null : Uint8List.fromList(salt.codeUnits),
      personalization: (personalization != null)
          ? Uint8List.fromList(personalization.codeUnits)
          : null,
      iv: iv,
    );
  }
}
