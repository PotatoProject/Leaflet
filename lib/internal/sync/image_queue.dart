import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loggy/loggy.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/upload_queue_item.dart';

import 'image/delete_queue_item.dart';
import 'image/download_queue_item.dart';
import 'image/queue_item.dart';

class ImageQueue extends ChangeNotifier {
  @computed
  List<QueueItem> get queue =>
      new List.from(downloadQueue)..addAll(uploadQueue);

  @observable
  final List<UploadQueueItem> uploadQueue = [];
  final List<DeleteQueueItem> deleteQueue;
  @observable
  final List<DownloadQueueItem> downloadQueue = [];

  ImageQueue() : deleteQueue = deleteQueueFromPrefs();

  void addUpload(SavedImage data, String noteId) {
    final UploadQueueItem item = UploadQueueItem(
        localPath: data.path,
        noteId: noteId,
        savedImage: data,
        storageLocation: data.storageLocation);
    uploadQueue.add(item);
    notifyListeners();
  }

  void addDelete(SavedImage data) {
    if (data.storageLocation != StorageLocation.SYNC || !data.uploaded) return;
    final DeleteQueueItem item = DeleteQueueItem(
      localPath: data.path,
      savedImage: data,
      storageLocation: data.storageLocation,
    );
    deleteQueue.add(item);
    saveToPrefs();
  }

  void addDownload(SavedImage data, String noteId) {
    final DownloadQueueItem item = DownloadQueueItem(
        savedImage: data, noteId: noteId, localPath: data.path);
    downloadQueue.add(item);
    notifyListeners();
  }

  //This method can only be run if all images have been processed (e.g. have a hash)
  Future<bool> hasDuplicates(SavedImage data, {NoteHelper noteHelper}) async {
    if (noteHelper == null) noteHelper = helper;

    final List<Note> notes = await noteHelper.listNotes(ReturnMode.LOCAL);
    for (final Note note in notes) {
      if (note.images.indexWhere(
              (e) => e.id != data.id && e.uploaded && e.hash == data.hash) !=
          -1) return true;
    }
    return false;
  }

  Future<void> fillUploadQueue() async {
    final List<Note> notes = await helper.listNotes(ReturnMode.LOCAL);
    notes.forEach((note) {
      note.images
          .where((image) => !image.uploaded)
          .forEach((image) => addUpload(image, note.id));
    });
  }

  Future<void> processDownloads() async {
    Loggy.d(message: "DownloadQueue has ${downloadQueue.length} items queued");
    Loggy.d(message: "Started processing downloads");
    downloadQueue.forEach((item) async {
      await item.downloadImage();
    });
    for (final DownloadQueueItem item in downloadQueue) {
      if (item.status.value == QueueItemStatus.COMPLETE) await updateItem(item);
    }
    downloadQueue.removeWhere(
      (item) => item.status.value == QueueItemStatus.COMPLETE,
    );
    Loggy.d(
      message: "DownloadQueue now contains ${downloadQueue.length} items",
    );
  }

  Future<void> process() async {
    final String tempDirectory = appInfo.tempDirectory.path;

    Loggy.d(message: "UploadQueue has ${uploadQueue.length} items queued");
    Loggy.d(message: "Started processing uploads");
    await Future.wait(
        uploadQueue.map((item) => uploadItem(item, tempDirectory)));

    //Update items that are uploaded in notes
    for (final UploadQueueItem item in uploadQueue) {
      if (item.status.value != QueueItemStatus.COMPLETE) continue;
      await updateItem(item);
    }

    Loggy.d(message: "DeleteQueue has ${downloadQueue.length} items queued");
    Loggy.d(message: "Started processing uploads");
    await Future.wait(deleteQueue.map((item) async {
      if (await hasDuplicates(item.savedImage)) {
        item.status.value = QueueItemStatus.COMPLETE;
      } else {
        return await item.deleteImage();
      }
    }));

    //Remove the items from the queue
    uploadQueue
        .removeWhere((item) => item.status.value == QueueItemStatus.COMPLETE);
    deleteQueue
        .removeWhere((item) => item.status.value == QueueItemStatus.COMPLETE);

    Loggy.d(message: "UploadQueue now contains ${uploadQueue.length} items");
    Loggy.d(message: "DeleteQueue now contains ${deleteQueue.length} items");
  }

  Future<void> deleteItem(DeleteQueueItem item) async {
    if (await hasDuplicates(item.savedImage)) {
      item.status.value = QueueItemStatus.COMPLETE;
    } else {
      await item.deleteImage();
    }
  }

  Future<void> uploadItem(UploadQueueItem item, String tempDirectory) async {
    await item.process(tempDirectory);
    if (item.storageLocation == StorageLocation.SYNC &&
        await hasDuplicates(item.savedImage)) {
      item.savedImage.uploaded = true;
      item.status.value = QueueItemStatus.COMPLETE;
      return;
    } else {
      await item.uploadImage();
    }
  }

  Future<void> updateItem(QueueItem item) async {
    final List<Note> notes = await helper.listNotes(ReturnMode.LOCAL);
    for (final Note note in notes) {
      for (int i = 0; i < note.images.length; i++) {
        if (note.images[i].id != item.savedImage.id) continue;
        note.images[i] = item.savedImage;
      }
      await helper.saveNote(note);
    }
  }

  void saveToPrefs() {
    prefs.deleteQueue = jsonEncode(deleteQueue);
  }

  static List<DeleteQueueItem> deleteQueueFromPrefs() {
    if (prefs.deleteQueue == null || prefs.deleteQueue.length == 0) return [];
    print(prefs.deleteQueue);
    final List<DeleteQueueItem> queue = (json.decode(prefs.deleteQueue) as List)
        .map((i) => DeleteQueueItem.fromJson(i))
        .toList();
    return queue;
  }
}
