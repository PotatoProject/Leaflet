import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:recase/recase.dart';

class TagController {
  static Future<String> add(Tag tag) async {
    try {
      String token = await prefs.getToken();
      String tagJson = json.encode(toSync(tag));
      var url = "${prefs.apiUrl}${NoteController.NOTES_PREFIX}/tag";
      Loggy.v(message: "Going to send POST to $url");
      Response addResult = await dio.post(
        url,
        data: tagJson,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
              "(${tag.id} tag-add) Server responded with (${addResult.statusCode}): ${addResult.data}");
      return NoteController.handleResponse(addResult);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<String> delete(String id) async {
    try {
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}${NoteController.NOTES_PREFIX}/tag/$id";
      Loggy.v(message: "Goind to send DELETE to " + url);
      Response deleteResponse = await dio.delete(
        url,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
          "($id tag-delete) Server responded with (${deleteResponse
              .statusCode}}: " +
              deleteResponse.data);
      return NoteController.handleResponse(deleteResponse);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<Tag>> list(int lastUpdated) async {
    try {
      String token = await prefs.getToken();
      var url =
          "${prefs.apiUrl}${NoteController.NOTES_PREFIX}/tag/list?last_updated=$lastUpdated";
      Loggy.v(message: "Going to send GET to " + url);

      Response listResult = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
              "(tag-list) Server responded with (${listResult.statusCode}): " +
                  listResult.data.toString());
      var body = NoteController.handleResponse(listResult);
      List<dynamic> tags = body.map((map) {
        var tag = fromSync(map);
        return tag;
      }).toList();
      return tags.map((tag) => tag as Tag).toList();
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<String> update(String id, Map<String, dynamic> tagDelta) async {
    try {
      String deltaJson = jsonEncode(tagDelta);
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}${NoteController.NOTES_PREFIX}/tag/$id";
      Loggy.v(message: "Going to send PATCH to " + url);
      Response updateResult = await dio.patch(
        url,
        data: deltaJson,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
          "($id tag-update) Server responded with (${updateResult
              .statusCode}): " +
              updateResult.data);
      return NoteController.handleResponse(updateResult);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<String>> listDeleted(List<String> localIdList) async {
    try {
      String idListJson = jsonEncode(localIdList);
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}${NoteController.NOTES_PREFIX}/tag/deleted";
      Loggy.v(message: "Going to send POST to " + url);
      Response listResult = await dio.post(
        url,
        data: idListJson,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
              "(tag-listDeleted) Server responded with (${listResult.statusCode})}: " +
                  listResult.data.toString());
      NoteController.handleResponse(listResult);
      List<dynamic> data = listResult.data;
      return data.map((id) => id.toString()).toList();
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Map<String, dynamic> toSync(Tag tag) {
    Map<String, dynamic> jsonMap = tag.toJson();
    Map<String, dynamic> newMap = Map();
    jsonMap.forEach((key, value) {
      var newValue = value;
      var newKey = ReCase(key).snakeCase;
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return newMap;
  }

  static Tag fromSync(Map<String, dynamic> jsonMap) {
    Map<String, dynamic> newMap = Map();
    jsonMap.forEach((key, value) {
      var newValue = value;
      var newKey = ReCase(key).camelCase;
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return Tag.fromJson(newMap);
  }
}
