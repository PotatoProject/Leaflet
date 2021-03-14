import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:potato_notes/internal/utils.dart';

class TagListConverter extends TypeConverter<List<String>, String> {
  const TagListConverter();
  @override
  List<String>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    final List<String> decoded = Utils.asList<String>(json.decode(fromDb));
    return List.generate(decoded.length, (index) => decoded[index]);
  }

  @override
  String? mapToSql(List<String>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
