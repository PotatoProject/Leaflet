import 'package:moor/moor.dart';
import 'package:potato_notes/data/database.dart';

part 'image_helper.g.dart';

@UseDao(tables: [NoteImages])
class ImageHelper extends DatabaseAccessor<AppDatabase>
    with _$ImageHelperMixin {
  final AppDatabase db;

  ImageHelper(this.db) : super(db);

  Future<List<NoteImage>> listAllImages() {
    return select(noteImages).get();
  }

  Future<List<NoteImage>> listImages(Note note) {
    return (select(noteImages)
          ..where(
            (image) => image.id.isIn(note.images),
          ))
        .get();
  }

  Future<NoteImage?> getImage(String id) {
    return (select(noteImages)
          ..where(
            (image) => image.id.equals(id),
          ))
        .getSingleOrNull();
  }

  Future<List<NoteImage>> getImagesById(List<String> ids) {
    return (select(noteImages)..where((table) => table.id.isIn(ids))).get();
  }

  Stream<List<NoteImage>> watchImages(Note note) {
    final SimpleSelectStatement<$NoteImagesTable, NoteImage> selectQuery =
        select(noteImages)
          ..where(
            (image) => image.id.isIn(note.images),
          );
    return selectQuery.watch();
  }

  Stream<List<NoteImage>> watchImagesByIds(List<String> images) {
    final SimpleSelectStatement<$NoteImagesTable, NoteImage> selectQuery =
        select(noteImages)
          ..where(
            (image) => image.id.isIn(images),
          );
    return selectQuery.watch();
  }

  Future<void> saveImage(NoteImage image) {
    return into(noteImages).insert(image, mode: InsertMode.replace);
  }

  Future<void> deleteImage(NoteImage image) => delete(noteImages).delete(image);

  Future<void> deleteImageById(String id) =>
      (delete(noteImages)..where((image) => image.id.equals(id))).go();

  Future<void> deleteAllImages() async {
    final List<NoteImage> images = await listAllImages();
    for (final NoteImage image in images) {
      await deleteImage(image);
    }
  }
}
