import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:potato_notes/data/model/saved_image.dart';

class ImageListConverter extends TypeConverter<List<SavedImage>, String> {
  const ImageListConverter();
  @override
  List<SavedImage>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }

    List<dynamic> decoded = json.decode(fromDb);
    return List.generate(
      decoded.length,
      (index) => SavedImage.fromJson(
        decoded[index],
      ),
    );
  }

  @override
  String? mapToSql(List<SavedImage>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
