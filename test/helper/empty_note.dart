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
      lastChanged: DateTime.now(),
      color: 0,
      images: [],
      list: false,
      listContent: [],
      reminders: [],
      tags: [],
      folder: 'default',
      hideContent: false,
      lockNote: false,
      usesBiometrics: false,
    );
  }
}
