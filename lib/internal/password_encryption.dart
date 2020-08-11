import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:potato_notes/internal/providers.dart';

class PasswordEncryption {
  static Future<String> encryptText(String data) async {
    // not gonna encrypt if we got no pass
    if (prefs.masterPass.isEmpty || data.isEmpty) return json.encode(data);
    final key = Key(await deriveKey(prefs.masterPass));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(data.toString(), iv: iv);

    return '${encrypted.base64}|${iv.base64}';
  }

  static Future<Uint8List> encryptTextToBinary(String plainText) async {
    final key = Key(await deriveKey(prefs.masterPass));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return Uint8List.fromList([...encrypted.bytes, ...iv.bytes]);
  }

  static Future<Uint8List> encryptBinary(Uint8List data) async {
    final key = Key(await deriveKey(prefs.masterPass));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(base64.encode(data), iv: iv);

    return Uint8List.fromList([...encrypted.bytes, ...iv.bytes]);
  }

  static Future<dynamic> decryptText(String cipherText) async {
    // no way of decrypting, returning
    if (prefs.masterPass == "") return cipherText;

    final key = Key(await deriveKey(prefs.masterPass));
    final encrypter = Encrypter(AES(key));

    try {
      final encrypted = cipherText.split('|');

      final decrypted = encrypter.decrypt(
        Encrypted.from64(encrypted[0]),
        iv: IV.fromBase64(encrypted[1]),
      );

      return decrypted;
    } on RangeError {
      // either input is not encrypted or bad key
      return cipherText;
    } on FormatException {
      try {
        return json.decode(cipherText);
      } on FormatException {
        return cipherText;
      }
    }
  }

  static Future<String> decryptBinaryToText(Uint8List data) async {
    final key = Key(await deriveKey(prefs.masterPass));
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

  static Future<Uint8List> decryptBinary(Uint8List data) async {
    final key = Key(await deriveKey(prefs.masterPass));
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

  static Future<bool> isPasswordValid(
    String password,
    String plainText,
    String hash,
  ) async {
    final key = Key(await deriveKey(password));
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final encryptedString = await getSha512('${encrypted.base64}|${iv.base64}');
    return hash == encryptedString;
  }

  static Future<String> getSha512(String input) async {
    return utf8.decode(
      (await sha512.hash(
        utf8.encode(
          input,
        ),
      ))
          .bytes,
    );
  }
}
