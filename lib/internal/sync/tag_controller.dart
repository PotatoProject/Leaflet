import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:recase/recase.dart';

class TagController {
  static Future<String> add(Tag tag) async {
    try {
      final String token = await prefs.getToken();
      final String tagJson = json.encode(toSync(tag));
      final String url = "${prefs.apiUrl}${NoteController.notesPrefix}/tag";
      Loggy.v(message: "Going to send POST to $url");
      final Response addResult = await dio.post(
        url,
        data: tagJson,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(${tag.id} tag-add) Server responded with (${addResult.statusCode}): ${addResult.data}",
      );
      return NoteController.handleResponse(addResult);
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> delete(String id) async {
    try {
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}${NoteController.notesPrefix}/tag/$id";
      Loggy.v(message: "Goind to send DELETE to $url");
      final Response deleteResponse = await dio.delete(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "($id tag-delete) Server responded with (${deleteResponse.statusCode}}: ${deleteResponse.data}",
      );
      return NoteController.handleResponse(deleteResponse);
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Tag>> list(int lastUpdated) async {
    try {
      final String token = await prefs.getToken();
      final String url =
          "${prefs.apiUrl}${NoteController.notesPrefix}/tag/list?last_updated=$lastUpdated";
      Loggy.v(message: "Going to send GET to $url");

      final Response listResult = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(tag-list) Server responded with (${listResult.statusCode}): ${listResult.data}",
      );
      final List<Map<String, dynamic>> body =
          Utils.asList<Map<String, dynamic>>(
        json.decode(NoteController.handleResponse(listResult)),
      );
      final List<Tag> tags = body.map((map) {
        final Tag tag = fromSync(map);
        return tag;
      }).toList();
      return tags.map((tag) => tag).toList();
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> update(String id, Map<String, dynamic> tagDelta) async {
    try {
      final String deltaJson = jsonEncode(tagDelta);
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}${NoteController.notesPrefix}/tag/$id";
      Loggy.v(message: "Going to send PATCH to $url");
      final Response updateResult = await dio.patch(
        url,
        data: deltaJson,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "($id tag-update) Server responded with (${updateResult.statusCode}): ${updateResult.data}",
      );
      return NoteController.handleResponse(updateResult);
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> listDeleted(List<String> localIdList) async {
    try {
      final String idListJson = jsonEncode(localIdList);
      final String token = await prefs.getToken();
      final String url =
          "${prefs.apiUrl}${NoteController.notesPrefix}/tag/deleted";
      Loggy.v(message: "Going to send POST to $url");
      final Response listResult = await dio.post(
        url,
        data: idListJson,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(tag-listDeleted) Server responded with (${listResult.statusCode})}: ${listResult.data}",
      );
      NoteController.handleResponse(listResult);
      final List<dynamic> data = listResult.data as List<dynamic>;
      return data.map((id) => id.toString()).toList();
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Map<String, dynamic> toSync(Tag tag) {
    final Map<String, dynamic> jsonMap = tag.toJson();
    final Map<String, dynamic> newMap = {};
    jsonMap.forEach((key, value) {
      final Object newValue = value;
      final String newKey = ReCase(key).snakeCase;
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return newMap;
  }

  static Tag fromSync(Map<String, dynamic> jsonMap) {
    final Map<String, dynamic> newMap = {};
    jsonMap.forEach((key, value) {
      final String newValue = value as String;
      final String newKey = ReCase(key).camelCase;
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return Tag.fromJson(newMap);
  }
}
