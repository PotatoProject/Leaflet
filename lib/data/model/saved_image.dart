import 'package:json_annotation/json_annotation.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

part 'saved_image.g.dart';

@JsonSerializable()
class SavedImage {
  String id = Utils.generateId();
  Uri uri;
  StorageLocation storageLocation = StorageLocation.SYNC;
  String hash;
  String blurHash;
  bool encrypted = false;
  bool uploaded = false;

  SavedImage(
      this.id, this.uri, this.storageLocation, this.hash, this.encrypted);
  SavedImage.empty();

  factory SavedImage.fromJson(Map<String, dynamic> json) =>
      _$SavedImageFromJson(json);

  Map<String, dynamic> toJson() => _$SavedImageToJson(this);

  enableEncryption() {
    encrypted = true;
  }

  String getPath() {
    return appInfo.tempDirectory.path + "/$hash.jpg";
  }
}

enum StorageLocation { LOCAL, IMGUR, SYNC }
