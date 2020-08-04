import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/sync/setting_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class SyncRoutine {
  static const Set<String> settingsToSync = {
    "theme_mode",
    "custom_accent",
    "use_amoled",
    "use_grid",
    "use_custom_accent"
  };
  List<Note> localNotes = List();
  List<Note> addedNotes = List();
  List<Note> deletedNotes = List();
  Map<Note, Map<String, dynamic>> updatedNotes = Map();

  SyncRoutine();

  static Future<bool> checkOnlineStatus() async {
    try {
      var url = prefs.apiUrl + "/notes/ping";
      Loggy.d(message: "Going to send GET to " + url);
      Response pingResponse = await get(url);
      if (pingResponse.statusCode != 200) {
        Loggy.e(message: "Server did not respond with 200 on ping");
        return false;
      }
      if (pingResponse.body != "Pong!") {
        Loggy.e(message: "Server did not respond with Pong!");
        return false;
      }
      return true;
    } catch (e) {
      Loggy.e(message: "Error when pinging server: " + e.toString());
      return false;
    }
  }

  static Future<bool> checkLoginStatus() async {
    try {
      var url = prefs.apiUrl + NoteController.NOTES_PREFIX + "/secure-ping";
      Loggy.d(message: "Going to send GET to " + url);
      Response securePingResponse =
          await get(url, headers: {"Authorization": prefs.accessToken});
      if (securePingResponse.statusCode == 401) {
        Loggy.e(message: "Token is not valid");
        return false;
      }
      if (securePingResponse.statusCode != 200) {
        Loggy.e(message: "Server did not respond with 200 on ping");
        return false;
      }
      if (securePingResponse.body != "Pong!") {
        Loggy.e(message: "Server did not respond with Pong!");
        return false;
      }
      return true;
    } catch (e) {
      throw ("Error when securely pinging server: " + e);
    }
  }

  Future<bool> syncNotes() async {
    // Check if the app is able to access the remote server
    if (prefs.accessToken == null) {
      Loggy.e(message: "Tried syncing without accesstoken");
      throw ("Not logged in");
    }
    bool status = await checkOnlineStatus();
    if (status != true) throw ("Could not connect to server");
    bool secureStatus = await checkLoginStatus();
    if (secureStatus != true) {
      await AccountController.refreshToken();
      bool secureStatusRetry = await checkLoginStatus();
      if (secureStatusRetry != true) {
        throw ("Not logged in!");
      }
    }
    // Recieve and send changes from API
    await sendSettingUpdates();

    // Fill the list of added, deleted and updated notes to create a local cache
    await updateLists();

    // Send all of the requests to the remote server
    try {
      await sendNoteUpdates();
    } catch (e) {
      return false;
    }
    addedNotes.clear();
    updatedNotes.clear();
    deletedNotes.clear();
    localNotes.clear();

    // Get the last time the client has updated
    int lastUpdated = prefs.lastUpdated;

    // Get a list of notes which have been updated since the client updated
    try {
      var notes = await NoteController.list(lastUpdated);
      Loggy.i(
          message:
              "Got these notes: " + notes.map((note) => note.id).join(","));
      for (Note note in notes) {
        Loggy.i(message: "Saving note:" + note.id);
        await saveSynced(note);
      }
      prefs.lastUpdated = DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      Loggy.e(message: e);
      throw ("Failed to list notes: " + e);
    }
    return true;
  }

  Future<bool> sendNoteUpdates() async {
    // Send the post requests to add new notes
    for (Note note in addedNotes) {
      try {
        await NoteController.add(note);
        await saveSynced(note);
        Loggy.i(message: "Added note: " + note.id);
      } catch (e) {
        Loggy.e(message: e.toString());
        throw ("Failed to add notes: " + e.toString());
      }
    }
    // Get list of notes which should be deleted on the client since they are deleted on the remote server
    try {
      var deletedIdList = await NoteController.listDeleted(
          localNotes.map((note) => note.id).toList());
      deletedIdList.forEach((id) async {
        var localNote = localNotes.firstWhere((note) => note.id == id);
        await helper.deleteNote(localNote);
        await helper
            .deleteNote(localNote.copyWith(id: localNote.id + "-synced"));
        updatedNotes.removeWhere((note, _delta) => note.id == localNote.id);
        deletedNotes.removeWhere((note) => note.id == localNote.id);
      });
    } catch (e) {
      Loggy.e(message: e.toString());
      throw ("Failed to list deleted notes: " + e.toString());
    }
    updatedNotes.forEach((note, delta) async {
      try {
        await NoteController.update(note.id, delta);
        await saveSynced(note);
        Loggy.i(message: "Updated note:" + note.id);
      } catch (e) {
        Loggy.e(message: e);
        throw ("Failed to update notes: " + e);
      }
    });
    deletedNotes.forEach((note) async {
      var localNoteId = note.id.replaceFirst("-synced", "");
      try {
        await NoteController.delete(localNoteId);
        await deleteSynced(note);
        Loggy.i(message: "Deleted note: " + localNoteId);
      } catch (e) {
        Loggy.e(message: e.toString());
        throw ("Failed to delete notes: " + e);
      }
    });
    return true;
  }

  static Future<void> sendSettingUpdates() async {
    Map<String, String> changedSettings;
    try {
      changedSettings = await SettingController.getChanged(prefs.lastUpdated);
    } catch (e) {
      Loggy.e(message: e);
      throw ("Failed to get changed settings: " + e);
    }

    changedSettings.forEach((key, value) {
      var original = prefs.prefs.prefs.get(key);
      switch (original.runtimeType) {
        case String:
          {
            prefs.prefs.prefs.setString(key, value);
            break;
          }
        case bool:
          {
            prefs.prefs.prefs.setBool(key, value == "true");
            break;
          }
        case double:
          {
            prefs.prefs.prefs.setDouble(key, double.parse(value));
            break;
          }
        case int:
          {
            prefs.prefs.prefs.setInt(key, int.parse(value));
            break;
          }
        case List:
          {
            List<String> list = json.decode(value);
            prefs.prefs.prefs.setStringList(key, list);
            break;
          }
      }
    });

    var keys = prefs.prefs.getChangedKeys();

    for (String key in keys) {
      if (settingsToSync.contains(key) && !changedSettings.keys.contains(key)) {
        try {
          Loggy.v(message: "Preparing to save $key");
          var value = prefs.prefs.prefs.get(key);
          if (key == "tags") {
            value = json.encode(value);
          }
          await SettingController.set(key, value.toString());
          Loggy.v(message: "Saved setting $key");
        } catch (e) {
          Loggy.e(message: e);
          throw ("Failed to save setting: " + e);
        }
      }
    }
    prefs.prefs.clearChangedKeys();

    prefs.triggerRefresh();
  }

  static Future<void> saveSynced(Note note) async {
    await helper.saveNote(note.copyWith(synced: true));
    var syncedNote = note.copyWith(id: note.id + "-synced");
    await helper.saveNote(syncedNote);
  }

  static Future<void> deleteSynced(Note note) async {
    helper.deleteNote(note);
  }

  Future<void> updateLists() async {
    localNotes = await helper.listNotes(ReturnMode.LOCAL);
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
