//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

import 'package:biometric_storage/biometric_storage_web.dart';
import 'package:file_picker/src/file_picker_web.dart';
import 'package:file_selector_web/file_selector_web.dart';
import 'package:flutter_keyboard_visibility_web/flutter_keyboard_visibility_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:share_plus_web/share_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:webcrypto/src/flutter/webcrypto_plugin.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  BiometricStoragePluginWeb.registerWith(registrar);
  FilePickerWeb.registerWith(registrar);
  FileSelectorWeb.registerWith(registrar);
  FlutterKeyboardVisibilityPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  SharePlusPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  WebcryptoPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
