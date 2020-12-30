import 'dart:convert';

import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/upload_queue_item.dart';

import 'image/delete_queue_item.dart';
import 'image/download_queue_item.dart';
import 'image/queue_item.dart';

class ImageQueue {
  static List<UploadQueueItem> uploadQueue = [];
  //Will make sure to resume from prefs
  static List<DeleteQueueItem> deleteQueue = deleteQueueFromPrefs();
  static List<DownloadQueueItem> downloadQueue = [];

  static void addUpload(SavedImage data, String noteId) {
    if (data.uri == null) {
      throw "Uri is null, cant derive localpath from savedImage";
    }
    var item = UploadQueueItem(
        localPath: data.uri.path,
        noteId: noteId,
        savedImage: data,
        storageLocation: data.storageLocation);
    uploadQueue.add(item);
  }

  static void addDelete(SavedImage data) {
    if (data.storageLocation != StorageLocation.SYNC || !data.uploaded) return;
    var item = DeleteQueueItem(
      localPath: data.path,
      savedImage: data,
      storageLocation: data.storageLocation,
    );
    deleteQueue.add(item);
    saveToPrefs();
  }

  static void addDownload(SavedImage data, String noteId) {
    var item = DownloadQueueItem(
        savedImage: data, noteId: noteId, localPath: data.path);
    downloadQueue.add(item);
  }

  //This method can only be run if all images have been processed (e.g. have a hash)
  static Future<bool> hasDuplicates(SavedImage data,
      {NoteHelper noteHelper}) async {
    if (noteHelper == null) noteHelper = helper;

    var notes = await noteHelper.listNotes(ReturnMode.LOCAL);
    for (var note in notes) {
      if (note.images.indexWhere(
              (e) => e.id != data.id && e.uploaded && e.hash == data.hash) !=
          -1) return true;
    }
    return false;
  }

  static Future<void> fillUploadQueue() async {
    var notes = await helper.listNotes(ReturnMode.LOCAL);
    notes.forEach((note) {
      note.images
          .where((image) => !image.uploaded)
          .forEach((image) => addUpload(image, note.id));
    });
  }

  static Future<void> processDownloads() async {
    await Future.wait(downloadQueue.map((item) => item.downloadImage()));
    for (var item in downloadQueue) {
      if (item.status == QueueItemStatus.COMPLETE) await updateItem(item);
    }
    downloadQueue
        .removeWhere((item) => item.status == QueueItemStatus.COMPLETE);
    print("DownloadQueue " + downloadQueue.length.toString());
  }

  static Future<void> process() async {
    String tempDirectory = appInfo.tempDirectory.path;

    await Future.wait(
        uploadQueue.map((item) => uploadItem(item, tempDirectory)));

    //Update items that are uploaded in notes
    for (var item in uploadQueue) {
      if (item.status != QueueItemStatus.COMPLETE) continue;
      await updateItem(item);
    }

    await Future.wait(deleteQueue.map((item) async {
      if (await hasDuplicates(item.savedImage)) {
        item.status = QueueItemStatus.COMPLETE;
      } else {
        return await item.deleteImage();
      }
    }));

    /*for(var item in deleteQueue){
      await item.deleteImage();
    }*/

    //Upload all items in upload queue
    /*for(var item in uploadQueue) {

      await uploadItem(item, tempDirectory);
    }*/

    //Remove the items from the queue
    uploadQueue.removeWhere((item) => item.status == QueueItemStatus.COMPLETE);
    deleteQueue.removeWhere((item) => item.status == QueueItemStatus.COMPLETE);

    print("Queue " + uploadQueue.length.toString());
    print("Delete Queue " + deleteQueue.length.toString());
  }

  static Future<void> deleteItem(DeleteQueueItem item) async {
    if (await hasDuplicates(item.savedImage)) {
      item.status = QueueItemStatus.COMPLETE;
    } else {
      await item.deleteImage();
    }
  }

  static Future<void> uploadItem(
      UploadQueueItem item, String tempDirectory) async {
    await item.process(tempDirectory);
    Map<String, dynamic> headers = {};
    if (item.storageLocation == StorageLocation.IMGUR) {
      headers.putIfAbsent("Authorization", () => "Client-ID f856a5e4fd5b2af");
    }
    var response = await item.uploadImage(headers: headers);
    if (item.storageLocation == StorageLocation.IMGUR) {
      String url = response.data["data"]["link"];
      item.savedImage.uri = Uri.parse(url);
    }
  }

  static Future<void> updateItem(QueueItem item) async {
    var notes = await helper.listNotes(ReturnMode.LOCAL);
    for (var note in notes) {
      /*if(note.id != item.noteId)
        continue;*/
      for (int i = 0; i < note.images.length; i++) {
        if (note.images[i].id != item.savedImage.id) continue;
        note.images[i] = item.savedImage;
      }
      await helper.saveNote(note);
    }
  }

  static void saveToPrefs() {
    String delete = jsonEncode(deleteQueue);
    prefs.deleteQueue = delete;
  }

  static List<DeleteQueueItem> deleteQueueFromPrefs() {
    if (prefs.deleteQueue == null || prefs.deleteQueue.length == 0) return [];
    print(prefs.deleteQueue);
    List<DeleteQueueItem> queue = (json.decode(prefs.deleteQueue) as List)
        .map((i) => DeleteQueueItem.fromJson(i))
        .toList();
    print(queue.length);
    print(queue);
    return queue;
  }
}
