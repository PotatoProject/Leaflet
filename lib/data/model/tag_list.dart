import 'dart:convert';

import 'package:moor/moor.dart';

class TagListConverter extends TypeConverter<List<String>, String> {
  const TagListConverter();
  @override
  List<String> mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    final List<dynamic> decoded = json.decode(fromDb);
    return List.generate(decoded.length, (index) => decoded[index] as String);
  }

  @override
  String mapToSql(List<String> value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
