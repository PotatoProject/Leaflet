import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';

import '../helper/empty_note.dart';

class MockNoteHelper extends Mock implements NoteHelper {}
ImageQueue imageQueue = ImageQueue();
main() {
  setUpAll(() {
    imageQueue = ImageQueue();
  });
  test('returns true when image is uploaded and other uploaded images exist', () async {
    var fakeImage = new SavedImage.empty()..uploaded = true..hash="test";
    var otherImage = new SavedImage.empty()..uploaded = true..hash="test";
    expect(await hasDuplicatesWith(fakeImage..id="1", otherImage..id="2"), true);
  });
  test('returns true when image is uploaded and other uploaded images exist with different hash', () async {
    var fakeImage = new SavedImage.empty()..uploaded=true..hash="test";
    var otherImage = new SavedImage.empty()..uploaded=true..hash="nottest";
    expect(await hasDuplicatesWith(fakeImage..id="1", otherImage..id="2"), false);
  });
}

Future<bool> hasDuplicatesWith(SavedImage fakeImage, SavedImage otherImage){
  final helper = MockNoteHelper();
  var fakeNote = EmptyNote.get();
  fakeNote = fakeNote.copyWith(images: [otherImage]);
  when(helper.listNotes(ReturnMode.LOCAL)).thenAnswer((_) => Future.value([fakeNote]));
  return imageQueue.hasDuplicates(fakeImage, noteHelper: helper);
}