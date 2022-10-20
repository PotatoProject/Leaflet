import 'package:potato_notes/internal/sync/blob.dart';
import 'package:potato_notes/internal/sync/blob_service.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:test/test.dart';

void main() {
  test('Get list of all blobs', () async {
    final blobs = await SyncBlobService().getAllBlobs();
    assert(blobs.isNotEmpty);
  });

  test('upsert blob', () async {
    final blob = Blob("b4e1c4aa-ecd9-4ff3-89a1-a957d0566e10",
        "{\"test\": \"test\"}", DateTime.now());
    await SyncBlobService().upsertBlob(blob);
  });
}
