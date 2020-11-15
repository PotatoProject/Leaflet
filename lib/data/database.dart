import 'package:moor/moor.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/data/model/tag_list.dart';

part 'database.g.dart';

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get styleJson =>
      text().map(const ContentStyleConverter()).nullable()();
  BoolColumn get starred => boolean().withDefault(Constant(false))();
  DateTimeColumn get creationDate =>
      dateTime()();
  DateTimeColumn get lastModifyDate =>
      dateTime()();
  IntColumn get color => integer().withDefault(Constant(0))();
  TextColumn get images => text().map(const ImageListConverter())();
  BoolColumn get list => boolean().withDefault(Constant(false))();
  TextColumn get listContent => text().map(const ListContentConverter())();
  TextColumn get reminders => text().map(const ReminderListConverter())();
  TextColumn get tags => text().map(const TagListConverter())();
  BoolColumn get hideContent => boolean().withDefault(Constant(false))();
  BoolColumn get lockNote => boolean().withDefault(Constant(false))();
  BoolColumn get usesBiometrics => boolean().withDefault(Constant(false))();
  BoolColumn get deleted => boolean().withDefault(Constant(false))();
  BoolColumn get archived => boolean().withDefault(Constant(false))();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer().withDefault(Constant(0))();
  DateTimeColumn get lastModifyDate =>
      dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [Notes, Tags], daos: [NoteHelper, TagHelper])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 6;
}
