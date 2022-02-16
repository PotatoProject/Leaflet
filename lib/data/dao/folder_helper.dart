import 'package:drift/drift.dart';
import 'package:potato_notes/data/database.dart';

part 'folder_helper.g.dart';

@DriftAccessor(tables: [Folders])
class FolderHelper extends DatabaseAccessor<AppDatabase>
    with _$FolderHelperMixin {
  final AppDatabase db;

  FolderHelper(this.db) : super(db);

  Future<List<Folder>> listFolders() => select(folders).get();

  Stream<List<Folder>> watchFolders() => select(folders).watch();

  Future<void> createFolder(Folder folder) =>
      into(folders).insert(folder, mode: InsertMode.replace);

  Future<void> deleteFolder(Folder folder) => delete(folders).delete(folder);

  Future<void> deleteFolderById(String id) =>
      (delete(folders)..where((tbl) => tbl.id.equals(id))).go();
}

class BuiltInFolders {
  const BuiltInFolders._();

  static final Folder all = Folder(
    id: 'all',
    name: "All",
    icon: -1,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: false,
  );

  static final Folder home = Folder(
    id: 'default',
    name: "Home",
    icon: -1,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: false,
  );

  static final Folder trash = Folder(
    id: 'trash',
    name: "Trash",
    icon: -1,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: true,
  );

  /// This folder here must be created for retrocompatibility purposes only,
  /// any other usage is disallowed
  static final Folder archive = Folder(
    id: 'archive',
    name: "Archive",
    icon: -1,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: true,
  );

  static final List<Folder> values = [
    all,
    home,
    trash,
  ];
}
