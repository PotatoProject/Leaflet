import 'dart:typed_data';

import 'package:potato_notes/internal/encryption/base.dart';
import 'package:webcrypto/webcrypto.dart';

class BoringSSLEncryptionUtils extends EncryptionUtilsBase {
  @override
  Future<Uint8List> deriveKey(String password, Uint8List nonce) async {
    final key = await Pbkdf2SecretKey.importRawKey(password.codeUnits);

    return key.deriveBits(256, Hash.sha512, nonce, 100000);
  }

  @override
  Future<Uint8List> encryptBytes(Uint8List origin, String password) async {
    final keySalt = EncryptionUtilsBase.generateNonce();
    final key = await deriveKey(password, keySalt);

    final aes = await AesGcmSecretKey.importRawKey(key);
    final ciphertext = await aes.encryptBytes(origin, keySalt);

    final res = Uint8List.sublistView(keySalt);
    res.addAll(ciphertext);

    return res;
  }

  @override
  Future<Uint8List> decryptBytes(Uint8List origin, String password) async {
    final keySalt = origin.sublist(0, 16);
    final payload = origin.sublist(16);

    final key = await deriveKey(password, keySalt);
    final aes = await AesGcmSecretKey.importRawKey(key);
    final plaintext = await aes.decryptBytes(payload, keySalt);

    return plaintext;
  }
}
