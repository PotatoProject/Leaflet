import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:potato_notes/internal/pocketbase_helper.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/blob.dart';

abstract class BlobService {
  Future<List<RecordModel>> getAllBlobs();
  Future upsertBlob(Blob blob, bool existsOnRemote);
}

// class SyncBlobService implements BlobService {
//   @override
//   Future<List<Blob>> getAllBlobs() async {
//     final Response response = await Dio().get(
//       'http://192.168.178.24:4000/blob',
//       options: Options(headers: {"Authorization": "Bearer test"}),
//     );
//     final Iterable list = response.data as Iterable;
//     final List<Blob> blobs = List<Blob>.from(
//       list.map((model) => Blob.fromJson(model as Map<String, dynamic>)),
//     );
//     return blobs;
//   }

//   @override
//   Future upsertBlob(Blob blob) async {
//     final Response response = await Dio().post(
//       'http://192.168.178.24:4000/blob',
//       data: jsonEncode(blob),
//       options: Options(
//         contentType: "application/json",
//         headers: {"Authorization": "Bearer test"},
//       ),
//     );
//   }
// }

class PocketbaseBlobService implements BlobService {
  @override
  Future<List<RecordModel>> getAllBlobs() async {
    final List<RecordModel> resultList =
        await pocketbase.records.getFullList("blobs");
    return resultList;
  }

  @override
  Future upsertBlob(Blob blob, bool existsOnRemote) async {
    if (existsOnRemote) {
      await pocketbase.records.update("blobs", blob.id,
          body: blob.toJson()
            ..putIfAbsent("account_id", () => PocketbaseHelper.getUserId()));
    } else {
      await pocketbase.records.create("blobs",
          body: blob.toJson()
            ..putIfAbsent("account_id", () => PocketbaseHelper.getUserId()));
    }
  }
}
