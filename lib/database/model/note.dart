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
    this.starred = json["starred"];
    this.creationDate = json["creationDate"];
    this.lastModifyDate = json["lastModifyDate"];
    this.color = json["color"];
    this.images = List.generate(
        json["images"].length, (index) => Uri.parse(json["images"][index]));
    this.list = json["list"];
    this.listContent = List.generate(json["listContent"].length,
        (index) => ListItem.fromJson(json["listContent"][index]));
    this.reminders = List.generate(
        json["reminders"].length,
        (index) =>
            DateTime.fromMillisecondsSinceEpoch(json["reminders"][index]));
    this.hideContent = json["hideContent"];
    this.pin = json["pin"];
    this.password = json["password"];
    this.usesBiometrics = json["usesBiometrics"];
    this.deleted = json["deleted"];
    this.archived = json["archived"];
    this.synced = json["synced"];
  }

  Map<String, dynamic> get toJson => {
        "id": this.id,
        "title": this.title,
        "content": this.content,
        "starred": this.starred,
        "creationDate": this.creationDate,
        "lastModifyDate": this.lastModifyDate,
        "color": this.color,
        "images": List.generate(
            this.images.length, (index) => this.images[index].toString()),
        "list": this.list,
        "listContent": List.generate(
            this.listContent.length, (index) => this.listContent[index].toJson),
        "reminders": List.generate(this.reminders.length,
            (index) => this.reminders[index].millisecondsSinceEpoch.toString()),
        "hideContent": this.hideContent,
        "pin": this.pin,
        "password": this.password,
        "usesBiometrics": this.usesBiometrics,
        "deleted": this.deleted,
        "archived": this.archived,
        "synced": this.synced,
      };

  @override
  String toString() => json.encode(this.toJson);
}