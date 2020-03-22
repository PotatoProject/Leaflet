import 'dart:convert';

class ListItem {
  String text;
  bool status;

  ListItem(this.text, this.status);

  ListItem.fromJson(Map<String, dynamic> json) {
    this.text = json["text"];
    this.status = json["status"];
  }

  Map<String, dynamic> get toJson => {
        "text": this.text,
        "status": this.status,
      };

  @override
  String toString() => json.encode(this.toJson);
}