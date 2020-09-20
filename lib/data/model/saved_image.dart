import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

part 'saved_image.g.dart';

@JsonSerializable()
class SavedImage {
  String id = Utils.generateId();
  Uri uri;
  StorageLocation storageLocation = StorageLocation.IMGUR;
  String hash;
  String blurHash;
  bool encrypted = false;
  @observable
  bool uploaded = false;

  @observable
  get existsLocally => prefs.downloadedImages.contains(hash);
  get path => appInfo.tempDirectory.path + "/$hash.jpg";

  SavedImage(
      this.id, this.uri, this.storageLocation, this.hash, this.encrypted);
  SavedImage.empty();

  factory SavedImage.fromJson(Map<String, dynamic> json) =>
      _$SavedImageFromJson(json);

  Map<String, dynamic> toJson() => _$SavedImageToJson(this);

  enableEncryption() {
    encrypted = true;
  }

  @override
  String toString() => json.encode(toJson());
}

enum StorageLocation { LOCAL, IMGUR, SYNC }
