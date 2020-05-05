import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';

part 'list_content.g.dart';

@JsonSerializable()
class ListContent {
  List<ListItem> content;

  ListContent(this.content);

  factory ListContent.fromJson(Map<String, dynamic> json) =>
      _$ListContentFromJson(json);

  Map<String, dynamic> toJson() => _$ListContentToJson(this);
}

@JsonSerializable()
class ListItem {
  int id;
  String text;
  bool status;

  ListItem(this.id, this.text, this.status);

  factory ListItem.fromJson(Map<String, dynamic> json) =>
      _$ListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListItemToJson(this);
}

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
