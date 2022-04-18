///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $1;

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Empty',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  Empty._() : super();

  factory Empty() => create();

  factory Empty.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory Empty.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) =>
      super.copyWith((message) => updates(message as Empty))
          as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();

  Empty createEmptyInstance() => create();

  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();

  @$core.pragma('dart2js:noInline')
  static Empty getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class Data extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Data',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blobType')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content',
        $pb.PbFieldType.OY)
    ..aOM<$1.Timestamp>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lastChanged',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  Data._() : super();

  factory Data({
    $core.String? id,
    $core.String? blobType,
    $core.List<$core.int>? content,
    $1.Timestamp? lastChanged,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (blobType != null) {
      _result.blobType = blobType;
    }
    if (content != null) {
      _result.content = content;
    }
    if (lastChanged != null) {
      _result.lastChanged = lastChanged;
    }
    return _result;
  }

  factory Data.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory Data.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Data clone() => Data()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Data copyWith(void Function(Data) updates) =>
      super.copyWith((message) => updates(message as Data))
          as Data; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Data create() => Data._();

  Data createEmptyInstance() => create();

  static $pb.PbList<Data> createRepeated() => $pb.PbList<Data>();

  @$core.pragma('dart2js:noInline')
  static Data getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Data>(create);
  static Data? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);

  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);

  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get blobType => $_getSZ(1);

  @$pb.TagNumber(2)
  set blobType($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBlobType() => $_has(1);

  @$pb.TagNumber(2)
  void clearBlobType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get content => $_getN(2);

  @$pb.TagNumber(3)
  set content($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);

  @$pb.TagNumber(3)
  void clearContent() => clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get lastChanged => $_getN(3);

  @$pb.TagNumber(4)
  set lastChanged($1.Timestamp v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasLastChanged() => $_has(3);

  @$pb.TagNumber(4)
  void clearLastChanged() => clearField(4);

  @$pb.TagNumber(4)
  $1.Timestamp ensureLastChanged() => $_ensure(3);
}

class DeleteRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DeleteRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..hasRequiredFields = false;

  DeleteRequest._() : super();

  factory DeleteRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }

  factory DeleteRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory DeleteRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DeleteRequest clone() => DeleteRequest()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DeleteRequest copyWith(void Function(DeleteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRequest))
          as DeleteRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRequest create() => DeleteRequest._();

  DeleteRequest createEmptyInstance() => create();

  static $pb.PbList<DeleteRequest> createRepeated() =>
      $pb.PbList<DeleteRequest>();

  @$core.pragma('dart2js:noInline')
  static DeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRequest>(create);
  static DeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);

  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);

  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class GetDeletedRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetDeletedRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blobType')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'list')
    ..hasRequiredFields = false;

  GetDeletedRequest._() : super();

  factory GetDeletedRequest({
    $core.String? blobType,
    $core.Iterable<$core.String>? list,
  }) {
    final _result = create();
    if (blobType != null) {
      _result.blobType = blobType;
    }
    if (list != null) {
      _result.list.addAll(list);
    }
    return _result;
  }

  factory GetDeletedRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory GetDeletedRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetDeletedRequest clone() => GetDeletedRequest()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetDeletedRequest copyWith(void Function(GetDeletedRequest) updates) =>
      super.copyWith((message) => updates(message as GetDeletedRequest))
          as GetDeletedRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeletedRequest create() => GetDeletedRequest._();

  GetDeletedRequest createEmptyInstance() => create();

  static $pb.PbList<GetDeletedRequest> createRepeated() =>
      $pb.PbList<GetDeletedRequest>();

  @$core.pragma('dart2js:noInline')
  static GetDeletedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDeletedRequest>(create);
  static GetDeletedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get blobType => $_getSZ(0);

  @$pb.TagNumber(1)
  set blobType($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlobType() => $_has(0);

  @$pb.TagNumber(1)
  void clearBlobType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get list => $_getList(1);
}

class GetDeletedResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetDeletedResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'list')
    ..hasRequiredFields = false;

  GetDeletedResponse._() : super();

  factory GetDeletedResponse({
    $core.Iterable<$core.String>? list,
  }) {
    final _result = create();
    if (list != null) {
      _result.list.addAll(list);
    }
    return _result;
  }

  factory GetDeletedResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory GetDeletedResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetDeletedResponse clone() => GetDeletedResponse()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetDeletedResponse copyWith(void Function(GetDeletedResponse) updates) =>
      super.copyWith((message) => updates(message as GetDeletedResponse))
          as GetDeletedResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeletedResponse create() => GetDeletedResponse._();

  GetDeletedResponse createEmptyInstance() => create();

  static $pb.PbList<GetDeletedResponse> createRepeated() =>
      $pb.PbList<GetDeletedResponse>();

  @$core.pragma('dart2js:noInline')
  static GetDeletedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDeletedResponse>(create);
  static GetDeletedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get list => $_getList(0);
}

class GetUpdatedRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetUpdatedRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blobType')
    ..aOM<$1.Timestamp>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lastUpdated',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  GetUpdatedRequest._() : super();

  factory GetUpdatedRequest({
    $core.String? blobType,
    $1.Timestamp? lastUpdated,
  }) {
    final _result = create();
    if (blobType != null) {
      _result.blobType = blobType;
    }
    if (lastUpdated != null) {
      _result.lastUpdated = lastUpdated;
    }
    return _result;
  }

  factory GetUpdatedRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory GetUpdatedRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetUpdatedRequest clone() => GetUpdatedRequest()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetUpdatedRequest copyWith(void Function(GetUpdatedRequest) updates) =>
      super.copyWith((message) => updates(message as GetUpdatedRequest))
          as GetUpdatedRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUpdatedRequest create() => GetUpdatedRequest._();

  GetUpdatedRequest createEmptyInstance() => create();

  static $pb.PbList<GetUpdatedRequest> createRepeated() =>
      $pb.PbList<GetUpdatedRequest>();

  @$core.pragma('dart2js:noInline')
  static GetUpdatedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUpdatedRequest>(create);
  static GetUpdatedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get blobType => $_getSZ(0);

  @$pb.TagNumber(1)
  set blobType($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlobType() => $_has(0);

  @$pb.TagNumber(1)
  void clearBlobType() => clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get lastUpdated => $_getN(1);

  @$pb.TagNumber(2)
  set lastUpdated($1.Timestamp v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLastUpdated() => $_has(1);

  @$pb.TagNumber(2)
  void clearLastUpdated() => clearField(2);

  @$pb.TagNumber(2)
  $1.Timestamp ensureLastUpdated() => $_ensure(1);
}

class GetUpdatedResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetUpdatedResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'blob'),
      createEmptyInstance: create)
    ..pc<Data>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'items',
        $pb.PbFieldType.PM,
        subBuilder: Data.create)
    ..hasRequiredFields = false;

  GetUpdatedResponse._() : super();

  factory GetUpdatedResponse({
    $core.Iterable<Data>? items,
  }) {
    final _result = create();
    if (items != null) {
      _result.items.addAll(items);
    }
    return _result;
  }

  factory GetUpdatedResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory GetUpdatedResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetUpdatedResponse clone() => GetUpdatedResponse()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetUpdatedResponse copyWith(void Function(GetUpdatedResponse) updates) =>
      super.copyWith((message) => updates(message as GetUpdatedResponse))
          as GetUpdatedResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUpdatedResponse create() => GetUpdatedResponse._();

  GetUpdatedResponse createEmptyInstance() => create();

  static $pb.PbList<GetUpdatedResponse> createRepeated() =>
      $pb.PbList<GetUpdatedResponse>();

  @$core.pragma('dart2js:noInline')
  static GetUpdatedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUpdatedResponse>(create);
  static GetUpdatedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Data> get items => $_getList(0);
}
