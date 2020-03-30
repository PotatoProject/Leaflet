
import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/model/content_style.dart';

class ContentStyleConverter extends TypeConverter<ContentStyle, String> {
  const ContentStyleConverter();
  @override
  ContentStyle mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return ContentStyle.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(ContentStyle value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}