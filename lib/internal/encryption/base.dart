import 'dart:math';
import 'dart:typed_data';

abstract class EncryptionUtilsBase {
  static Uint8List generateNonce([int length = 16]) => Uint8List.fromList(
        List.generate(length, (index) => Random.secure().nextInt(255)),
      );

  Future<Uint8List> deriveKey(String password, Uint8List nonce);

  Future<Uint8List> encryptBytes(Uint8List origin, String password);

  Future<Uint8List> decryptBytes(Uint8List origin, String password);
}
