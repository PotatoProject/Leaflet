import 'dart:async';

import 'package:biometric_storage/biometric_storage.dart';

class Keystore {
  final Map<_KeystorageFileConstants, BiometricStorageFile> _storages;

  Keystore._(this._storages);

  static Future<Keystore> newInstance() async {
    final Map<_KeystorageFileConstants, BiometricStorageFile> _storages = {};
    for (final constant in _KeystorageFileConstants.values) {
      final BiometricStorageFile instance = await BiometricStorage().getStorage(
        constant.key,
        options: StorageFileInitOptions(authenticationRequired: false),
      );
      _storages[constant] = instance;
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

enum _KeystorageFileConstants {
  masterPass("master_pass"),
  databaseKey("database_key");

  final String key;
  const _KeystorageFileConstants(this.key);
}
