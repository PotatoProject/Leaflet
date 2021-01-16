import 'package:dio/dio.dart';
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
    print('Downloading!');
    status = QueueItemStatus.ONGOING;
    await Dio().download(
      await getDownloadUrl(),
      localPath,
      onReceiveProgress: (count, total) {
        progress = count / total;
        print(progress);
      },
    );
    print('Downloaded!');
    status = QueueItemStatus.COMPLETE;
  }

  Future<String> getDownloadUrl() async {
    switch (savedImage.storageLocation) {
      case StorageLocation.IMGUR:
        return savedImage.uri.toString();
      case StorageLocation.SYNC:
        String token = await prefs.getToken();
        var url = "${prefs.apiUrl}/files/get/${savedImage.hash}.jpg";
        Response presign = await Dio().get(url,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ));
        if (presign.statusCode == 200) {
          return presign.data;
        } else {
          throw presign.data;
        }
        break;
      case StorageLocation.LOCAL:
      default:
        throw "Local images can not be downloaded";
    }
  }
}
