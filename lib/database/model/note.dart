import 'dart:convert';

import 'package:potato_notes/database/model/list_item.dart';

class Note {
  int id;
  String title;
  String content;
  bool starred;
  DateTime creationDate;
  DateTime lastModifyDate;
  int color;
  List<Uri> images;
  bool list;
  List<ListItem> listContent;
  List<DateTime> reminders;
  bool hideContent;
  String pin;
  String password;
  bool usesBiometrics;
  bool deleted;
  bool archived;
  bool synced;

  Note();

  Note.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.title = json["title"];
    this.content = json["content"];
    this.starred = json["starred"] == 1;
    this.creationDate = DateTime.fromMillisecondsSinceEpoch(json["creationDate"] ?? 0);
    this.lastModifyDate = DateTime.fromMillisecondsSinceEpoch(json["lastModifyDate"] ?? 0);
    this.color = json["color"];
    this.images = json["images"] is String
        ? [Uri.parse(json["images"])]
        : List.generate(
            json["images"]?.length ?? 0, (index) => Uri.parse(json["images"][index]));
    this.list = json["list"] == 1;
    this.listContent = json["listContent"] is String
        ? List.generate(json["listContent"]?.split("'..'")?.length ?? 0, (index) {
          var item = json["listContent"].split("'..'")[index];
          List<String> listPair = item.split("',,'");
          return ListItem(listPair[1], int.parse(listPair[0]) == 1);
        })
        : List.generate(json["listContent"]?.length ?? 0,
            (index) => ListItem.fromJson(json["listContent"][index]));
    this.reminders = json["reminders"] is String
        ? List.generate(json["reminders"]?.split(":")?.length, (index) {
          var item = json["reminders"].split(":")[index];
          return DateTime.fromMillisecondsSinceEpoch(int.parse(item));
        })
        : List.generate(
            json["reminders"]?.length ?? 0,
            (index) =>
                DateTime.fromMillisecondsSinceEpoch(json["reminders"][index]));
    this.hideContent = json["hideContent"] == 1;
    this.pin = json["pin"];
    this.password = json["password"];
    this.usesBiometrics = json["usesBiometrics"] == 1;
    this.deleted = json["deleted"] == 1;
    this.archived = json["archived"] == 1;
    this.synced = json["synced"] == 1;
  }

  Map<String, dynamic> get toJson => {
        "id": this.id,
        "title": this.title,
        "content": this.content,
        "starred": this.starred ? 1 : 0,
        "creationDate": this.creationDate,
        "lastModifyDate": this.lastModifyDate,
        "color": this.color,
        "images": List.generate(
            this.images.length, (index) => this.images[index].toString()),
        "list": this.list ? 1 : 0,
        "listContent": List.generate(
            this.listContent.length, (index) => this.listContent[index].toJson),
        "reminders": List.generate(this.reminders.length,
            (index) => this.reminders[index].millisecondsSinceEpoch.toString()),
        "hideContent": this.hideContent ? 1 : 0,
        "pin": this.pin,
        "password": this.password,
        "usesBiometrics": this.usesBiometrics ? 1 : 0,
        "deleted": this.deleted ? 1 : 0,
        "archived": this.archived ? 1 : 0,
        "synced": this.synced ? 1 : 0,
      };

  @override
  String toString() => json.encode(this.toJson);
}