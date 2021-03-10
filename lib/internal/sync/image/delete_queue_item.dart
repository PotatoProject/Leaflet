// @dart=2.12

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';

class DeleteQueueItem extends QueueItem {
  final StorageLocation storageLocation;

  DeleteQueueItem({
    required String localPath,
    required SavedImage savedImage,
    this.storageLocation = StorageLocation.local,
  }) : super(localPath: localPath, savedImage: savedImage);

  Future<void> deleteImage() async {
    status.value = QueueItemStatus.ongoing;
    final String url = "${prefs.apiUrl}/files/delete/${savedImage.hash}.jpg";
    final String token = await prefs.getToken();
    final Response response = await dio.delete(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    if (response.statusCode != 200) {
      return;
    } else {
      status.value = QueueItemStatus.complete;
    }
  }

  factory DeleteQueueItem.fromJson(Map<String, dynamic> json) =>
      DeleteQueueItem(
        localPath: json['localPath'] as String,
        savedImage:
            SavedImage.fromJson(json['savedImage'] as Map<String, dynamic>),
        storageLocation: StorageLocation.values[json['storageLocation'] as int],
      )
        ..status = ValueNotifier(QueueItemStatus.values[json['status'] as int])
        ..progress = ValueNotifier((json['progress'] as num?)?.toDouble());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.value.index,
        'progress': progress.value,
        'localPath': localPath,
        'savedImage': savedImage,
        'storageLocation': storageLocation.index,
      };
}
