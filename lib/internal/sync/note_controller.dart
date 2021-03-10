import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class NoteController {
  static const notesPrefix = "/notes";

  NoteController._();

  static Future<String> add(Note note) async {
    try {
      final String token = await prefs.getToken();
      final String noteJson = json.encode(note.toSyncMap());
      final String url = "${prefs.apiUrl}$notesPrefix/note";
      Loggy.v(message: "Going to send POST to $url");
      final Response addResult = await dio.post(
        url,
        data: noteJson,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(${note.id} add) Server responded with {${addResult.statusCode}): ${addResult.data}",
      );
      return handleResponse(addResult);
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> delete(String id) async {
    try {
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}$notesPrefix/note/$id";
      Loggy.v(message: "Goind to send DELETE to $url");
      final Response deleteResponse = await dio.delete(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "($id delete) Server responded with (${deleteResponse.statusCode}}: ${deleteResponse.data}",
      );
      return handleResponse(deleteResponse);
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> deleteAll() async {
    try {
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}$notesPrefix/note/all";
      Loggy.v(message: "Going to send DELETE to $url");
      final Response deleteResult = await dio.delete(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(delete-all) Server responded with (${deleteResult.statusCode}: ${deleteResult.data}",
      );
      return handleResponse(deleteResult);
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Note>> list(int lastUpdated) async {
    final List<Note> notes = [];
    try {
      final String token = await prefs.getToken();
      final String url =
          "${prefs.apiUrl}$notesPrefix/note/list?last_updated=$lastUpdated";
      Loggy.v(message: "Going to send GET to $url");
      final Response listResult = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      Loggy.d(
        message:
            "(list) Server responded with (${listResult.statusCode}): ${listResult.data}",
      );
      handleResponse(listResult);
      final List<Map<String, dynamic>> _notes =
          Utils.asList<Map<String, dynamic>>(listResult.data["notes"]);
      for (final Map<String, dynamic> _note in _notes) {
        final Note note = NoteX.fromSyncMap(_note);
        notes.add(note.copyWith(synced: true));
      }
      return notes;
    } on SocketException {
      throw "Could not connect to server";
    }
  }

  static Future<String> update(
      String id, Map<String, dynamic> noteDelta) async {
    try {
      final String deltaJson = jsonEncode(noteDelta);
      final String token = await prefs.getToken();
      final String url = "${prefs.apiUrl}$notesPrefix/note/$id";
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
            "($id update) Server responded with (${updateResult.statusCode}): ${updateResult.data}",
      );
      return handleResponse(updateResult);
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
      final String url = "${prefs.apiUrl}$notesPrefix/note/deleted";
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
            "(listDeleted) Server responded with (${listResult.statusCode})}: ${listResult.data}",
      );
      handleResponse(listResult);
      final List<String> idList = (listResult.data["deleted"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      return idList;
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  static String handleResponse(Response response) {
    switch (response.statusCode) {
      case 401:
        throw "Token is not valid";
      default:
        return response.data.toString();
    }
  }
}
