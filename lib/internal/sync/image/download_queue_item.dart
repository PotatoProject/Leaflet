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
    status.value = QueueItemStatus.ONGOING;
    await dio.download(
      await getDownloadUrl(),
      localPath,
      onReceiveProgress: (count, total) {
        progress.value = count / total;
      },
    );
    status.value = QueueItemStatus.COMPLETE;
  }

  Future<String> getDownloadUrl() async {
    switch (savedImage.storageLocation) {
      case StorageLocation.SYNC:
        final String token = await prefs.getToken();
        final String url = "${prefs.apiUrl}/files/get/${savedImage.hash}.jpg";
        final Response presign = await dio.get(
          url,
          options: Options(
            headers: {"Authorization": "Bearer " + token},
          ),
        );
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
