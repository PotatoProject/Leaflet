import 'package:potato_notes/data/database.dart';

abstract class NoteInterface {
  Note add(Note note);
  Note update(Note note);
  bool delete(int id);
  bool deleteAll();
  List<Note> list();
}
