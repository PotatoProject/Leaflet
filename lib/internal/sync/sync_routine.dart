import 'package:http/http.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/controller/note_controller.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';

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
    bool status = await checkOnlineStatus();
    if (status != true) return;
    await updateLists();
    addedNotes.forEach((note) {
      noteController.add(note).then((result) {
        print("Added note: " + note.id);
        if (result == true) {
          saveSynced(note);
        }
      });
    });
    updatedNotes.forEach((note, delta) {
      noteController.update(note.id, delta).then((result) {
        print("Updated note:" + note.id);
        if (result == true) {
          saveSynced(note);
        }
      });
    });
    deletedNotes.forEach((note) {
      var localNoteId = note.id.replaceFirst("-synced", "");
      noteController.delete(localNoteId).then((result) {
        print("Deleted note: " + localNoteId);
        if (result == true) {
          deleteSynced(note);
        }
      });
    });
    addedNotes.clear();
    updatedNotes.clear();
    deletedNotes.clear();
  }

  void sendRequests() {}

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
      var syncedIndex = syncedNotes.indexWhere(
          (syncedNote) => syncedNote.id == localNote.id + "-synced");
      if (syncedIndex == -1) {
        addedNotes.add(localNote);
      } else {
        var syncedNote = syncedNotes.elementAt(syncedIndex);
        if (!localNote.synced) {
          updatedNotes.putIfAbsent(
              localNote, () => getNoteDelta(localNote, syncedNote));
        }
      }
    });
    if (syncedNotes.length > 0) {
      syncedNotes.forEach((syncedNote) {
        var localIndex = localNotes.indexWhere(
            (localNote) => localNote.id + "-synced" == syncedNote.id);
        if (localIndex == -1) {
          deletedNotes.add(syncedNote);
        }
      });
    }
  }

  Map<String, dynamic> getNoteDelta(Note localNote, Note syncedNote) {
    Map<String, dynamic> localMap = Utils.toSyncMap(localNote);
    Map<String, dynamic> syncedMap = Utils.toSyncMap(syncedNote);
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
