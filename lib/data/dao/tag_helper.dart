import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';

part 'tag_helper.g.dart';

@UseDao(tables: [Tags])
class TagHelper extends DatabaseAccessor<AppDatabase> with _$TagHelperMixin {
  final AppDatabase db;

  TagHelper(this.db) : super(db);

  Future<List<Tag>> listTags(TagReturnMode returnMode) {
    switch (returnMode) {
      case TagReturnMode.SYNCED:
        return (select(tags)..where((table) => table.id.contains("-synced")))
            .get();
      default:
        return (select(tags)
              ..where((table) => table.id.contains("-synced").not()))
            .get();
    }
  }

  Stream<List<Tag>> watchTags(TagReturnMode returnMode) {
    SimpleSelectStatement<$TagsTable, Tag> selectQuery;
    switch (returnMode) {
      case TagReturnMode.SYNCED:
        selectQuery = select(tags)
          ..where((table) => table.id.contains("-synced"));
        break;
      default:
        selectQuery = select(tags)
          ..where((table) => table.id.contains("-synced").not());
        break;
    }
    return (selectQuery).watch();
  }

  Future<void> saveTag(Tag tag) {
    return into(tags).insert(tag, mode: InsertMode.replace);
  }

  Future<void> deleteTag(Tag tag) => delete(tags).delete(tag);
}

enum TagReturnMode { LOCAL, SYNCED }
