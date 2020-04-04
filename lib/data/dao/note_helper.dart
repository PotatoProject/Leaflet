import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/database.dart';

part 'note_helper.g.dart';

@UseDao(tables: [Notes])
class NoteHelper extends DatabaseAccessor<AppDatabase> with _$NoteHelperMixin {
  final AppDatabase db;

  NoteHelper(this.db) : super(db);

  Future<List<Note>> listNotes() => select(notes).get();

  Stream<List<Note>> noteStream() => (select(notes)
        ..orderBy([
          (table) => OrderingTerm(
              expression: table.creationDate, mode: OrderingMode.desc)
        ]))
      .watch();

  Future<Note> getLastNote() async => (await (select(notes)
            ..orderBy([
              (table) =>
                  OrderingTerm(expression: table.id, mode: OrderingMode.asc)
            ]))
          .get())
      .last;

  Future saveNote(Note note) => into(notes).insert(note, orReplace: true);

  Future deleteNote(Note note) => delete(notes).delete(note);
}
