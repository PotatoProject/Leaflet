import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';

class FilesController {
  static const FILES_PREFIX = "/files";

  static Future<void> uploadImageToSync(String hash, File file) async {
    String url = await getUploadUrlFromSync(hash);
    dio.Response uploadResponse = await dio.Dio().put(
      url,
      data: file.openRead(),
      options: dio.Options(contentType: 'image/jpg', headers: {
        dio.Headers.contentLengthHeader: await file.length(),
      }),
    );
    print(uploadResponse.data.toString());
    return;
  }

  static Future<String> getUploadUrlFromSync(String hash) async {
    String? token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/put/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    Response getResult =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    Loggy.d(
        message:
            "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.body}");
    if (getResult.statusCode == 200) {
      return getResult.body;
    } else {
      throw ("Cant get imageurl ${getResult.body}");
    }
  }

  static Future<String> getDownloadUrlFromSync(String hash) async {
    String? token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/get/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    Response getResult =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    Loggy.d(
        message:
            "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.body}");
    if (getResult.statusCode == 200) {
      return getResult.body;
    } else {
      throw ("Cant get imageurl " + getResult.body);
    }
  }

  static Future<void> deleteImage(String hash) async {
    String? token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/delete/$hash.jpg";
    Loggy.v(message: "Going to send DELETE to $url");
    Response deleteResult =
        await http.delete(url, headers: {"Authorization": "Bearer $token"});
    Loggy.d(
        message:
            "($hash deleteImage) Server responded with (${deleteResult.statusCode}): ${deleteResult.body}");
    if (deleteResult.statusCode != 200) {
      throw ("Cant delete image ${deleteResult.body}");
    }
  }

  static Future<FilesApiStats> getStats() async {
    String? token = await prefs.getToken();
    var url = "${prefs.apiUrl}$FILES_PREFIX/limit";
    Loggy.v(message: "Going to send GET to " + url);
    Response getResult =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    Loggy.d(
        message:
            "Server responded with (${getResult.statusCode}): ${getResult.body}");
    if (getResult.statusCode == 200) {
      final jsonBody = json.decode(getResult.body);
      return FilesApiStats(jsonBody["used"], jsonBody["limit"]);
    } else {
      throw ("Cant get stats " + getResult.body);
    }
  }
}

@immutable
class FilesApiStats {
  final int used;
  final int limit;

  FilesApiStats(this.used, this.limit);
}
