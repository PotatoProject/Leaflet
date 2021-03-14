import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

import 'note_controller.dart';

class SettingController {
  static const settingsPrefix = NoteController.notesPrefix;

  SettingController._();

  static Future<String> get(String key) async {
    try {
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}$settingsPrefix/setting/$key";
      Loggy.v(message: "Going to send GET to $url");
      final Response getResult = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "($key get) Server responded with (${getResult.statusCode}): ${getResult.data}",
      );
      return NoteController.handleResponse(getResult).toString();
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> set(String key, String value) async {
    try {
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}$settingsPrefix/setting/$key";
      Loggy.v(message: "Going to send PUT to $url");
      final Response setResult = await dio.put(
        url,
        data: value,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "($key set) Server responded with (${setResult.statusCode}): ${setResult.data}",
      );
      return NoteController.handleResponse(setResult).toString();
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, String>> getChanged(int lastUpdated) async {
    try {
      final String token = await prefs.getToken();
      final String url =
          "${prefs.apiUrl}$settingsPrefix/setting/changed?last_updated=$lastUpdated";
      Loggy.v(message: "Going to send GET to $url");
      final Response getResult = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(getChanged) Server responded with (${getResult.statusCode}): ${getResult.data}",
      );
      NoteController.handleResponse(getResult);
      final Map<String, dynamic> data =
          Utils.asMap<String, dynamic>(getResult.data);
      return data
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    } on SocketException {
      throw "Could not connect to server";
    }
  }
}
