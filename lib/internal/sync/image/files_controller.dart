import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/controller.dart';
import 'package:potato_notes/internal/utils.dart';

class FilesController extends Controller {
  Future<void> uploadImageToSync(String hash, File file) async {
    await dio.put(
      await getUploadUrlFromSync(hash),
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

  Future<String> getUploadUrlFromSync(String hash) async {
    final Response getResult = await dio.get(
      url("put/$hash.jpg"),
      options: Options(
        headers: Controller.tokenHeaders,
      ),
    );
    if (getResult.statusCode == 200) {
      return getResult.data.toString();
    } else {
      throw "Cant get imageurl ${getResult.data}";
    }
  }

  Future<String> getDownloadUrlFromSync(String hash) async {
    final Response getResult = await dio.get(
      url("get/$hash.jpg"),
      options: Options(
        headers: Controller.tokenHeaders,
      ),
    );
    if (getResult.statusCode == 200) {
      return getResult.data.toString();
    } else {
      throw "Cant get imageurl ${getResult.data}";
    }
  }

  Future<void> deleteImage(String hash) async {
    final Response deleteResult = await dio.delete(
      url("delete/$hash.jpg"),
      options: Options(
        headers: Controller.tokenHeaders,
      ),
    );
    if (deleteResult.statusCode != 200) {
      throw "Cant delete image ${deleteResult.data}";
    }
  }

  Future<FilesApiStats> getStats() async {
    final Response getResult = await dio.get(
      url("limit"),
      options: Options(
        headers: Controller.tokenHeaders,
      ),
    );
    if (getResult.statusCode == 200) {
      final Map<String, dynamic> jsonBody =
          Utils.asMap<String, dynamic>(getResult.data);
      return FilesApiStats(jsonBody["used"] as int, jsonBody["limit"] as int);
    } else {
      throw "Cant get stats ${getResult.data}";
    }
  }

  @override
  String get prefix => "files";
}

@immutable
class FilesApiStats {
  final int used;
  final int limit;

  const FilesApiStats(this.used, this.limit);
}
