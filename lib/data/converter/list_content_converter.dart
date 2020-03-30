
import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/model/list_content.dart';

class ListContentConverter extends TypeConverter<ListContent, String> {
  const ListContentConverter();
  @override
  ListContent mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return ListContent.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(ListContent value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}