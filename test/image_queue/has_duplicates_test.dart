import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:liblymph/database.dart';
import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';

import '../helper/empty_note.dart';

class MockNoteHelper extends Mock implements NoteHelper {}

ImageQueue imageQueue = ImageQueue();
void main() {
  setUpAll(() {
    imageQueue = ImageQueue();
  });
  test('returns true when image is uploaded and other uploaded images exist',
      () async {
    final SavedImage fakeImage = SavedImage.empty()
      ..uploaded = true
      ..hash = "test";
    final SavedImage otherImage = SavedImage.empty()
      ..uploaded = true
      ..hash = "test";
    expect(
      await hasDuplicatesWith(fakeImage..id = "1", otherImage..id = "2"),
      true,
    );
  });
  test(
      'returns true when image is uploaded and other uploaded images exist with different hash',
      () async {
    final SavedImage fakeImage = SavedImage.empty()
      ..uploaded = true
      ..hash = "test";
    final SavedImage otherImage = SavedImage.empty()
      ..uploaded = true
      ..hash = "nottest";
    expect(
      await hasDuplicatesWith(fakeImage..id = "1", otherImage..id = "2"),
      false,
    );
  });
}

Future<bool> hasDuplicatesWith(SavedImage fakeImage, SavedImage otherImage) {
  final MockNoteHelper helper = MockNoteHelper();
  var fakeNote = EmptyNote.get();
  fakeNote = fakeNote.copyWith(images: [otherImage]);
  when(helper.listNotes(ReturnMode.local))
      .thenAnswer((_) => Future.value([fakeNote]));
  return imageQueue.hasDuplicates(fakeImage, noteHelper: helper);
}
