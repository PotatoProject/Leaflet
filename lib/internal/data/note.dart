import 'package:cbl/cbl.dart';
import 'package:potato_notes/internal/utils.dart';

class Note {
  late final MutableDocument doc;

  Note.existing(this.doc);

  Note.new() {
    doc = MutableDocument.withId(Utils.generateId(), {
      "title": "",
      "content": "",
      "creationDate": DateTime.now().toIso8601String(),
      "folder": "default"
    });
  }

  String get id => doc.id;

  String get title => doc.string("title") ?? "";
  set title(String input) => doc.setString(input, key: "title");

  String get content => doc.string("content") ?? "";
  set content(String input) => doc.setString(input, key: "content");

  bool get starred => doc.boolean("starred");
  set starred(bool input) => doc.setBoolean(input, key: "starred");

  DateTime get creationDate => doc.date("creationDate") ?? DateTime.now();

  int get color => doc.integer("color");
  set color(int input) => doc.setInteger(input, key: "color");

  bool get list => doc.boolean("list");
  set list(bool input) => doc.setBoolean(input, key: "list");

  bool get hideContent => doc.boolean("hideContent");
  set hideContent(bool input) => doc.setBoolean(input, key: "hideContent");

  bool get lockNote => doc.boolean("lockNote");
  set lockNote(bool input) => doc.setBoolean(input, key: "lockNote");

  bool get usesBiometrics => doc.boolean("usesBiometrics");
  set usesBiometrics(bool input) =>
      doc.setBoolean(input, key: "usesBiometrics");

  String get folder => doc.string("folder") ?? "default";
  set folder(String input) => doc.setString(input, key: "folder");

  bool get deleted => doc.boolean("deleted");
  set deleted(bool input) => doc.setBoolean(input, key: "deleted");

  bool get archived => doc.boolean("archived");
  set archived(bool input) => doc.setBoolean(input, key: "archived");
}
