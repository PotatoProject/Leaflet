import 'package:potato_notes/data/database.dart';

abstract class NoteInterface {
  Future<bool> add(Note note);

  Future<bool> update(String id, Map<String, dynamic> noteDelta);

  Future<bool> delete(String id);

  Future<bool> deleteAll();

  Future<List<Note>> list();
}
