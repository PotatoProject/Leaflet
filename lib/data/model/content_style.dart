import 'dart:convert';

import 'package:moor/moor.dart';

class ContentStyleConverter extends TypeConverter<List<int>, String> {
  const ContentStyleConverter();
  @override
  List<int>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    List<dynamic> decoded = json.decode(fromDb);
    return List.generate(decoded.length, (index) => decoded[index] as int);
  }

  @override
  String? mapToSql(List<int>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
