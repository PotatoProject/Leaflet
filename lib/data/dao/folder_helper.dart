import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/custom_icons.dart';

part 'folder_helper.g.dart';

@DriftAccessor(tables: [Folders])
class FolderHelper extends DatabaseAccessor<AppDatabase>
    with _$FolderHelperMixin {
  final AppDatabase db;

  FolderHelper(this.db) : super(db);

  Future<List<Folder>> listFolders() => select(folders).get();

  Stream<List<Folder>> watchFolders() => select(folders).watch();

  Future<void> saveFolder(Folder folder) =>
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
    icon: 4,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: false,
  );

  static final Folder home = Folder(
    id: 'default',
    name: "Home",
    icon: 1,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: false,
  );

  static final Folder trash = Folder(
    id: 'trash',
    name: "Trash",
    icon: 2,
    color: -1,
    lastChanged: DateTime(0),
    readOnly: true,
  );

  /// This folder here must be created for retrocompatibility purposes only,
  /// any other usage is disallowed
  static final Folder archive = Folder(
    id: 'archive',
    name: "Archive",
    icon: 3,
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

const List<IconData> folderDefaultIcons = [
  Icons.folder_outlined,
  Icons.home_outlined,
  Icons.delete_outline,
  MdiIcons.archiveOutline,
  CustomIcons.notes,
  Icons.star_border,
  Icons.emoji_events_outlined,
  Icons.local_cafe_outlined,
  Icons.spa_outlined,
  Icons.videogame_asset_outlined,
  Icons.favorite_outline,
  MdiIcons.incognito,
  Icons.local_bar_outlined,
  Icons.sports_soccer_outlined,
  Icons.school_outlined,
  Icons.bar_chart_outlined,
  Icons.local_airport_outlined,
  Icons.work_outline,
  Icons.question_answer_outlined,
  Icons.notifications_none_outlined,
  Icons.smart_toy_outlined,
  Icons.campaign_outlined,
  Icons.people_alt_outlined,
  Icons.person_outlined,
];
