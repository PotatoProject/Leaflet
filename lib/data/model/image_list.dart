import 'package:json_annotation/json_annotation.dart';

part 'image_list.g.dart';

@JsonSerializable()
class ImageList {
  List<Uri> images;

  ImageList(this.images);

  factory ImageList.fromJson(Map<String, dynamic> json) =>
      _$ImageListFromJson(json);

  Map<String, dynamic> toJson() => _$ImageListToJson(this);
}