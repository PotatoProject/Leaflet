import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';

import 'note_controller.dart';

class SettingController {
  static const SETTINGS_PREFIX = NoteController.NOTES_PREFIX;

  static Future<String> get(String key) async {
    try {
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}$SETTINGS_PREFIX/setting/$key";
      Loggy.v(message: "Going to send GET to " + url);
      Response getResult =
          await http.get(url, headers: {"Authorization": "Bearer " + token});
      Loggy.d(
          message:
              "($key get) Server responded with (${getResult.statusCode}): " +
                  getResult.body);
      return NoteController.handleResponse(getResult);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<String> set(String key, String value) async {
    try {
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}$SETTINGS_PREFIX/setting/$key";
      Loggy.v(message: "Going to send PUT to " + url);
      Response setResult = await http
          .put(url, body: value, headers: {"Authorization": "Bearer " + token});
      Loggy.d(
          message:
              "($key set) Server responded with (${setResult.statusCode}): " +
                  setResult.body);
      return NoteController.handleResponse(setResult);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<Map<String, String>> getChanged(int lastUpdated) async {
    try {
      String token = await prefs.getToken();
      String url =
          "${prefs.apiUrl}$SETTINGS_PREFIX/setting/changed?last_updated=$lastUpdated";
      Loggy.v(message: "Going to send GET to " + url);
      Response getResult =
          await http.get(url, headers: {"Authorization": "Bearer " + token});
      Loggy.d(
          message:
              "(getChanged) Server responded with (${getResult.statusCode}): " +
                  getResult.body);
      var body = NoteController.handleResponse(getResult);
      Map<String, String> settingsChanged = Map<String, String>();
      //TODO Change this to just decode a Map<String,String> when API is updated
      if (body != "[]") {
        List<dynamic> listChanged = json.decode(body);
        for (dynamic item in listChanged) {
          var items = List.castFrom(item);
          settingsChanged.putIfAbsent(items[0], () => items[1]);
        }
      }
      return settingsChanged;
    } on SocketException {
      throw ("Could not connect to server");
    }
  }
}
