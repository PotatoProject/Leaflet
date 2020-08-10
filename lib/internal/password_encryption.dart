import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';

/// PasswordEncryption
/// @author Akshit Garg <garg.akshit@gmail.com>
class PasswordEncryption {
  static Future<String> encryptText(
    String plainText,
    String password,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return '${encrypted.base64}|${iv.base64}';
  }

  static Future<Uint8List> encryptTextToBinary(
    String plainText,
    String password,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return Uint8List.fromList([...encrypted.bytes, ...iv.bytes]);
  }

  static Future<Uint8List> encryptBinary(
    Uint8List data,
    String password,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(base64.encode(data), iv: iv);

    return Uint8List.fromList([...encrypted.bytes, ...iv.bytes]);
  }

  static Future<String> decryptText(
    String cipherText,
    String password,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));

    try {
      final encrypted = cipherText.split('|');

      final decrypted = encrypter.decrypt(
        Encrypted.from64(encrypted[0]),
        iv: IV.fromBase64(encrypted[1]),
      );

      return decrypted;
    } catch (e) {
      throw Exception('There was an error decrypting the inputs');
    }
  }

  static Future<String> decryptBinaryToText(
    Uint8List data,
    String password,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));

    try {
      final decrypted = encrypter.decrypt(
        Encrypted(data.sublist(0, data.length - 16)),
        iv: IV(data.sublist(data.length - 16, data.length)),
      );

      return decrypted;
    } catch (e) {
      throw Exception('There was an error decrypting the inputs');
    }
  }

  static Future<Uint8List> decryptBinary(
    Uint8List data,
    String password,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));

    try {
      final decrypted = encrypter.decrypt(
        Encrypted(data.sublist(0, data.length - 16)),
        iv: IV(data.sublist(data.length - 16, data.length)),
      );

      return base64.decode(decrypted);
    } catch (e) {
      throw Exception('There was an error decrypting the inputs');
    }
  }

  static Future<Uint8List> deriveKey(
    String password,
  ) async {
    final hkdf = Hkdf(Hmac(sha512));
    final input = SecretKey(utf8.encode(password));
    final output = await hkdf.deriveKey(input, outputLength: 32);

    return await output.extract();
  }
}
