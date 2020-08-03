import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';

part 'tag_list.g.dart';

@JsonSerializable()
class TagList {
  List<String> tagIds;

  TagList(this.tagIds);

  factory TagList.fromJson(Map<String, dynamic> json) =>
      _$TagListFromJson(json);

  Map<String, dynamic> toJson() => _$TagListToJson(this);
}

class TagListConverter extends TypeConverter<TagList, String> {
  const TagListConverter();
  @override
  TagList mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return TagList.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(TagList value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}
