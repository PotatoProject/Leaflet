import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/interface/note_interface.dart';
import 'package:potato_notes/internal/sync/sync_helper.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:http/http.dart' as http;

class NoteController implements NoteInterface {
  @override
  static Future<Either<Failure, String>> add(Note note) async {
    try {
      String token = await prefs.getToken();
      String noteJson = json.encode(Utils.toSyncMap(note));
      Response addResult = await http.post("${prefs.apiUrl}/api/notes",
          body: noteJson, headers: {"Authorization": token});
      Loggy.d(message: note.id + " add:" + addResult.body);
      return handleResponse(addResult);
    } on SocketException {
      return Left(Failure("Could not connect to server"));
    }
  }

  @override
  static Future<Either<Failure, String>> delete(String id) async {
    try {
      String token = await prefs.getToken();
      Response deleteResponse = await http.delete(
          "${prefs.apiUrl}/api/notes/${id}",
          headers: {"Authorization": token});
      Loggy.d(message: id + " delete:" + deleteResponse.body);
      return handleResponse(deleteResponse);
    } on SocketException {
      return Left(Failure("Could not connect to server"));
    }
  }

  @override
  static Future<Either<Failure, String>> deleteAll() async {
    try {
      String token = await prefs.getToken();
      Response deleteResult = await http.delete("${prefs.apiUrl}/api/notes/all",
          headers: {"Authorization": token});
      Loggy.d(message: "delete-all: " + deleteResult.body);
      return handleResponse(deleteResult);
    } on SocketException {
      return Left(Failure("Could not connect to server"));
    }
  }

  @override
  static Future<Either<Failure, List<Note>>> list(int lastUpdated) async {
    List<Note> notes = List();
    try {
      String token = await prefs.getToken();
      Response listResult = await http.get(
          "${prefs.apiUrl}/api/notes/list?last_updated=$lastUpdated",
          headers: {"Authorization": token});
      Loggy.d(message: "list: " + listResult.body);
      var error = handleResponse(listResult);
      return error.fold((error) {
        return Left(error);
      }, (result) {
        final data = jsonDecode(listResult.body);
        for (Map i in data["notes"]) {
          print(i);
          var note = Utils.fromSyncMap(i);
          notes.add(note.copyWith(synced: true));
        }
        return Right(notes);
      });
    } on SocketException {
      return Left(Failure("Could not connect to server"));
    }
  }

  @override
  static Future<Either<Failure, String>> update(
      String id, Map<String, dynamic> noteDelta) async {
    try {
      String deltaJson = jsonEncode(noteDelta);
      print(deltaJson);
      String token = await prefs.getToken();
      Response updateResult = await http.patch(
          "${prefs.apiUrl}/api/notes/${id}",
          body: deltaJson,
          headers: {"Authorization": token});
      Loggy.d(message: id + " update:" + updateResult.body);
      return handleResponse(updateResult);
    } on SocketException {
      return Left(Failure("Could not connect to server"));
    }
  }

  static Either<Failure, String> handleResponse(Response response) {
    switch (response.statusCode) {
      case 401:
        {
          return Left(Failure("Token is not valid"));
        }
      case 400:
        {
          var data = json.decode(response.body);
          return Left(Failure(data["message"]));
        }
      case 200:
        {
          var data = json.decode(response.body);
          return Right(data["message"]);
        }
    }
  }
}
