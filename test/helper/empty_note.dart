import 'package:potato_notes/data/database.dart';

class EmptyNote {
  static Note get(){
    return Note(
      id: "",
      title: "",
      content: "",
      styleJson: [],
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