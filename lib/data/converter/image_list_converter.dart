
import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/model/image_list.dart';

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