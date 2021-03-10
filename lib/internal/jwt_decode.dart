// @dart=2.12
//
// Shamelessly copied from https://github.com/sidsbrmnn/jwt_decode/blob/master/lib/jwt_decode.dart,
// adds support for NNBD

import 'dart:convert';

class Jwt {
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid token.');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw const FormatException('Invalid payload.');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += "==";
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64 string.');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static bool isExpired(String token) {
    final DateTime? expirationDate = getExpiryDate(token);
    if (expirationDate != null) {
      return DateTime.now().isAfter(expirationDate);
    } else {
      return false;
    }
  }

  static DateTime? getExpiryDate(String token) {
    final Map<String, dynamic> payload = parseJwt(token);
    if (payload['exp'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(0)
          .add(Duration(seconds: payload["exp"] as int));
    }
    return null;
  }
}
