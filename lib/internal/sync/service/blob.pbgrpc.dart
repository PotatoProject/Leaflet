///
import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;

import 'blob.pb.dart' as $0;

export 'blob.pb.dart';

class BlobClient extends $grpc.Client {
  static final _$sync = $grpc.ClientMethod<$0.Data, $0.Empty>(
      '/blob.Blob/Sync',
      ($0.Data value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$delete = $grpc.ClientMethod<$0.DeleteRequest, $0.Empty>(
      '/blob.Blob/Delete',
      ($0.DeleteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$deleteAll = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/blob.Blob/DeleteAll',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getDeleted =
      $grpc.ClientMethod<$0.GetDeletedRequest, $0.GetDeletedResponse>(
          '/blob.Blob/GetDeleted',
          ($0.GetDeletedRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetDeletedResponse.fromBuffer(value));
  static final _$getUpdated =
      $grpc.ClientMethod<$0.GetUpdatedRequest, $0.GetUpdatedResponse>(
          '/blob.Blob/GetUpdated',
          ($0.GetUpdatedRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetUpdatedResponse.fromBuffer(value));

  BlobClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> sync($0.Data request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sync, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> delete($0.DeleteRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteAll($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteAll, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDeletedResponse> getDeleted(
      $0.GetDeletedRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDeleted, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUpdatedResponse> getUpdated(
      $0.GetUpdatedRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUpdated, request, options: options);
  }
}

abstract class BlobServiceBase extends $grpc.Service {
  $core.String get $name => 'blob.Blob';

  BlobServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Data, $0.Empty>(
        'Sync',
        sync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Data.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRequest, $0.Empty>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'DeleteAll',
        deleteAll_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDeletedRequest, $0.GetDeletedResponse>(
        'GetDeleted',
        getDeleted_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetDeletedRequest.fromBuffer(value),
        ($0.GetDeletedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUpdatedRequest, $0.GetUpdatedResponse>(
        'GetUpdated',
        getUpdated_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUpdatedRequest.fromBuffer(value),
        ($0.GetUpdatedResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> sync_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Data> request) async {
    return sync(call, await request);
  }

  $async.Future<$0.Empty> delete_Pre(
      $grpc.ServiceCall call, $async.Future<$0.DeleteRequest> request) async {
    return delete(call, await request);
  }

  $async.Future<$0.Empty> deleteAll_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return deleteAll(call, await request);
  }

  $async.Future<$0.GetDeletedResponse> getDeleted_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetDeletedRequest> request) async {
    return getDeleted(call, await request);
  }

  $async.Future<$0.GetUpdatedResponse> getUpdated_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetUpdatedRequest> request) async {
    return getUpdated(call, await request);
  }

  $async.Future<$0.Empty> sync($grpc.ServiceCall call, $0.Data request);

  $async.Future<$0.Empty> delete(
      $grpc.ServiceCall call, $0.DeleteRequest request);

  $async.Future<$0.Empty> deleteAll($grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.GetDeletedResponse> getDeleted(
      $grpc.ServiceCall call, $0.GetDeletedRequest request);

  $async.Future<$0.GetUpdatedResponse> getUpdated(
      $grpc.ServiceCall call, $0.GetUpdatedRequest request);
}
