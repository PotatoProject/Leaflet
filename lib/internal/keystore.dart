import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Keystore {
  final FlutterSecureStorage storage;

  Keystore() : storage = FlutterSecureStorage();

  Future<String> getMasterPass() async {
    return await storage.read(key: "master_pass") ?? "";
  }

  void setMasterPass(String value) async {
    await storage.write(key: "master_pass", value: value);
  }
}
