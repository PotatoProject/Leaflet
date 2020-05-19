import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/sync_note.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/interface/note_interface.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../locator.dart';

class NoteController implements NoteInterface{
  Preferences prefs;

  NoteController(){
    this.prefs = locator<Preferences>();
  }

  String toJson(Note note){
    SyncNote savingNote = SyncNote.fromNote(note);
    return json.encode(savingNote);
  }
  @override
  Future<bool> add(Note note) async{
    try{
      String token = await prefs.getToken();
      String json = toJson(note);
      Response addResult = await http.post("${prefs.apiUrl}/api/notes", body: json, headers: {"Authorization": token});
      bool status = Utils.statusFromResponse(addResult);
      return status;
    } catch(e){
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(String id) async{
    // TODO: implement delete
    try{
      String token = await prefs.getToken();
      Response deleteResponse = await http.delete("${prefs.apiUrl}/api/notes/${id}", headers: {"Authorization": token});
      bool status = json.decode(deleteResponse.body)["status"];
      return status;
    } catch (e){
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> list() {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<bool> update(String id, Map<String, dynamic> noteDelta) async{
    try{
      String deltaJson = jsonEncode(noteDelta);
      print(deltaJson);
      String token = await prefs.getToken();
      Response addResult = await http.patch("${prefs.apiUrl}/api/notes/${id}", body: deltaJson, headers: {"Authorization": token});
      print(addResult.body);
      bool status = Utils.statusFromResponse(addResult);
      return status;
    } catch(e){
      print(e.toString());
      return false;
    }
  }
}