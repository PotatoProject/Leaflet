import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/sync_note.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/controller/note_controller.dart';
import 'package:potato_notes/locator.dart';
import 'package:provider/provider.dart';

class SyncRoutine {
  List<Note> addedNotes = List();
  List<Note> deletedNotes = List();
  Map<Note, Map<String, dynamic>> updatedNotes = Map();
  Preferences preferences;
  NoteHelper noteHelper;
  NoteController noteController;

  SyncRoutine() {
    this.preferences = locator<Preferences>();
    this.noteHelper = locator<NoteHelper>();
    this.noteController = locator<NoteController>();
  }

  Future<bool> checkOnlineStatus() async {
    try {
      Response pingResponse = await get(preferences.apiUrl + "/ping");
      if (pingResponse.statusCode != 200) return false;
      if (pingResponse.body != "Pong!") return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncNotes() async {
    if (await checkOnlineStatus() != true) {
      return;
    }
    await updateLists();
    addedNotes.forEach((note) async {
      bool result = await noteController.add(note);
      if (result == true) {
        saveSynced(note);
      }
    });
    updatedNotes.forEach((note, delta) async {
      bool result = await noteController.update(note.id, delta);
      if (result == true) {
        saveSynced(note);
      }
    });
    deletedNotes.forEach((note) async {
      bool result = await noteController.delete(note.id);
      if (result == true) {
        deleteSynced(note);
      }
    });
  }

  void saveSynced(Note note) {
    noteHelper.saveNote(note.copyWith(synced: true));
    var synced_note = note.copyWith(id: note.id + "-synced");
    noteHelper.saveNote(synced_note);
  }

  void deleteSynced(Note note) async {
    noteHelper.deleteNote(note);
  }

  Future<void> updateLists() async {
    List<Note> localNotes = await noteHelper.listNotes(ReturnMode.LOCAL);
    List<Note> syncedNotes = await noteHelper.listNotes(ReturnMode.SYNCED);
    localNotes.forEach((localNote) {
      Note syncedNote;
      if (syncedNotes.length > 0) {
        syncedNote = syncedNotes.firstWhere(
            (syncedNote) => syncedNote.id == localNote.id + "-synced");
      }
      if (syncedNote == null) {
        addedNotes.add(localNote);
      } else {
        if (localNote.lastModifyDate.isAfter(syncedNote.lastModifyDate)) {
          updatedNotes.putIfAbsent(
              localNote, () => getNoteDelta(localNote, syncedNote));
        }
      }
    });
    if (syncedNotes.length > 0) {
      syncedNotes.forEach((syncedNote) {
        Note localNote = localNotes.firstWhere(
            (localNote) => localNote.id + "-synced" == syncedNote.id);
        if (localNote == null) {
          deletedNotes.add(syncedNote);
        }
      });
    }
  }

  Map<String, dynamic> getNoteDelta(Note localNote, Note syncedNote) {
    Map<String, dynamic> localMap = SyncNote.fromNote(localNote).toJson();
    Map<String, dynamic> syncedMap = SyncNote.fromNote(syncedNote).toJson();
    Map<String, dynamic> noteDelta = Map();
    localMap.forEach((key, localValue) {
      if (localValue != syncedMap[key] &&
          (key != "note_id" && key != "synced")) {
        print(key + ":" + localValue.toString());
        noteDelta.putIfAbsent(key, () => localValue);
      }
    });
    return noteDelta;
  }
}
