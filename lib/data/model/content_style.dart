import 'package:json_annotation/json_annotation.dart';

part 'content_style.g.dart';

@JsonSerializable()
class ContentStyle {
  List<int> data;

  ContentStyle(this.data);

  factory ContentStyle.fromJson(Map<String, dynamic> json) =>
      _$ContentStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ContentStyleToJson(this);
}