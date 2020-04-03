import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'content_style.g.dart';

@JsonSerializable()
class ContentStyle {
  List<int> data;

  ContentStyle(this.data);

  factory ContentStyle.fromJson(Map<String, dynamic> json) =>
      _$ContentStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ContentStyleToJson(this);
}

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