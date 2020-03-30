import 'package:json_annotation/json_annotation.dart';

part 'list_content.g.dart';

@JsonSerializable()
class ListContent {
  Map<String, bool> content;

  ListContent(this.content);

  factory ListContent.fromJson(Map<String, dynamic> json) =>
      _$ListContentFromJson(json);

  Map<String, dynamic> toJson() => _$ListContentToJson(this);
}