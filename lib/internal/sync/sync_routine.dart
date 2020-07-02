import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/controller/note_controller.dart';
import 'package:potato_notes/internal/sync/sync_helper.dart';
import 'package:potato_notes/internal/utils.dart';

class SyncRoutine {
  List<Note> addedNotes = List();
  List<Note> deletedNotes = List();
  Map<Note, Map<String, dynamic>> updatedNotes = Map();
  SyncRoutine();

  Future<bool> checkOnlineStatus() async {
    try {
      Response pingResponse = await get(prefs.apiUrl + "/ping");
      if (pingResponse.statusCode != 200) return false;
      if (pingResponse.body != "Pong!") return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Either<Failure, void>> syncNotes() async {
    if(prefs.accessToken == null){
      return Left(Failure("Not logged in"));
    }
    bool status = await checkOnlineStatus();
    if (status != true) return Left(Failure("Could not connect to server"));
    await updateLists();
    var result = await Future(sendUpdates);
    if (result.isLeft()) {
      return result;
    }
    int lastUpdated = prefs.lastUpdated;
    var listResult = await NoteController.list(lastUpdated);
    listResult.fold((error) {
      Loggy.e(message: error);
      return Left(Failure("Failed to list notes: " + error.message));
    }, (notes) async {
      Loggy.i(message: "Got notes: " + notes.map((note) => note.id).join(", "));
      for (Note note in notes) {
        await helper.saveNote(note);
      }
      prefs.lastUpdated = DateTime.now().millisecondsSinceEpoch;
      return Right(null);
    });
    return Left(Failure("SHOULD NOT HAPPEN"));
  }

  Either<Failure, void> sendUpdates() {
    addedNotes.forEach((note) async {
      var result = await NoteController.add(note);
      result.fold((error) {
        Loggy.e(message: error);
        return Left(Failure("Failed to add notes: " + error.message));
      }, (result) {
        saveSynced(note);
        Loggy.i(message: "Added note: " + note.id);
        Loggy.i(message: "Response from server: " + result);
      });
    });
    updatedNotes.forEach((note, delta) async {
      var result = await NoteController.update(note.id, delta);
      result.fold((error) {
        Loggy.e(message: error);
        return Left(Failure("Failed to update notes: " + error.message));
      }, (result) {
        saveSynced(note);
        Loggy.i(message: "Updated note:" + note.id);
        Loggy.i(message: "Response from server: " + result);
      });
    });
    deletedNotes.forEach((note) async {
      var localNoteId = note.id.replaceFirst("-synced", "");
      var result = await NoteController.delete(localNoteId);
      result.fold((error) {
        Loggy.e(message: error);
        return Left(Failure("Failed to delete notes: " + error.message));
      }, (result) {
        deleteSynced(note);
        Loggy.i(message: "Deleted note: " + localNoteId);
        Loggy.i(message: "Response from server: " + result);
      });
    });
    addedNotes.clear();
    updatedNotes.clear();
    deletedNotes.clear();
    return Right(null);
  }

  void saveSynced(Note note) {
    helper.saveNote(note.copyWith(synced: true));
    var syncedNote = note.copyWith(id: note.id + "-synced");
    helper.saveNote(syncedNote);
  }

  void deleteSynced(Note note) async {
    helper.deleteNote(note);
  }

  Future<void> updateLists() async {
    List<Note> localNotes = await helper.listNotes(ReturnMode.LOCAL);
    List<Note> syncedNotes = await helper.listNotes(ReturnMode.SYNCED);
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
