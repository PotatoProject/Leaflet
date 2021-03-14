import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class FilesController {
  static const String filesPrefix = "/files";

  static Future<void> uploadImageToSync(String hash, File file) async {
    final String url = await getUploadUrlFromSync(hash);
    await dio.put(
      url,
      data: file.openRead(),
      options: Options(
        headers: {
          'content-type': 'image/jpg',
          'content-length': (await file.length()).toString(),
        },
      ),
    );
    return;
  }

  static Future<String> getUploadUrlFromSync(String hash) async {
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$filesPrefix/put/$hash.jpg";
    Loggy.v(message: "Going to send GET to $url");
    final Response getResult = await dio.get(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    Loggy.d(
      message:
          "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.data}",
    );
    if (getResult.statusCode == 200) {
      return getResult.data.toString();
    } else {
      throw "Cant get imageurl ${getResult.data}";
    }
  }

  static Future<String> getDownloadUrlFromSync(String hash) async {
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$filesPrefix/get/$hash.jpg";
    Loggy.v(message: "Going to send GET to $url");
    final Response getResult = await dio.get(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    Loggy.d(
      message:
          "($hash getImageUrl) Server responded with (${getResult.statusCode}): ${getResult.data}",
    );
    if (getResult.statusCode == 200) {
      return getResult.data.toString();
    } else {
      throw "Cant get imageurl ${getResult.data}";
    }
  }

  static Future<void> deleteImage(String hash) async {
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$filesPrefix/delete/$hash.jpg";
    Loggy.v(message: "Going to send DELETE to $url");
    final Response deleteResult = await dio.delete(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    Loggy.d(
      message:
          "($hash deleteImage) Server responded with (${deleteResult.statusCode}): ${deleteResult.data}",
    );
    if (deleteResult.statusCode != 200) {
      throw "Cant delete image ${deleteResult.data}";
    }
  }

  static Future<FilesApiStats> getStats() async {
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$filesPrefix/limit";
    Loggy.v(message: "Going to send GET to $url");
    final Response getResult = await dio.get(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    Loggy.d(
      message:
          "Server responded with (${getResult.statusCode}): ${getResult.data}",
    );
    if (getResult.statusCode == 200) {
      final Map<String, dynamic> jsonBody =
          Utils.asMap<String, dynamic>(getResult.data);
      return FilesApiStats(jsonBody["used"] as int, jsonBody["limit"] as int);
    } else {
      throw "Cant get stats ${getResult.data}";
    }
  }
}

@immutable
class FilesApiStats {
  final int used;
  final int limit;

  const FilesApiStats(this.used, this.limit);
}
