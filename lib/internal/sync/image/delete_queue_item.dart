// @dart=2.12

import 'package:dio/dio.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';

import 'package:json_annotation/json_annotation.dart';
part 'delete_queue_item.g.dart';

@JsonSerializable()
class DeleteQueueItem extends QueueItem {
  final String localPath;
  final SavedImage savedImage;
  final StorageLocation storageLocation;

  DeleteQueueItem({
    required this.localPath,
    required this.savedImage,
    this.storageLocation = StorageLocation.LOCAL,
  }) : super(localPath: localPath, savedImage: savedImage);

  Future<void> deleteImage() async {
    status = QueueItemStatus.ONGOING;
    final String url = "${prefs.apiUrl}/files/delete/${savedImage.hash}.jpg";
    final String token = await prefs.getToken();
    final Response response = await dio.delete(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    if (response.statusCode != 200) {
      return;
    } else {
      status = QueueItemStatus.COMPLETE;
    }
  }

  factory DeleteQueueItem.fromJson(Map<String, dynamic> json) =>
      _$DeleteQueueItemFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteQueueItemToJson(this);
}
