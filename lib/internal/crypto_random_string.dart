import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

String generateSecureRandomString({int length = 16}) {
  return base64
      .encode(
        Uint8List.fromList(
          List<int>.filled(length, Random.secure().nextInt(2048)),
        ),
      )
      .substring(0, length);
}
