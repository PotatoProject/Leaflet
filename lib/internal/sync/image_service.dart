import 'dart:io';

import 'package:dio/dio.dart';
import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image_utils.dart';

abstract class ImageService {
  Future uploadImage(NoteImage noteImage);
  Future downloadImage(NoteImage noteImage);
}

class SyncImageService extends ImageService {
  @override
  Future downloadImage(NoteImage noteImage) async {
    String filePath = ImageUtils.filePathFromImage(noteImage);
    String temporaryPath = filePath + ".temp";
    await dio.download(
      "http://192.168.178.24:3000/get/${noteImage.id}.jpg",
      temporaryPath,
      options: Options(
        headers: {'Authorization': 'Bearer test'},
      ),
    );
    await File(temporaryPath).rename(filePath);
  }

  @override
  Future uploadImage(NoteImage noteImage) async {
    final File file = File(ImageUtils.filePathFromImage(noteImage));
    final int length = await file.length();
    final formData = FormData.fromMap({
      'file':
          await MultipartFile.fromFile(ImageUtils.filePathFromImage(noteImage))
    });
    final response = await dio.request(
      "http://192.168.178.24:3000/put/${noteImage.id}.jpg",
      data: formData,
      options: Options(
        method: "PUT",
        headers: {
          'content-length': length.toString(),
          'content-type': 'image/jpg',
          'Authorization': 'Bearer test',
        },
      ),
    );
    print(response.data.toString());
  }
}
