import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:potato_notes/internal/sync/blob.dart';

abstract class BlobService {
  Future<List<Blob>> getAllBlobs();
  Future upsertBlob(Blob blob);
}

class SyncBlobService implements BlobService {
  @override
  Future<List<Blob>> getAllBlobs() async {
    final Response response = await Dio().get(
      'http://192.168.178.24:4000/blob',
      options: Options(headers: {"Authorization": "Bearer test"}),
    );
    final Iterable list = response.data as Iterable;
    final List<Blob> blobs = List<Blob>.from(
      list.map((model) => Blob.fromJson(model as Map<String, dynamic>)),
    );
    return blobs;
  }

  @override
  Future upsertBlob(Blob blob) async {
    final Response response = await Dio().post(
      'http://192.168.178.24:4000/blob',
      data: jsonEncode(blob),
      options: Options(
        contentType: "application/json",
        headers: {"Authorization": "Bearer test"},
      ),
    );
  }
}
