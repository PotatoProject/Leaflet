import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:potato_notes/internal/utils.dart';

class IdListConverter extends TypeConverter<List<String>, String> {
  const IdListConverter();

  @override
  List<String>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }

    final List<dynamic> data = Utils.asList<dynamic>(json.decode(fromDb));

    return data.map((e) => e is Map ? jsonEncode(e) : e.toString()).toList();
  }

  @override
  String? mapToSql(List<String>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
