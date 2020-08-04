import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';

part 'tag_helper.g.dart';

@UseDao(tables: [Tags])
class TagHelper extends DatabaseAccessor<AppDatabase> with _$TagHelperMixin {
  final AppDatabase db;

  TagHelper(this.db) : super(db);

  Future<List<Tag>> listTags() => select(tags).get();
  Stream<List<Tag>> watchTags() => select(tags).watch();

  Future<void> saveTag(Tag tag) {
    return into(tags).insert(tag, mode: InsertMode.replace);
  }

  Future<void> deleteTag(Tag tag) => delete(tags).delete(tag);
}
