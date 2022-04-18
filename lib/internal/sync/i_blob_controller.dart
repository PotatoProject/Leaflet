import 'dart:typed_data';

abstract class IBlobController {
  Future sync(Blob blob);

  Future delete(Blob blob);

  Future<List<Blob>> getUpdatedSince(BlobType type, DateTime since);

  Future<List<String>> getDeleted(List<String> onClient);
}

class Blob {
  String id;
  BlobType blobType;
  Uint8List data;
  DateTime lastChanged;

  Blob(this.id, this.blobType, this.data, this.lastChanged);
}

enum BlobType { note, folder }
