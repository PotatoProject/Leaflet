import 'package:drift/drift.dart';
import 'package:grpc/grpc.dart';
import 'package:potato_notes/internal/sync/i_blob_controller.dart' as Interface;
import 'package:potato_notes/internal/sync/service/blob.pbgrpc.dart' as gRPC;
import 'package:potato_notes/internal/sync/service/google/protobuf/timestamp.pb.dart';

class PotatoBlobController implements Interface.IBlobController {
  @override
  Future delete(Interface.Blob blob) async {
    var channel = ClientChannel("http://localhost:5024");
    var client = gRPC.BlobClient(channel);
    await client.delete(gRPC.DeleteRequest(id: blob.id.toString()));
    print("Deleted it yay");
    // TODO: implement delete
  }

  @override
  Future<List<String>> getDeleted(List<String> onClient) {
    // TODO: implement getDeleted
    throw UnimplementedError();
  }

  @override
  Future<List<Interface.Blob>> getUpdatedSince(
      Interface.BlobType type, DateTime since) async {
    var channel = ClientChannel("http://localhost:5024");
    var client = gRPC.BlobClient(channel);

    final gRPC.GetUpdatedResponse response = await client.getUpdated(
      gRPC.GetUpdatedRequest(
        blobType: type.name,
        lastUpdated: Timestamp.fromDateTime(since),
      ),
    );
    final blobs = response.items;
    final List<Interface.Blob> converted = blobs
        .map(
          (b) => Interface.Blob(
            b.id,
            type,
            Uint8List.fromList(b.content),
            b.lastChanged.toDateTime(),
          ),
        )
        .toList();
    return converted;
  }

  @override
  Future sync(Interface.Blob blob) async {
    final ClientChannel channel = ClientChannel("http://localhost:5024");
    final gRPC.BlobClient client = gRPC.BlobClient(channel);
    await client.sync(
      gRPC.Data(
        id: blob.id,
        blobType: blob.blobType.name,
        content: blob.data.toList(growable: false),
        lastChanged: Timestamp.fromDateTime(blob.lastChanged),
      ),
    );
  }
}
