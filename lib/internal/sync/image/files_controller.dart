import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class FilesController {
  static const FILES_PREFIX = "/files";

  static Future<void> uploadImageToSync(String hash, File file) async {
    final String url = await getUploadUrlFromSync(hash);
    await httpClient.put(
      url,
      body: file.openRead(),
      headers: {
        'content-type': 'image/jpg',
        'content-length': (await file.length()).toString(),
      },
    );
    return;
  }

  static Future<String> getUploadUrlFromSync(String hash) async {
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$FILES_PREFIX/put/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    final Response getResult = await httpClient.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
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
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$FILES_PREFIX/get/$hash.jpg";
    Loggy.v(message: "Going to send GET to " + url);
    final Response getResult = await httpClient.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
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
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$FILES_PREFIX/delete/$hash.jpg";
    Loggy.v(message: "Going to send DELETE to $url");
    final Response deleteResult = await httpClient.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    Loggy.d(
        message:
            "($hash deleteImage) Server responded with (${deleteResult.statusCode}): ${deleteResult.body}");
    if (deleteResult.statusCode != 200) {
      throw ("Cant delete image ${deleteResult.body}");
    }
  }

  static Future<FilesApiStats> getStats() async {
    final String token = await prefs.getToken();
    final String url = "${prefs.apiUrl}$FILES_PREFIX/limit";
    Loggy.v(message: "Going to send GET to " + url);
    final Response getResult = await httpClient.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    Loggy.d(
        message:
            "Server responded with (${getResult.statusCode}): ${getResult.body}");
    if (getResult.statusCode == 200) {
      final Map<String, dynamic> jsonBody = getResult.bodyJson;
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
