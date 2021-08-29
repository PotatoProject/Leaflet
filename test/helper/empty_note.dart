import 'package:potato_notes/data/database.dart';

class EmptyNote {
  const EmptyNote._();

  static Note get() {
    return Note(
      id: "",
      title: "",
      content: "",
      starred: false,
      creationDate: DateTime.now(),
      lastModifyDate: DateTime.now(),
      color: 0,
      images: [],
      list: false,
      listContent: [],
      reminders: [],
      tags: [],
      hideContent: false,
      lockNote: false,
      usesBiometrics: false,
      deleted: false,
      archived: false,
      synced: false,
    );
  }
}
