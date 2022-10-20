import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/blob.dart';
import 'package:potato_notes/internal/sync/blob_service.dart';
import 'package:potato_notes/internal/sync/sync_item.dart';

class SyncService {
  static List<SyncItem> syncItems = [
    SyncItem<Note>(
      blobType: "note",
      getLocalItems: () => noteHelper.listNotes(BuiltInFolders.all),
      getId: (note) => note.id,
      getLastChanged: (note) => note.lastChanged,
      fromJson: (json) => noteFromJson(json),
      toJson: (note) => note.toJson(),
      save: (note) => noteHelper.saveNote(note),
    ),
    SyncItem<Folder>(
      blobType: "folder",
      getLocalItems: () => folderHelper.listFolders(),
      getId: (folder) => folder.id,
      getLastChanged: (folder) => folder.lastChanged,
      fromJson: (json) => Folder.fromJson(json),
      toJson: (folder) => folder.toJson(),
      save: (folder) => folderHelper.saveFolder(folder),
    ),
    SyncItem<Tag>(
      blobType: "tag",
      getLocalItems: () => tagHelper.listTags(TagReturnMode.local),
      getId: (tag) => tag.id,
      getLastChanged: (tag) => tag.lastChanged,
      fromJson: (json) => Tag.fromJson(json),
      toJson: (tag) => tag.toJson(),
      save: (tag) => tagHelper.saveTag(tag),
    ),
    SyncItem<NoteImage>(
      blobType: "image",
      getLocalItems: () => imageHelper.listAllImages(),
      getId: (noteImage) => noteImage.id,
      getLastChanged: (noteImage) => noteImage.lastChanged,
      fromJson: (json) => NoteImage.fromJson(json),
      toJson: (noteImage) => noteImage.toJson(),
      save: (noteImage) => imageHelper.saveImage(noteImage),
    )
  ];

  Future sync() async {
    // Step 1: Fetch all data from the server
    final List<Blob> serverBlobs = await SyncBlobService().getAllBlobs();

    for (final SyncItem item in syncItems) {
      await item.sync(serverBlobs: serverBlobs);
    }
    //Syncing is done
  }

  static Note noteFromJson(Map<String, dynamic> json) {
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
}
