import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:liblymph/database.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:potato_notes/internal/pocketbase_helper.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image_utils.dart';

abstract class ImageService {
  Future uploadImage(NoteImage noteImage);
  Future downloadImage(NoteImage noteImage);
}

class SyncImageService extends ImageService {
  @override
  Future downloadImage(NoteImage noteImage) async {
    final String filePath = ImageUtils.filePathFromImage(noteImage);
    final String temporaryPath = filePath + ".temp";
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

class PocketbaseImageService extends ImageService {
  @override
  Future downloadImage(NoteImage noteImage) async {
    ///api/files/${profile.collectionId}/${profile.id}/$avatarFile?thumb=${size}x${size}
    final RecordModel fileModel =
        await pocketbase.records.getOne("files", noteImage.id);
    final String filename = fileModel.data['file'] as String;
    final String filePath = ImageUtils.filePathFromImage(noteImage);
    final String temporaryPath = "$filePath.temp";
    await dio.download(
      "${pocketbase.baseUrl}/api/files/files/${noteImage.id}/$filename",
      temporaryPath,
    );
    await File(temporaryPath).rename(filePath);
  }

  @override
  Future uploadImage(NoteImage noteImage) async {
    File imageFile = File(ImageUtils.filePathFromImage(noteImage));
    await pocketbase.records.create(
      "files",
      body: {
        "id": noteImage.id,
        "account_id": PocketbaseHelper.getUserId(),
      },
      files: [
        http.MultipartFile.fromBytes(
          "file",
          await imageFile.readAsBytes(),
          filename: "${noteImage.id}.jpg",
          contentType: MediaType.parse("image/jpg"),
        )
      ],
    );
    await imageHelper.saveImage(noteImage.copyWith(uploaded: true));
  }
}
