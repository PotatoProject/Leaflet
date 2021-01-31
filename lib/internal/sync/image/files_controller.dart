import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';

class FilesController {
  static const FILES_PREFIX = "/files";

  static Future<void> uploadImageToSync(String hash, File file) async {
    String url = await getUploadUrlFromSync(hash);
    Response uploadResponse = await Dio().put(
      url,
      data: file.openRead(),
      options: Options(contentType: 'image/jpg', headers: {
        Headers.contentLengthHeader: await file.length(),
      }),
    );
    return;
  }

  static Future<String> getUploadUrlFromSync(String hash) async {
    String token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/put/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    Response getResult = await dio.get(
      url,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    Loggy.d(
        message:
            "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.data}");
    if (getResult.statusCode == 200) {
      return getResult.data;
    } else {
      throw ("Cant get imageurl ${getResult.data}");
    }
  }

  static Future<String> getDownloadUrlFromSync(String hash) async {
    String token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/get/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    Response getResult =
    await dio.get(
      url, options: Options(headers: {"Authorization": "Bearer $token"}),);
    Loggy.d(
        message:
        "($hash getImageUrl) Server responded with (${getResult
            .statusCode}): ${getResult.data}");
    if (getResult.statusCode == 200) {
      return getResult.data;
    } else {
      throw ("Cant get imageurl " + getResult.data);
    }
  }

  static Future<void> deleteImage(String hash) async {
    String token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/delete/$hash.jpg";
    Loggy.v(message: "Going to send DELETE to $url");
    Response deleteResult =
    await dio.delete(
      url, options: Options(headers: {"Authorization": "Bearer $token"}),);
    Loggy.d(
        message:
        "($hash deleteImage) Server responded with (${deleteResult
            .statusCode}): ${deleteResult.data}");
    if (deleteResult.statusCode != 200) {
      throw ("Cant delete image ${deleteResult.data}");
    }
  }

  static Future<FilesApiStats> getStats() async {
    String token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/limit";
    Loggy.v(message: "Going to send GET to " + url);
    Response getResult =
    await dio.get(
      url, options: Options(headers: {"Authorization": "Bearer $token"}),);
    Loggy.d(
        message:
        "Server responded with (${getResult.statusCode}): ${getResult.data}");
    if (getResult.statusCode == 200) {
      final jsonBody = getResult.data;
      return FilesApiStats(jsonBody["used"], jsonBody["limit"]);
    } else {
      throw ("Cant get stats " + getResult.data);
    }
  }
}

@immutable
class FilesApiStats {
  final int used;
  final int limit;

  FilesApiStats(this.used, this.limit);
}
