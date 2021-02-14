import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:loggy/loggy.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';
import 'package:worker_manager/worker_manager.dart';

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
    status = QueueItemStatus.ONGOING;
    final Uint8List rawBytes = await File(localPath).readAsBytes();
    Loggy.d(message: "Hashing image");
    savedImage.hash = await Executor()
        .execute(fun1: ImageHelper.generateImageHash, arg1: rawBytes);
    Loggy.d(message: "Resizing image");
    final Image compressedImage = await Executor()
        .execute(fun1: ImageHelper.compressImage, arg1: rawBytes);
    Loggy.d(message: "generating blurhash");
    final String blurHash = ImageHelper.generateBlurHash(await Executor()
        .execute(fun1: ImageHelper.compressForBlur, arg1: compressedImage));
    savedImage.blurHash = blurHash;
    Loggy.d(message: "Saving image");
    await ImageHelper.saveImage(
        compressedImage, tempDirectory + "/${savedImage.hash}.jpg");
    return;
  }

  @action
  Future<Response> uploadImage({
    Map<String, dynamic> headers = const {},
  }) async {
    final File file = File(localPath);
    status = QueueItemStatus.ONGOING;
    final int length = await file.length();
    final Response response = await Dio().request(
      (await getUploadUrl()).toString(),
      data: file.openRead(),
      onSendProgress: (count, total) {
        progress = count / total;
      },
      options: Options(
        contentType: "image/jpg",
        method:
            savedImage.storageLocation == StorageLocation.SYNC ? "PUT" : "POST",
        headers: headers
          ..putIfAbsent(Headers.contentLengthHeader, () => length),
      ),
    );
    status = QueueItemStatus.COMPLETE;
    savedImage.uploaded = true;
    return response;
  }

  Future<String> getUploadUrl() async {
    switch (savedImage.storageLocation) {
      case StorageLocation.SYNC:
        final String token = await prefs.getToken();
        final String url = "${prefs.apiUrl}/files/put/${savedImage.hash}.jpg";
        print(url);
        final Response presign = await dio.get(url,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ));
        if (presign.statusCode == 200) {
          return presign.data.toString();
        } else {
          throw presign.data.toString();
        }
        break;
      case StorageLocation.LOCAL:
      default:
        throw "Local images should not be uploaded";
    }
  }
}
