import 'dart:convert';

import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/blob.dart';
import 'package:potato_notes/internal/sync/blob_service.dart';

class SyncServive {
  Note fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      starred: json['starred'] as bool,
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(json['creationDate'] as int),
      color: json['color'] as int,
      images: (json['images'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      list: json['list'] as bool,
      listContent: (json['listContent'] as List<dynamic>)
          .map((item) => ListItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(e as int))
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
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
    List<Note> localNotes = await noteHelper.listNotes(BuiltInFolders.all);

    for (Blob blob in serverBlobs) {
      if (localNotes.any((Note note) => note.id == blob.id)) {
        Note note = localNotes.firstWhere((Note note) => note.id == blob.id);
        print("${note.id} will be checked");
        // Step 2: Compare the local dates against the server dates
        if (note.lastChanged.isBefore(blob.lastChanged)) {
          print("${note.id} will be updated");
          final json = jsonDecode(blob.content) as Map<String, dynamic>;
          print(json);

          final updatedNote = fromJson(json);
          print(updatedNote.toJsonString());
          // Step 3: If the note on server is newer, save it on client
          await noteHelper.saveNote(updatedNote);
        }
      }
    }

    for (Note note in localNotes) {
      // Step 4: Check if the note exists on the server already
      if (serverBlobs.any((Blob blob) => note.id == blob.id)) {
        Blob blob = serverBlobs.firstWhere((blob) => blob.id == note.id);

        // If the note is newer or as old as the one on the server, dont do anything.
        if (note.lastChanged.millisecondsSinceEpoch <=
            blob.lastChanged.millisecondsSinceEpoch) {
          continue;
        }
      }

      // Create blob
      final blob = Blob(note.id, jsonEncode(note.toJson()), note.lastChanged);
      // Step 5: If the note at the client is newer or doesnt exist,
      // Upsert (Insert or Update) the blob at the server
      await SyncBlobService().upsertBlob(blob);
    }

    //Syncing is done
  }
}
