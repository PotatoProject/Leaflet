import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:potato_notes/internal/encryption/base.dart';

class DartEncryptionUtils extends EncryptionUtilsBase {
  @override
  Future<Uint8List> decryptBytes(Uint8List origin, String password) async {
    final keySalt = origin.sublist(0, 16);
    final aesNonce = origin.sublist(16, 28);
    final macBytes = origin.sublist(28, 44);
    final payload = origin.sublist(44);

    final key = await deriveKey(password, keySalt);

    final aes = AesGcm.with256bits();
    final plaintext = await aes.decrypt(
      SecretBox(
        payload,
        nonce: aesNonce,
        mac: Mac(macBytes),
      ),
      secretKey: SecretKey(key),
    );

    return Uint8List.fromList(plaintext);
  }

  @override
  Future<Uint8List> deriveKey(String password, Uint8List nonce) async {
    final kdf = Pbkdf2(
      bits: 256,
      iterations: 100000,
      macAlgorithm: Hmac.sha512(),
    );
    final key = await kdf.deriveKey(
      secretKey: SecretKey(password.codeUnits),
      nonce: nonce,
    );

    return Uint8List.fromList(await key.extractBytes());
  }

  @override
  Future<Uint8List> encryptBytes(Uint8List origin, String password) async {
    final keySalt = EncryptionUtilsBase.generateNonce();
    final key = await deriveKey(password, keySalt);

    final aes = AesGcm.with256bits();
    final ciphertext = await aes.encrypt(origin, secretKey: SecretKey(key));

    return Uint8List.fromList([
      ...keySalt,
      ...ciphertext.nonce,
      ...ciphertext.mac.bytes,
      ...ciphertext.cipherText,
    ]);
  }
}
