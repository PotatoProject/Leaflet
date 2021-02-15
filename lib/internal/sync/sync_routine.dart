import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/image_helper.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/sync/setting_controller.dart';
import 'package:potato_notes/internal/sync/tag_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class SyncRoutine {
  static const Set<String> settingsToSync = {
    "custom_accent",
    "use_amoled",
    "use_grid",
    "use_custom_accent"
  };
  static final SyncRoutine instance = SyncRoutine._();

  final List<Note> localNotes = [];
  final List<Note> addedNotes = [];
  final List<Note> deletedNotes = [];
  final Map<Note, Map<String, dynamic>> updatedNotes = {};
  final List<Tag> localTags = [];
  final List<Tag> addedTags = [];
  final List<Tag> deletedTags = [];
  final Map<Tag, Map<String, dynamic>> updatedTags = {};

  SyncRoutine._();

  static Future<bool> checkOnlineStatus() async {
    try {
      final String url = prefs.apiUrl + "/notes/ping";
      Loggy.d(message: "Going to send GET to " + url);
      final Response pingResponse = await dio.get(url);
      if (pingResponse.statusCode != 200) {
        Loggy.e(message: "Server did not respond with 200 on ping");
        return false;
      }
      if (pingResponse.data != "Pong!") {
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
      final String url =
          prefs.apiUrl + NoteController.NOTES_PREFIX + "/secure-ping";
      Loggy.d(message: "Going to send GET to " + url);
      final Response securePingResponse = await dio.get(url,
          options: Options(headers: {"Authorization": prefs.accessToken}));
      if (securePingResponse.statusCode == 401) {
        Loggy.e(message: "Token is not valid");
        return false;
      }
      if (securePingResponse.statusCode != 200) {
        Loggy.e(message: "Server did not respond with 200 on ping");
        return false;
      }
      if (securePingResponse.data != "Pong!") {
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
    final bool status = await checkOnlineStatus();
    if (status != true) throw ("Could not connect to server");
    final bool secureStatus = await checkLoginStatus();
    if (secureStatus != true) {
      throw ("Not logged in!");
    }
    imageQueue.uploadQueue.clear();
    await imageQueue.fillUploadQueue();
    await imageQueue.process();
    // Receive and send changes from API
    await sendSettingUpdates();

    // Fill the list of added, deleted and updated notes to create a local cache
    await updateLists();

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
    final int lastUpdated = prefs.lastUpdated;

    // Get a list of tags which have been updated since the client updated
    try {
      final List<Tag> tags = await TagController.list(lastUpdated);
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
    final List<Note> notes = await NoteController.list(lastUpdated);
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
    await ImageHelper.handleDownloads(await helper.listNotes(ReturnMode.LOCAL));
    return true;
  }

  static Future<bool> syncNote(Note note) async {
    final List<Note> synced = await helper.listNotes(ReturnMode.SYNCED);
    try {
      if (synced.indexWhere(
              (syncedNote) => syncedNote.id == note.id + "-synced") !=
          -1) {
        final List<String> deletedIdList =
            await NoteController.listDeleted([note.id]);
        if (deletedIdList.length > 0) {
          Loggy.d(
              message:
                  "Since note is deleted on remote, we should safely remove it");
          Utils.deleteNoteSafely(note);
          return true;
        } else {
          final Note syncedNote =
              synced.firstWhere((synced) => synced.id == note.id + "-synced");
          if (syncedNote.lastModifyDate == note.lastModifyDate) {
            Loggy.v(message: "Dont need to sync note, it hasnt been updated");
            return true;
          } else {
            final Map<String, dynamic> delta = getNoteDelta(note, syncedNote);
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
      final List<String> deletedIdList = await NoteController.listDeleted(
          localNotes.map((note) => note.id).toList());
      deletedIdList.forEach((id) async {
        final Note localNote = localNotes.firstWhere((note) => note.id == id);
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
      final String localNoteId = note.id.replaceFirst("-synced", "");
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
      final List<String> deletedIdList = await TagController.listDeleted(
          localTags.map((tag) => tag.id).toList());
      deletedIdList.forEach((id) async {
        final Tag localTag = localTags.firstWhere((tag) => tag.id == id);
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
        throw ("Failed to update tags: " + e);
      }
    });
    deletedTags.forEach((tag) async {
      final String localTagId = tag.id.replaceFirst("-synced", "");
      try {
        await TagController.delete(localTagId);
        await deleteSyncedTag(tag);
        Loggy.i(message: "Deleted tag: " + localTagId);
      } catch (e) {
        Loggy.e(message: e.toString());
        throw ("Failed to delete tags: " + e);
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
      final Object original = prefs.getFromCache(key);
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

    final List<String> keys = prefs.prefs.getChangedKeys();

    for (final String key in keys) {
      if (settingsToSync.contains(key) && !changedSettings.keys.contains(key)) {
        try {
          Loggy.v(message: "Preparing to save $key");
          Object value = prefs.getFromCache(key);
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
  }

  static Future<void> saveSyncedNote(Note note) async {
    await helper.saveNote(note.copyWith(synced: true));
    final Note syncedNote = note.copyWith(id: note.id + "-synced");
    await helper.saveNote(syncedNote);
  }

  static Future<void> deleteSyncedNote(Note note) async {
    await helper.deleteNote(note);
  }

  static Future<void> saveSyncedTag(Tag tag) async {
    await tagHelper.saveTag(tag);
    final Tag syncedTag = tag.copyWith(id: tag.id + "-synced");
    await tagHelper.saveTag(syncedTag);
  }

  static Future<void> deleteSyncedTag(Tag tag) async {
    await tagHelper.deleteTag(tag);
  }

  Future<void> updateLists() async {
    localNotes.clear();
    localNotes.addAll(await helper.listNotes(ReturnMode.LOCAL));
    final List<Note> syncedNotes = await helper.listNotes(ReturnMode.SYNCED);
    localNotes.forEach((localNote) {
      final int syncedIndex = syncedNotes.indexWhere(
          (syncedNote) => syncedNote.id == localNote.id + "-synced");
      if (syncedIndex == -1) {
        addedNotes.add(localNote);
      } else {
        final Note syncedNote = syncedNotes.elementAt(syncedIndex);
        if (!localNote.synced) {
          updatedNotes.putIfAbsent(
              localNote, () => getNoteDelta(localNote, syncedNote));
        }
      }
    });
    if (syncedNotes.length > 0) {
      syncedNotes.forEach((syncedNote) {
        final int localIndex = localNotes.indexWhere(
            (localNote) => localNote.id + "-synced" == syncedNote.id);
        if (localIndex == -1) {
          deletedNotes.add(syncedNote);
        }
      });
    }

    localTags.clear();
    localTags.addAll(await tagHelper.listTags(TagReturnMode.LOCAL));
    final List<Tag> syncedTags = await tagHelper.listTags(TagReturnMode.SYNCED);
    localTags.forEach((localTag) {
      final int syncedIndex = syncedTags
          .indexWhere((syncedTag) => syncedTag.id == (localTag.id + "-synced"));
      if (syncedIndex == -1) {
        addedTags.add(localTag);
      } else {
        final Tag syncedTag = syncedTags.elementAt(syncedIndex);
        if (syncedTag.lastModifyDate.millisecondsSinceEpoch <
            localTag.lastModifyDate.millisecondsSinceEpoch) {
          updatedTags.putIfAbsent(
              localTag, () => getTagDelta(localTag, syncedTag));
        }
      }
    });
    if (syncedTags.length > 0) {
      syncedTags.forEach((syncedTag) {
        final int localIndex = localTags
            .indexWhere((localTag) => localTag.id + "-synced" == syncedTag.id);
        if (localIndex == -1) {
          deletedTags.add(syncedTag);
        }
      });
    }
  }

  static Map<String, dynamic> getNoteDelta(Note localNote, Note syncedNote) {
    final Map<String, dynamic> localMap = localNote.toSyncMap();
    final Map<String, dynamic> syncedMap = syncedNote.toSyncMap();
    final Map<String, dynamic> noteDelta = {};
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
    final Map<String, dynamic> localMap = TagController.toSync(localTag);
    final Map<String, dynamic> syncedMap = TagController.toSync(syncedTag);
    final Map<String, dynamic> tagDelta = {};
    localMap.forEach((key, localValue) {
      if (localValue != syncedMap[key] && (key != "id")) {
        print(key + ":" + localValue.toString());
        tagDelta.putIfAbsent(key, () => localValue);
      }
    });
    return tagDelta;
  }
}
