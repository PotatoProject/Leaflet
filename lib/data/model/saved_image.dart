// @dart=2.12

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
class SavedImage {
  String id = Utils.generateId();
  StorageLocation storageLocation = StorageLocation.sync;
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
  String get path => join(appInfo.tempDirectory.path, "$id$fileExtension");

  SavedImage({
    required this.id,
    this.storageLocation = StorageLocation.sync,
    this.hash,
    this.fileExtension,
    this.encrypted = false,
    this.width,
    this.height,
  });
  SavedImage.empty();

  Size get size => Size(width!, height!);

  factory SavedImage.fromJson(Map<String, dynamic> json) =>
      _$SavedImageFromJson(json);

  Map<String, dynamic> toJson() => _$SavedImageToJson(this);

  void enableEncryption() {
    encrypted = true;
  }

  @override
  String toString() => json.encode(toJson());
}

enum StorageLocation { local, sync }
