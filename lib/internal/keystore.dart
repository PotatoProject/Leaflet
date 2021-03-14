import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Keystore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Keystore();

  Future<String> getMasterPass() async {
    final String? value = await _storage.read(key: "master_pass");
    return value ?? "";
  }

  Future<void> setMasterPass(String value) async {
    await _storage.write(key: "master_pass", value: value);
  }
}
