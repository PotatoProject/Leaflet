import 'package:moor_flutter/moor_flutter.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';

part 'database.g.dart';

class Notes extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text().withLength(min: 1)();
  TextColumn get styleJson => text().map(const ContentStyleConverter())();
  BoolColumn get starred => boolean().withDefault(Constant(false))();
  DateTimeColumn get creationDate => dateTime().withDefault(Constant(DateTime.now()))();
  DateTimeColumn get lastModifyDate => dateTime().withDefault(Constant(DateTime.now()))();
  IntColumn get color => integer().withDefault(Constant(0))();
  TextColumn get images => text().map(const ImageListConverter())();
  BoolColumn get list => boolean().withDefault(Constant(false))();
  TextColumn get listContent => text().map(const ListContentConverter())();
  TextColumn get reminders => text().map(const ReminderListConverter())();
  BoolColumn get hideContent => boolean().withDefault(Constant(false))();
  TextColumn get pin => text().nullable()();
  TextColumn get password => text().nullable()();
  BoolColumn get usesBiometrics => boolean().withDefault(Constant(false))();
  BoolColumn get deleted => boolean().withDefault(Constant(false))();
  BoolColumn get archived => boolean().withDefault(Constant(false))();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id, synced};
}

@UseMoor(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'notes_database.db',
          logStatements: false,
        )));
  
  @override
  int get schemaVersion => 6;

  Future<List<Note>> getAllNotes() => select(notes).get();

  Stream<List<Note>> watchAllNotes() => (select(notes)..orderBy([
    (table) => OrderingTerm(expression: table.creationDate, mode: OrderingMode.desc)
  ])).watch();

  Future<Note> getLastNote() async => (await (select(notes)..orderBy([
    (table) => OrderingTerm(expression: table.id, mode: OrderingMode.asc)
  ])).get()).last;

  Future insertNote(Note note) => into(notes).insert(note, orReplace: true);

  Future updateNote(Note note) => update(notes).replace(note);

  Future deleteNote(Note note) => delete(notes).delete(note);
}