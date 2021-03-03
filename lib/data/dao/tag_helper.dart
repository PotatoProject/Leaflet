import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';

part 'tag_helper.g.dart';

@UseDao(tables: [Tags])
class TagHelper extends DatabaseAccessor<AppDatabase> with _$TagHelperMixin {
  final AppDatabase db;

  TagHelper(this.db) : super(db);

  Future<List<Tag>> listTags(TagReturnMode returnMode) {
    switch (returnMode) {
      case TagReturnMode.ALL:
        return select(tags).get();
      case TagReturnMode.SYNCED:
        return (select(tags)..where((table) => table.id.contains("-synced")))
            .get();
      case TagReturnMode.LOCAL:
      default:
        return (select(tags)
              ..where((table) => table.id.contains("-synced").not()))
            .get();
    }
  }

  Stream<List<Tag>> watchTags(TagReturnMode returnMode) {
    SimpleSelectStatement<$TagsTable, Tag> selectQuery;
    switch (returnMode) {
      case TagReturnMode.ALL:
        selectQuery = select(tags);
        break;
      case TagReturnMode.SYNCED:
        selectQuery = select(tags)
          ..where((table) => table.id.contains("-synced"));
        break;
      case TagReturnMode.LOCAL:
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

  Future<void> deleteAllTags() async {
    final List<Tag> tags = await listTags(TagReturnMode.ALL);
    tags.forEach((tag) async {
      await deleteTag(tag);
    });
  }
}

enum TagReturnMode { LOCAL, SYNCED, ALL }
