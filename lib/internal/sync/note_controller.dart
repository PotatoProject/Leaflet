import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class NoteController {
  static const NOTES_PREFIX = "/notes";

  static Future<String> add(Note note) async {
    try {
      String token = await prefs.getToken();
      String noteJson = json.encode(note.toSyncMap());
      var url = "${prefs.apiUrl}$NOTES_PREFIX/note";
      Loggy.v(message: "Going to send POST to " + url);
      Response addResult = await dio.post(
        url,
        data: noteJson,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
              "(${note.id} add) Server responded with {${addResult.statusCode}): " +
                  addResult.data);
      return handleResponse(addResult);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<String> delete(String id) async {
    try {
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}$NOTES_PREFIX/note/$id";
      Loggy.v(message: "Goind to send DELETE to " + url);
      Response deleteResponse = await dio.delete(
        url,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
          "($id delete) Server responded with (${deleteResponse
              .statusCode}}: " +
              deleteResponse.data);
      return handleResponse(deleteResponse);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<String> deleteAll() async {
    try {
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}$NOTES_PREFIX/note/all";
      Loggy.v(message: "Going to send DELETE to " + url);
      Response deleteResult = await dio.delete(
        url,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
          "(delete-all) Server responded with (${deleteResult.statusCode}: " +
              deleteResult.data);
      return handleResponse(deleteResult);
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<Note>> list(int lastUpdated) async {
    List<Note> notes = [];
    try {
      String token = await prefs.getToken();
      var url =
          "${prefs.apiUrl}$NOTES_PREFIX/note/list?last_updated=$lastUpdated";
      Loggy.v(message: "Going to send GET to " + url);
      Response listResult = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message: "(list) Server responded with (${listResult.statusCode}): " +
              listResult.data);
      var body = handleResponse(listResult);
      final data = jsonDecode(body);
      for (Map i in data["notes"]) {
        print(i);
        var note = NoteX.fromSyncMap(i);
        notes.add(note.copyWith(synced: true));
      }
      return notes;
    } on SocketException {
      throw ("Could not connect to server");
    }
  }

  static Future<String> update(
      String id, Map<String, dynamic> noteDelta) async {
    try {
      String deltaJson = jsonEncode(noteDelta);
      print(deltaJson);
      String token = await prefs.getToken();
      var url = "${prefs.apiUrl}$NOTES_PREFIX/note/$id";
      Loggy.v(message: "Going to send PATCH to " + url);
      Response updateResult = await dio.patch(
        url,
        data: deltaJson,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
          "($id update) Server responded with (${updateResult.statusCode}): " +
              updateResult.data);
      return handleResponse(updateResult);
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
      var url = "${prefs.apiUrl}$NOTES_PREFIX/note/deleted";
      Loggy.v(message: "Going to send POST to " + url);
      Response listResult = await dio.post(
        url,
        data: idListJson,
        options: Options(headers: {"Authorization": "Bearer " + token}),
      );
      Loggy.d(
          message:
          "(listDeleted) Server responded with (${listResult.statusCode})}: " +
              listResult.data);
      handleResponse(listResult);
      Map<String, dynamic> response = json.decode(listResult.data);
      List<String> idList =
      (response["deleted"] as List).map((e) => e.toString()).toList();
      return idList;
    } on SocketException {
      throw ("Could not connect to server");
    } catch (e) {
      throw (e);
    }
  }

  static String handleResponse(Response response) {
    switch (response.statusCode) {
      case 401:
        throw ("Token is not valid");
      case 200:
        return response.data;
      default:
        throw (response.data);
    }
  }
}
