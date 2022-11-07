import 'dart:convert';

import 'package:potato_notes/internal/sync/blob.dart';
import 'package:potato_notes/internal/sync/blob_service.dart';

class SyncItem<T> {
  final String blobType;
  final Future<List<T>> Function() getLocalItems;
  final String Function(T) getId;
  final DateTime Function(T) getLastChanged;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final Future Function(T) save;

  SyncItem({
    required this.blobType,
    required this.getLocalItems,
    required this.getId,
    required this.getLastChanged,
    required this.fromJson,
    required this.toJson,
    required this.save,
  });

  Future<void> sync(
      {required List<Blob> serverBlobs,
      required BlobService blobService,
      required bool Function(String) blobExists}) async {
    final List<T> localItems = await getLocalItems();

    final List<Blob> serverNotes =
        serverBlobs.where((blob) => blob.blobType == blobType).toList();

    for (final Blob blob in serverNotes) {
      if (localItems.any((T t) => getId(t) == blob.id)) {
        final T localItem = localItems.firstWhere((T t) => getId(t) == blob.id);

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

    for (final T localItem in localItems) {
      // Step 4: Check if the item exists on the server already
      if (serverNotes.any((Blob blob) => getId(localItem) == blob.id)) {
        final Blob blob =
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
      await blobService.upsertBlob(blob, blobExists(getId(localItem)));
    }
  }
}
