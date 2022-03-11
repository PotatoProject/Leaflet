import 'dart:typed_data';

import 'package:potato_notes/ffi.dart';
import 'package:potato_notes/internal/encryption/base.dart';

class RustEncryptionUtils implements EncryptionUtilsBase {
  @override
  Future<Uint8List> decryptBytes(Uint8List origin, String password) async {
    final res = await api.decrypt(data: origin, password: password);

    if (res != null) {
      return res;
    }

    throw Exception();
  }

  @override
  Future<Uint8List> deriveKey(String password, Uint8List nonce) =>
      api.deriveKey(password: password, nonce: nonce);

  @override
  Future<Uint8List> encryptBytes(Uint8List origin, String password) async {
    final res = await api.encrypt(
      data: origin,
      password: password,
      keyNonce: EncryptionUtilsBase.generateNonce(),
      aesNonce: EncryptionUtilsBase.generateNonce(12),
    );

    if (res != null) {
      return res;
    }

    throw Exception();
  }
}
