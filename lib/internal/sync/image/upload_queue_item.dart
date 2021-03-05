import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';

import 'image_helper.dart';

class UploadQueueItem extends QueueItem {
  final String noteId;
  final String localPath;
  final SavedImage savedImage;
  final StorageLocation storageLocation;

  UploadQueueItem({
    @required this.noteId,
    @required this.localPath,
    @required this.savedImage,
    this.storageLocation = StorageLocation.LOCAL,
  }) : super(localPath: localPath, savedImage: savedImage);

  @action
  Future<void> process(String tempDirectory) async {
    status.value = QueueItemStatus.ONGOING;
    Map<String, String> data = {
      "original": localPath,
      "tempDirectory": tempDirectory
    };
    String resultJson =
        await compute(ImageHelper.processImage, jsonEncode(data));
    final Map<String, dynamic> result = json.decode(resultJson);
    savedImage.hash = result["hash"];
    savedImage.blurHash = result["blurhash"];
    savedImage.width = double.parse(result["width"]);
    savedImage.height = double.parse(result["height"]);
    return;
  }

  @action
  Future<void> uploadImage({
    Map<String, dynamic> headers = const {},
  }) async {
    final File file = File(localPath);
    status.value = QueueItemStatus.ONGOING;
    final int length = await file.length();
    await dio.request(
      await getUploadUrl(),
      data: file.openRead(),
      onSendProgress: (count, total) {
        progress.value = count / total;
      },
      options: Options(
        method:
            savedImage.storageLocation == StorageLocation.SYNC ? "PUT" : "POST",
        headers: Map.from(headers)
          ..addAll({
            'content-length': length.toString(),
            'content-type': 'image/jpg',
          }),
      ),
    );
    status.value = QueueItemStatus.COMPLETE;
    savedImage.uploaded = true;
  }

  Future<String> getUploadUrl() async {
    switch (savedImage.storageLocation) {
      case StorageLocation.SYNC:
        final String token = await prefs.getToken();
        final String url = "${prefs.apiUrl}/files/put/${savedImage.hash}.jpg";
        print(url);
        final Response presign = await dio.get(
          url,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
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
        throw "Local images should not be uploaded";
    }
  }
}
