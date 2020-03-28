import 'dart:convert' as j;
import 'dart:io';

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
    this.title = json["title"] == "" ? null : json["title"];
    this.content = json["content"];
    this.starred = json["starred"] == 1;
    this.creationDate =
        DateTime.fromMillisecondsSinceEpoch(json["creationDate"] ?? 0);
    this.lastModifyDate =
        DateTime.fromMillisecondsSinceEpoch(json["lastModifyDate"] ?? 0);
    this.color = json["color"];

    if (json["images"] != null) {
      if ((json["images"] as String).startsWith("[")) {
        List<dynamic> parsedImages = j.json.decode(json["images"]);
        this.images = List.generate(parsedImages?.length ?? 0, (index) {
          Uri uri = Uri.parse(parsedImages[index]);
          
          if(uri.scheme == "file") {
            File file = File(uri.path);

            if(file.existsSync())
              return uri;
            else return null;
          } else {
            return uri;
          }
        });

        this.images.removeWhere((u) => u == null);
      } else {
        this.images = [Uri.parse(json["images"])];
      }
    } else
      this.images = [];

    this.list = json["list"] == 1;

    if (json["listContent"] != null) {
      if ((json["listContent"] as String).startsWith("[")) {
        List<dynamic> parsedList = j.json.decode(json["listContent"]);
        this.listContent = List.generate(parsedList?.length ?? 0,
            (index) => ListItem.fromJson(parsedList[index]));
      } else {
        this.listContent = List.generate(json["listContent"]?.split("'..'")?.length ?? 0, (index) {
          var item = json["listContent"].split("'..'")[index];
          List<String> listPair = item.split("',,'");
          return ListItem(listPair[1], int.parse(listPair[0]) == 1);
        });
      }
    } else
      this.listContent = [];

    if (json["reminders"] != null) {
      if ((json["reminders"] as String).startsWith("[")) {
        List<dynamic> parsedReminders = j.json.decode(json["reminders"]);
        this.reminders = List.generate(
            parsedReminders?.length ?? 0,
            (index) =>
                DateTime.fromMillisecondsSinceEpoch(parsedReminders[index]));
      } else {
        this.reminders = List.generate(json["reminders"]?.split(":")?.length, (index) {
          var item = json["reminders"].split(":")[index];
          return DateTime.fromMillisecondsSinceEpoch(int.parse(item));
        });
      }
    } else
      this.reminders = [];

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
        "creationDate": this.creationDate.millisecondsSinceEpoch,
        "lastModifyDate": this.lastModifyDate.millisecondsSinceEpoch,
        "color": this.color,
        "images": List.generate(this.images?.length ?? 0,
            (index) => '"' + this.images[index].toString() + '"').toString(),
        "list": this.list ? 1 : 0,
        "listContent": List.generate(this.listContent?.length ?? 0,
            (index) => this.listContent[index].toString()).toString(),
        "reminders": List.generate(
            this.reminders?.length ?? 0,
            (index) =>
                '"' +
                this.reminders[index].millisecondsSinceEpoch.toString() +
                '"').toString(),
        "hideContent": this.hideContent ? 1 : 0,
        "pin": this.pin,
        "password": this.password,
        "usesBiometrics": this.usesBiometrics ? 1 : 0,
        "deleted": this.deleted ? 1 : 0,
        "archived": this.archived ? 1 : 0,
        "synced": this.synced ? 1 : 0,
      };

  @override
  String toString() => j.json.encode(this.toJson);
}
