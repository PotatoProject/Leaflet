import 'package:cbl/cbl.dart';
import 'package:potato_notes/internal/data/folder.dart';
import 'package:potato_notes/internal/data/note.dart';
import 'package:potato_notes/internal/utils.dart';

class Data {
  late final Database _folderDB;
  late final Database _noteDB;

  Future init() async {
    Database.log.custom!.level = LogLevel.verbose;
    _folderDB = await Database.openAsync('folderDB');
    _noteDB = await Database.openAsync('notes');
  }

  Future sync() async {
    final replicator = await Replicator.create(
      ReplicatorConfiguration(
        database: _noteDB,
        target: UrlEndpoint(Uri.parse('ws://192.168.178.24:4984/notes')),
        authenticator:
            BasicAuthenticator(username: "sync_gateway", password: "password"),
      ),
    );
    await replicator.addChangeListener((change) {
      print(change.status.progress);
      print('Replicator activity: ${change.status.activity}');
    });
    await replicator.start(reset: true);
  }

  Future<List<Folder>> listFolders() async {
    final query = const QueryBuilder()
        .selectAll([SelectResult.all()]).from(DataSource.database(_folderDB));
    final resultSet = await query.execute();
    return resultSet
        .asStream()
        .map((result) => Folder.existing(MutableDocument(result.toPlainMap())))
        .toList();
  }

  Stream<List<Folder>> watchFolders() async* {
    yield await listFolders();
    await for (final event in _folderDB.changes()) {
      yield await listFolders();
    }
  }

  Future<void> saveFolder(Folder folder) async {
    await _folderDB.saveDocument(folder.doc);
  }

  Future<void> deleteFolder(Folder folder) async {
    await _folderDB.deleteDocument(folder.doc);
  }

  Future<void> deleteFolderById(String id) async {
    await _folderDB.deleteIndex(id);
  }

  Future<List<Note>> listNotes(Folder folder) async {
    final query = const QueryBuilder()
        .select(
          SelectResult.expression(Meta.id),
          SelectResult.all(),
        )
        .from(DataSource.database(_noteDB));
    final resultSet = await query.execute();
    return resultSet.asStream().map((result) {
      var map = result.dictionary('notes')?.toPlainMap();
      print(map);
      var doc = MutableDocument.withId(result.string('id') ?? "", map);
      print(doc.string("title"));
      print(doc.id);
      return Note.existing(doc);
    }).toList();
  }

  Stream<List<Note>> watchNotes(Folder folder) async* {
    print(folder.name);
    var list = await listNotes(folder);
    print(list);
    yield list;
    await for (final event in _noteDB.changes()) {
      yield await listNotes(folder);
    }
  }

  Future<void> saveNote(Note note) async {
    print(note);
    var result = await _noteDB.saveDocument(note.doc);
    print('Saved note ${result}');
  }

  Future<void> deleteNote(Note note) async {
    await _noteDB.deleteDocument(note.doc);
  }

  Future<void> deleteNoteById(String id) async {
    await _noteDB.deleteIndex(id);
  }
}
