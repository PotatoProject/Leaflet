import 'package:biometric_storage/biometric_storage.dart';

class Keystore {
  final Map<String, BiometricStorageFile> _storages;

  Keystore._(this._storages);

  static Future<Keystore> newInstance() async {
    final Map<String, BiometricStorageFile> _storages = {};
    for (final String key in _KeystorageFileConstants.values) {
      final BiometricStorageFile instance = await BiometricStorage().getStorage(
        key,
        options: StorageFileInitOptions(authenticationRequired: false),
      );
      _storages[key] = instance;
    }
    return Keystore._(_storages);
  }

  Future<String> getMasterPass() async {
    final String? value =
        await _storages[_KeystorageFileConstants.masterPass]?.read();
    return value ?? "";
  }

  Future<void> setMasterPass(String value) async {
    await _storages[_KeystorageFileConstants.masterPass]?.write(value);
  }

  Future<String?> getDatabaseKey() async {
    final String? value =
        await _storages[_KeystorageFileConstants.databaseKey]?.read();
    return value;
  }

  Future<void> setDatabaseKey(String value) async {
    await _storages[_KeystorageFileConstants.databaseKey]?.write(value);
  }
}

class _KeystorageFileConstants {
  static const String masterPass = "master_pass";
  static const String databaseKey = "database_key";

  static const List<String> values = [
    masterPass,
    databaseKey,
  ];
}
