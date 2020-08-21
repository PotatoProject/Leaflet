import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';
import 'package:potato_notes/data/model/saved_image.dart';

part 'image_list.g.dart';

@JsonSerializable()
class ImageList {
  List<SavedImage> data;

  ImageList(this.data);

  List<Uri> get uris {
    return List.generate(data.length, (index) => data[index].uri);
  }

  factory ImageList.fromJson(Map<String, dynamic> json) =>
      _$ImageListFromJson(json);

  Map<String, dynamic> toJson() => _$ImageListToJson(this);
}

class ImageListConverter extends TypeConverter<ImageList, String> {
  const ImageListConverter();
  @override
  ImageList mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return ImageList.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(ImageList value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}
