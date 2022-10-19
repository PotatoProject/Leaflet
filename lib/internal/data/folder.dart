import 'package:cbl/cbl.dart';
import 'package:potato_notes/internal/utils.dart';

class Folder {
  late final MutableDocument doc;
  late final bool internal;

  Folder.new() {
    internal = false;
    doc = MutableDocument.withId(Utils.generateId(), {
      "name": "",
      "icon": 0,
      "color": 0,
      "readOnly": false,
    });
  }
  Folder.existing(this.doc) {
    internal = false;
  }

  Folder.internal(
      {required String id,
      required String name,
      required int icon,
      required int color,
      required bool readOnly}) {
    internal = true;
    doc = MutableDocument.withId(
      id,
      {"name": name, "icon": icon, "color": color, "readOnly": readOnly},
    );
  }

  String get id => doc.id;

  String get name => doc.string("name") ?? "";
  set name(String input) => doc.setString(input, key: "name");

  int get icon => doc.integer("icon");
  set icon(int input) => doc.setInteger(input, key: "icon");

  int get color => doc.integer("color");
  set color(int input) => doc.setInteger(input, key: "color");

  bool get readOnly => doc.boolean("readOnly");
  set readOnly(bool input) => doc.setBoolean(input, key: "readOnly");
}

class BuiltInFolders {
  const BuiltInFolders._();

  static final Folder all = Folder.internal(
    id: 'all',
    name: "All",
    icon: 4,
    color: -1,
    readOnly: false,
  );

  static final Folder home = Folder.internal(
    id: 'default',
    name: "Home",
    icon: 1,
    color: -1,
    readOnly: false,
  );

  static final Folder trash = Folder.internal(
    id: 'trash',
    name: "Trash",
    icon: 2,
    color: -1,
    readOnly: true,
  );

  /// This folder here must be created for retrocompatibility purposes only,
  /// any other usage is disallowed
  static final Folder archive = Folder.internal(
    id: 'archive',
    name: "Archive",
    icon: 3,
    color: -1,
    readOnly: true,
  );

  static final List<Folder> values = [
    all,
    home,
    trash,
  ];
}
