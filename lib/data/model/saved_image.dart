import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

part 'saved_image.g.dart';

@JsonSerializable()
@Deprecated("This class has been superceded by NoteImage")
class SavedImage {
  String id = Utils.generateId();
  StorageLocation storageLocation = StorageLocation.local;
  String? hash;
  String? blurHash;
  String? fileExtension;
  bool encrypted = false;
  double? width;
  double? height;
  @observable
  bool uploaded = false;

  @observable
  bool get existsLocally => File(path).existsSync();
  String get path =>
      join(appDirectories.imagesDirectory.path, "$id$fileExtension");

  @Deprecated("This class has been superceded by NoteImage")
  SavedImage({
    required this.id,
    this.storageLocation = StorageLocation.local,
    this.hash,
    this.fileExtension,
    this.encrypted = false,
    this.width,
    this.height,
  });

  @Deprecated("This class has been superceded by NoteImage")
  SavedImage.empty();

  Size get size => Size(width! > 0 ? width! : 480, height! > 0 ? height! : 480);

  @Deprecated("This class has been superceded by NoteImage")
  factory SavedImage.fromJson(Map<String, dynamic> json) =>
      _$SavedImageFromJson(
        json.map((key, value) {
          if (key == "storageLocation") {
            return MapEntry(key, value.toString().toLowerCase());
          } else {
            return MapEntry(key, value);
          }
        }),
      );

  Map<String, dynamic> toJson() => _$SavedImageToJson(this);

  void enableEncryption() {
    encrypted = true;
  }

  @override
  String toString() => json.encode(toJson());

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(
        id,
        hash,
        blurHash,
        storageLocation,
        fileExtension,
        encrypted,
        width,
        height,
        uploaded,
      );

  @override
  bool operator ==(Object other) {
    if (other is SavedImage) {
      return id == other.id &&
          hash == other.hash &&
          blurHash == other.blurHash &&
          storageLocation == other.storageLocation &&
          fileExtension == other.fileExtension &&
          encrypted == other.encrypted &&
          width == other.width &&
          height == other.height &&
          uploaded == other.uploaded;
    }

    return false;
  }
}

enum StorageLocation { local, sync }
