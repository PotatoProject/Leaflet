import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';

class ImageController {
  static const FILES_PREFIX = "/files";

  static Future<String> downloadFullImage(SavedImage savedImage) async {
    switch (savedImage.storageLocation) {
      case StorageLocation.LOCAL:
        return savedImage.uri.path;
        break;
      case StorageLocation.IMGUR:
        String url = savedImage.uri.path;
        return await downloadImageToCache(url, savedImage);
        break;
      case StorageLocation.SYNC:
        String url = await getDownloadUrlFromSync(savedImage.hash);
        return await downloadImageToCache(url, savedImage);
        break;
    }
    return "";
  }

  static Future<String> downloadThumbnailImage(SavedImage savedImage) async {
    switch (savedImage.storageLocation) {
      case StorageLocation.LOCAL:
        return savedImage.uri.path;
        break;
      case StorageLocation.IMGUR:
        String url = savedImage.uri.path;
        return await downloadImageToCache(url, savedImage);
        break;
      case StorageLocation.SYNC:
        String url = await getDownloadUrlFromSync(savedImage.hash + "-thumb");
        return await downloadImageToCache(url, savedImage);
        break;
    }
    return "";
  }

  static Future<bool> fullExists(SavedImage image) async {
    return await fileExists(image.getPath());
  }

  static Future<bool> thumbExists(String hash) async {
    return await fileExists(hash + "-thumb");
  }

  static Future<bool> fileExists(String path) async {
    File file = File(path);
    return await file.exists();
  }

  static Future<String> downloadImageToCache(
      String url, SavedImage savedImage) async {
    var path = savedImage.getPath();
    Response response = await http.get(url);
    /*
    dio.Response response = await dio.Dio().download(
      url,
      path,
      onReceiveProgress: (int sentBytes, int totalBytes) {
        double progressPercent = sentBytes / totalBytes * 100;
        print("upload $progressPercent %");
      },
    );*/
    Loggy.v(
        message:
            "(${savedImage.hash} downloadImage) Server responded with (${response.statusCode}): ${response.contentLength}");
    if (response.statusCode == 200) {
      File file = new File(path);
      file.writeAsBytesSync(response.bodyBytes);
      return path;
    } else if (response.statusCode == 404) {
      throw ("File doesnt exist on server");
    } else if (response.statusCode == 403) {
      throw ("Not allowed to access file");
    }
    return path;
  }

  static Future<String> getDownloadUrlFromSync(String hash) async {
    String token = await prefs.getToken();
    var url = "http://192.168.178.89:8000/get/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    dio.Response getResult = await dio.Dio().get(url,
        options: dio.Options(headers: {"Authorization": "Bearer $token"}));
    Loggy.d(
        message:
            "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.data.toString()}");
    if (getResult.statusCode == 200) {
      return getResult.data.toString();
    } else {
      throw ("Cant get imageurl " + getResult.data.toString());
    }
  }

  static Future<void> uploadImageToSync(String hash, File file) async {
    String url = await getUploadUrlFromSync(hash);
    dio.Response uploadResult = await dio.Dio().put(
      url,
      data: file.openRead(),
      options: dio.Options(contentType: 'image/jpg', headers: {
        dio.Headers.contentLengthHeader: await file.length(),
      }),
      onSendProgress: (int sentBytes, int totalBytes) {
        double progressPercent = sentBytes / totalBytes * 100;
        print("upload $progressPercent %");
      },
    );
    return;
  }

  static Future<String> getUploadUrlFromSync(String hash) async {
    String token = await prefs.getToken();
    var url = "http://192.168.178.89:8000/put/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    dio.Response getResult = await dio.Dio().get(url,
        options: dio.Options(headers: {"Authorization": "Bearer $token"}));
    Loggy.d(
        message:
            "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.data.toString()}");
    if (getResult.statusCode == 200) {
      return getResult.data.toString();
    } else {
      throw ("Cant get imageurl " + getResult.data.toString());
    }
  }
}
