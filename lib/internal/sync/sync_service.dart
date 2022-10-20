import 'dart:convert';

import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/blob.dart';
import 'package:potato_notes/internal/sync/blob_service.dart';

class SyncServive {
  Note noteFromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      starred: json['starred'] as bool,
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(json['creationDate'] as int),
      color: json['color'] as int,
      images: (json['images'] as List<dynamic>).cast<String>(),
      list: json['list'] as bool,
      listContent: (json['listContent'] as List<dynamic>)
          .map((item) => ListItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(e as int))
          .toList(),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      hideContent: json['hideContent'] as bool,
      lockNote: json['lockNote'] as bool,
      usesBiometrics: json['usesBiometrics'] as bool,
      folder: json['folder'] as String,
      lastChanged:
          DateTime.fromMillisecondsSinceEpoch(json['lastChanged'] as int),
      lastSynced: json['lastSynced'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSynced'] as int)
          : null,
      deleted: json['deleted'] as bool?,
      archived: json['archived'] as bool?,
    );
  }

  Future sync() async {
    // Step 1: Fetch all data from the server
    final List<Blob> serverBlobs = await SyncBlobService().getAllBlobs();

    await syncItems<Note>(
      serverBlobs: serverBlobs,
      blobType: "note",
      localItems: await noteHelper.listNotes(BuiltInFolders.all),
      getId: (note) => note.id,
      getLastChanged: (note) => note.lastChanged,
      fromJson: (json) => noteFromJson(json),
      toJson: (note) => note.toJson(),
      save: (note) => noteHelper.saveNote(note),
    );

    await syncItems<Folder>(
      serverBlobs: serverBlobs,
      blobType: "folder",
      localItems: await folderHelper.listFolders(),
      getId: (folder) => folder.id,
      getLastChanged: (folder) => folder.lastChanged,
      fromJson: (json) => Folder.fromJson(json),
      toJson: (folder) => folder.toJson(),
      save: (folder) => folderHelper.saveFolder(folder),
    );

    await syncItems<Tag>(
      serverBlobs: serverBlobs,
      blobType: "tag",
      localItems: await tagHelper.listTags(TagReturnMode.local),
      getId: (tag) => tag.id,
      getLastChanged: (tag) => tag.lastChanged,
      fromJson: (json) => Tag.fromJson(json),
      toJson: (tag) => tag.toJson(),
      save: (tag) => tagHelper.saveTag(tag),
    );

    await syncItems<NoteImage>(
      serverBlobs: serverBlobs,
      blobType: "image",
      localItems: await imageHelper.listAllImages(),
      getId: (noteImage) => noteImage.id,
      getLastChanged: (noteImage) => noteImage.lastChanged,
      fromJson: (json) => NoteImage.fromJson(json),
      toJson: (noteImage) => noteImage.toJson(),
      save: (noteImage) => imageHelper.saveImage(noteImage),
    );
    //Syncing is done
  }

  Future syncItems<T>({
    required List<Blob> serverBlobs,
    required String blobType,
    required List<T> localItems,
    required String Function(T) getId,
    required DateTime Function(T) getLastChanged,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    required Future Function(T) save,
  }) async {
    List<Blob> serverNotes =
        serverBlobs.where((blob) => blob.blobType == blobType).toList();

    for (Blob blob in serverNotes) {
      if (localItems.any((T t) => getId(t) == blob.id)) {
        T localItem = localItems.firstWhere((T t) => getId(t) == blob.id);

        print("$blobType ${getId(localItem)} will be checked");

        // Step 2: Compare the local dates against the server dates
        if (!getLastChanged(localItem).isBefore(blob.lastChanged)) {
          continue;
        }
        print("$blobType ${getId(localItem)} will be updated");
      }

      final json = jsonDecode(blob.content) as Map<String, dynamic>;

      final updatedBlob = fromJson(json);
      // Step 3: If the item on server is newer, save it on client
      await save(updatedBlob);
    }

    for (T localItem in localItems) {
      // Step 4: Check if the item exists on the server already
      if (serverNotes.any((Blob blob) => getId(localItem) == blob.id)) {
        Blob blob =
            serverNotes.firstWhere((blob) => getId(localItem) == blob.id);

        // If the item is newer or as old as the one on the server, dont do anything.
        if (getLastChanged(localItem).millisecondsSinceEpoch <=
            blob.lastChanged.millisecondsSinceEpoch) {
          continue;
        }
      }

      // Create blob
      final blob = Blob(getId(localItem), jsonEncode(toJson(localItem)),
          blobType, getLastChanged(localItem));
      // Step 5: If the note at the client is newer or doesnt exist,
      // Upsert (Insert or Update) the blob at the server
      print("$blobType ${getId(localItem)} will be uploaded to server");
      await SyncBlobService().upsertBlob(blob);
    }
  }
}
