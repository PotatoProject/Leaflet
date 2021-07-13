import 'package:cryptography/cryptography.dart';
import 'package:potato_notes/internal/encryption/base.dart';

class DartEncryptionUtils extends EncryptionUtilsBase {
  @override
  Future<List<int>> decryptBytes(List<int> origin, String password) async {
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

    return plaintext;
  }

  @override
  Future<List<int>> deriveKey(String password, List<int> nonce) async {
    final kdf = Pbkdf2(
      bits: 256,
      iterations: 100000,
      macAlgorithm: Hmac.sha512(),
    );
    final key = await kdf.deriveKey(
      secretKey: SecretKey(password.codeUnits),
      nonce: nonce,
    );

    return key.extractBytes();
  }

  @override
  Future<List<int>> encryptBytes(List<int> origin, String password) async {
    final keySalt = EncryptionUtilsBase.generateNonce();
    final key = await deriveKey(password, keySalt);

    final aes = AesGcm.with256bits();
    final ciphertext = await aes.encrypt(origin, secretKey: SecretKey(key));

    return [
      ...keySalt,
      ...ciphertext.nonce,
      ...ciphertext.mac.bytes,
      ...ciphertext.cipherText,
    ];
  }
}
