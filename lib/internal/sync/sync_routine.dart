import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/sync/image/image_service.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/sync/setting_controller.dart';
import 'package:potato_notes/internal/sync/tag_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class SyncRoutine {
  static const Set<String> settingsToSync = {
    "theme_mode",
    "custom_accent",
    "use_amoled",
    "use_grid",
    "use_custom_accent"
  };
  static final _instance = SyncRoutine._();

  List<Note> localNotes = [];
  List<Note> addedNotes = [];
  List<Note> deletedNotes = [];
  Map<Note, Map<String, dynamic>> updatedNotes = {};
  List<Tag> localTags = [];
  List<Tag> addedTags = [];
  List<Tag> deletedTags = [];
  Map<Tag, Map<String, dynamic>> updatedTags = {};

  factory SyncRoutine() {
    return _instance;
  }

  SyncRoutine._();

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
    if (prefs.accessToken == null) {
      Loggy.d(message: "Tried syncing without accesstoken");
      return false;
    }

    try {
      var url = prefs.apiUrl + NoteController.NOTES_PREFIX + "/secure-ping";
      Loggy.d(message: "Going to send GET to " + url);
      Response securePingResponse =
          await get(url, headers: {"Authorization": prefs.accessToken ?? ""});
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
      throw ("Error when securely pinging server: " + e.toString());
    }
  }

  Future<bool> syncNotes() async {
    // Check if the app is able to access the remote server
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

    List<Note> changedNotes = updatedNotes.keys.toList();
    changedNotes.addAll(addedNotes);
    await ImageService.handleUploads(changedNotes);
    await ImageService.handleUploads(addedNotes);
    addedNotes.clear();
    updatedNotes.clear();
    deletedNotes.clear();
    localNotes.clear();
    addedTags.clear();
    updatedTags.clear();
    deletedTags.clear();
    localTags.clear();

    await updateLists();

    // Send all of the note-related requests to the remote server
    try {
      await sendNoteUpdates();
    } catch (e) {
      return false;
    }
    try {
      await ImageService.handleDeletes();
    } catch (e) {
      return false;
    }

    // Send all of the tag-related requests to the remote server
    try {
      await sendTagUpdates();
    } catch (e) {
      return false;
    }

    addedNotes.clear();
    updatedNotes.clear();
    deletedNotes.clear();
    localNotes.clear();
    addedTags.clear();
    updatedTags.clear();
    deletedTags.clear();
    localTags.clear();

    // Get the last time the client has updated
    int lastUpdated = prefs.lastUpdated;

    // Get a list of tags which have been updated since the client updated
    try {
      var tags = await TagController.list(lastUpdated);
      Loggy.i(
          message: "Got these tags: " + tags.map((tag) => tag.id).join(","));
      for (Tag tag in tags) {
        Loggy.i(message: "Saving tag:" + tag.id);
        await saveSyncedTag(tag);
      }
    } catch (e) {
      Loggy.e(message: e.toString());
      throw ("Failed to list tags: " + e.toString());
    }

    // Get a list of notes which have been updated since the client updated
    var notes = await NoteController.list(lastUpdated);
    Loggy.i(
        message: "Got these notes: " + notes.map((note) => note.id).join(","));
    for (Note note in notes) {
      Loggy.i(message: "Saving note:" + note.id);

      //TODO Add a way of disabling this when adding data saving setting
      /*for (SavedImage savedImage in note.images.data) {
          await ImageService.downloadImage(savedImage);
        }*/
      await saveSyncedNote(note);
    }
    prefs.lastUpdated = DateTime.now().millisecondsSinceEpoch;
    ImageService.handleDownloads(await helper.listNotes(ReturnMode.LOCAL));
    return true;
  }

  static Future<bool> syncNote(Note note) async {
    var synced = await helper.listNotes(ReturnMode.SYNCED);
    try {
      if (synced.indexWhere(
              (syncedNote) => syncedNote.id == note.id + "-synced") !=
          -1) {
        var deletedIdList = await NoteController.listDeleted([note.id]);
        if (deletedIdList.length > 0) {
          Loggy.d(
              message:
                  "Since note is deleted on remote, we should safely remove it");
          Utils.deleteNoteSafely(note);
          return true;
        } else {
          var syncedNote =
              synced.firstWhere((synced) => synced.id == note.id + "-synced");
          if (syncedNote.lastModifyDate == note.lastModifyDate) {
            Loggy.v(message: "Dont need to sync note, it hasnt been updated");
            return true;
          } else {
            var delta = getNoteDelta(note, syncedNote);
            await NoteController.update(note.id, delta);
            await saveSyncedNote(note);
            return true;
          }
        }
      } else {
        return await addNote(note);
      }
    } catch (e) {
      Loggy.e(message: "Could not sync note in background: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> addNote(Note note) async {
    try {
      await NoteController.add(note);
      await saveSyncedNote(note);
      Loggy.i(message: "Added note: " + note.id);
      return true;
    } catch (e) {
      Loggy.e(message: "Failed to add note: " + e.toString());
      return false;
    }
  }

  Future<bool> sendNoteUpdates() async {
    // Send the post requests to add new notes
    for (Note note in addedNotes) {
      if (await addNote(note) == false) {
        return false;
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
        await saveSyncedNote(note);
        Loggy.i(message: "Updated note:" + note.id);
      } catch (e) {
        Loggy.e(message: e);
      }
    });
    deletedNotes.forEach((note) async {
      var localNoteId = note.id.replaceFirst("-synced", "");
      try {
        await NoteController.delete(localNoteId);
        await deleteSyncedNote(note);
        Loggy.i(message: "Deleted note: " + localNoteId);
      } catch (e) {
        Loggy.e(message: e.toString());
        throw ("Failed to delete notes: $e");
      }
    });
    return true;
  }

  Future<bool> sendTagUpdates() async {
    // Send the post requests to add new tags
    for (Tag tag in addedTags) {
      try {
        await TagController.add(tag);
        await saveSyncedTag(tag);
        Loggy.i(message: "Added tag: " + tag.id);
      } catch (e) {
        Loggy.e(message: e.toString());
        throw ("Failed to add tags: " + e.toString());
      }
    }
    // Get list of tags which should be deleted on the client since they are deleted on the remote server
    try {
      var deletedIdList = await TagController.listDeleted(
          localTags.map((tag) => tag.id).toList());
      deletedIdList.forEach((id) async {
        var localTag = localTags.firstWhere((tag) => tag.id == id);
        await tagHelper.deleteTag(localTag);
        await tagHelper
            .deleteTag(localTag.copyWith(id: localTag.id + "-synced"));
        updatedTags.removeWhere((tag, _delta) => tag.id == localTag.id);
        deletedTags.removeWhere((tag) => tag.id == localTag.id);
      });
    } catch (e) {
      Loggy.e(message: e.toString());
      throw ("Failed to list deleted tags: " + e.toString());
    }
    updatedTags.forEach((tag, delta) async {
      try {
        await TagController.update(tag.id, delta);
        await saveSyncedTag(tag);
        Loggy.i(message: "Updated tag:" + tag.id);
      } catch (e) {
        Loggy.e(message: e);
        throw ("Failed to update tags: $e");
      }
    });
    deletedTags.forEach((tag) async {
      var localTagId = tag.id.replaceFirst("-synced", "");
      try {
        await TagController.delete(localTagId);
        await deleteSyncedTag(tag);
        Loggy.i(message: "Deleted tag: " + localTagId);
      } catch (e) {
        Loggy.e(message: e.toString());
        throw ("Failed to delete tags: $e");
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
      throw ("Failed to get changed settings: $e");
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
          throw ("Failed to save setting: $e");
        }
      }
    }
    prefs.prefs.clearChangedKeys();
  }

  static Future<void> saveSyncedNote(Note note) async {
    await helper.saveNote(note.copyWith(synced: true));
    var syncedNote = note.copyWith(id: note.id + "-synced");
    await helper.saveNote(syncedNote);
  }

  static Future<void> deleteSyncedNote(Note note) async {
    await helper.deleteNote(note);
  }

  static Future<void> saveSyncedTag(Tag tag) async {
    await tagHelper.saveTag(tag);
    var syncedTag = tag.copyWith(id: tag.id + "-synced");
    await tagHelper.saveTag(syncedTag);
  }

  static Future<void> deleteSyncedTag(Tag tag) async {
    await tagHelper.deleteTag(tag);
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

    localTags = await tagHelper.listTags(TagReturnMode.LOCAL);
    List<Tag> syncedTags = await tagHelper.listTags(TagReturnMode.SYNCED);
    localTags.forEach((localTag) {
      var syncedIndex = syncedTags
          .indexWhere((syncedTag) => syncedTag.id == (localTag.id + "-synced"));
      if (syncedIndex == -1) {
        addedTags.add(localTag);
      } else {
        var syncedTag = syncedTags.elementAt(syncedIndex);
        if (syncedTag.lastModifyDate.millisecondsSinceEpoch <
            localTag.lastModifyDate.millisecondsSinceEpoch) {
          updatedTags.putIfAbsent(
              localTag, () => getTagDelta(localTag, syncedTag));
        }
      }
    });
    if (syncedTags.length > 0) {
      syncedTags.forEach((syncedTag) {
        var localIndex = localTags
            .indexWhere((localTag) => localTag.id + "-synced" == syncedTag.id);
        if (localIndex == -1) {
          deletedTags.add(syncedTag);
        }
      });
    }
  }

  static Map<String, dynamic> getNoteDelta(Note localNote, Note syncedNote) {
    Map<String, dynamic> localMap = localNote.toSyncMap();
    Map<String, dynamic> syncedMap = syncedNote.toSyncMap();
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

  static Map<String, dynamic> getTagDelta(Tag localTag, Tag syncedTag) {
    Map<String, dynamic> localMap = TagController.toSync(localTag);
    Map<String, dynamic> syncedMap = TagController.toSync(syncedTag);
    Map<String, dynamic> tagDelta = Map();
    localMap.forEach((key, localValue) {
      if (localValue != syncedMap[key] && (key != "id")) {
        print(key + ":" + localValue.toString());
        tagDelta.putIfAbsent(key, () => localValue);
      }
    });
    return tagDelta;
  }
}
