import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/interface/note_interface.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../locator.dart';

class NoteController implements NoteInterface {
  Preferences prefs;

  NoteController() {
    this.prefs = locator<Preferences>();
  }

  @override
  Future<bool> add(Note note) async {
    try {
      String token = await prefs.getToken();
      String noteJson = json.encode(Utils.toSyncMap(note));
      Response addResult = await http.post("${prefs.apiUrl}/api/notes",
          body: noteJson, headers: {"Authorization": token});
      print(note.id + " add:" + addResult.body);
      bool status = Utils.statusFromResponse(addResult);
      return status;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      String token = await prefs.getToken();
      Response deleteResponse = await http.delete(
          "${prefs.apiUrl}/api/notes/${id}",
          headers: {"Authorization": token});
      print(id + " delete:" + deleteResponse.body);
      bool status = json.decode(deleteResponse.body)["status"];
      return status;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteAll() async {
    try {
      String token = await prefs.getToken();
      Response deleteResult = await http.delete(
          "${prefs.apiUrl}/api/notes/all", headers: {"Authorization": token});
      print("delete-all: " + deleteResult.body);
      bool status = Utils.statusFromResponse(deleteResult);
      return status;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<List<Note>> list(int lastUpdated) async {
    List<Note> notes = List();
    try {
      String token = await prefs.getToken();
      Response listResult = await http.get(
          "${prefs.apiUrl}/api/notes/list?last_updated=$lastUpdated",
          headers: {"Authorization": token});
      print("list: " + listResult.body);
      bool status = Utils.statusFromResponse(listResult);
      if (status == true) {
        final data = jsonDecode(listResult.body);
        for (Map i in data["notes"]) {
          print(i);
          var note = Utils.fromSyncMap(i);
          notes.add(note.copyWith(synced: true));
        }
        return notes;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> update(String id, Map<String, dynamic> noteDelta) async {
    try {
      String deltaJson = jsonEncode(noteDelta);
      print(deltaJson);
      String token = await prefs.getToken();
      Response updateResult = await http.patch(
          "${prefs.apiUrl}/api/notes/${id}",
          body: deltaJson, headers: {"Authorization": token});
      print(id + " update:" + updateResult.body);
      bool status = Utils.statusFromResponse(updateResult);
      return status;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
