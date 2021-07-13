import 'dart:math';

abstract class EncryptionUtilsBase {
  static List<int> generateNonce([int length = 16]) => List.generate(
        length,
        (index) => Random.secure().nextInt(255),
      );

  Future<List<int>> deriveKey(String password, List<int> nonce);

  Future<List<int>> encryptBytes(List<int> origin, String password);

  Future<List<int>> decryptBytes(List<int> origin, String password);
}
