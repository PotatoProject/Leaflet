import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';

part 'list_content.g.dart';

@JsonSerializable()
class ListItem {
  int id;
  String text;
  bool status;

  ListItem(this.id, this.text, this.status);

  factory ListItem.fromJson(Map<String, dynamic> json) =>
      _$ListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListItemToJson(this);

  @override
  String toString() => json.encode(toJson());
}

class ListContentConverter extends TypeConverter<List<ListItem>, String> {
  const ListContentConverter();
  @override
  List<ListItem>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    List<dynamic> decoded = json.decode(fromDb);
    return List.generate(
      decoded.length,
      (index) => ListItem.fromJson(
        decoded[index],
      ),
    );
  }

  @override
  String? mapToSql(List<ListItem>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
