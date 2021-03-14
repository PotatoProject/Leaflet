import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:potato_notes/internal/utils.dart';

class ContentStyleConverter extends TypeConverter<List<int>, String> {
  const ContentStyleConverter();
  @override
  List<int>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    final List<int> decoded = Utils.asList<int>(json.decode(fromDb));
    return List.generate(decoded.length, (index) => decoded[index]);
  }

  @override
  String? mapToSql(List<int>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
