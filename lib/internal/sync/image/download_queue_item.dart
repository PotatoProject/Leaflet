import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';

class DownloadQueueItem extends QueueItem {
  final String noteId;
  final String localPath;
  final SavedImage savedImage;

  DownloadQueueItem({
    @required this.noteId,
    @required this.localPath,
    @required this.savedImage,
  }) : super(localPath: localPath, savedImage: savedImage);

  @action
  Future<void> downloadImage() async {
    status = QueueItemStatus.ONGOING;
    await httpClient.download(
      url: await getDownloadUrl(),
      fileName: localPath,
      onProgressChanged: (count, total) {
        progress = count / total;
        notifyListeners();
        imageQueue.notifyListeners();
      },
    );
    status = QueueItemStatus.COMPLETE;
  }

  Future<String> getDownloadUrl() async {
    switch (savedImage.storageLocation) {
      case StorageLocation.SYNC:
        final String token = await prefs.getToken();
        final String url = "${prefs.apiUrl}/files/get/${savedImage.hash}.jpg";
        final Response presign = await httpClient.get(
          url,
          headers: {"Authorization": "Bearer $token"},
        );
        if (presign.statusCode == 200) {
          return presign.body;
        } else {
          throw presign.body;
        }
        break;
      case StorageLocation.LOCAL:
      default:
        throw "Local images can not be downloaded";
    }
  }
}
