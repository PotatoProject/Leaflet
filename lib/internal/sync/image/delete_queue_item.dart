import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';

import 'package:json_annotation/json_annotation.dart';
part 'delete_queue_item.g.dart';

@JsonSerializable(nullable: false)
class DeleteQueueItem extends QueueItem {
  final String localPath;
  final SavedImage savedImage;
  final StorageLocation storageLocation;

  DeleteQueueItem({
    @required this.localPath,
    @required this.savedImage,
    this.storageLocation = StorageLocation.LOCAL,
  }) : super(localPath: localPath, savedImage: savedImage);

  @action
  Future<void> deleteImage() async {
    status = QueueItemStatus.ONGOING;
    var url = "${prefs.apiUrl}/files/delete/${savedImage.hash}.jpg";
    String token = await prefs.getToken();
    var response = await dio.delete(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    if (response.statusCode != 200) {
      return;
    } else {
      status = QueueItemStatus.COMPLETE;
    }
  }

  // DeleteQueueItem fromJson(Map<String, dynamic> json)
  //     : localPath = json['localPath'],
  //       savedImage = SavedImage.fromJson(json['email']),
  //       storageLocation = StorageLocation.values.firstWhere((e) => e.toString() == json['storageLocation']), super('', null)
  //       ;
  //
  // Map<String, dynamic> toJson() =>
  //     {
  //       'localPath': localPath,
  //       'savedImage': savedImage.toJson(),
  //       'storageLocation': storageLocation.toString()
  //     };
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory DeleteQueueItem.fromJson(Map<String, dynamic> json) =>
      _$DeleteQueueItemFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DeleteQueueItemToJson(this);
}
