///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor =
    $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use dataDescriptor instead')
const Data$json = const {
  '1': 'Data',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'blob_type', '3': 2, '4': 1, '5': 9, '10': 'blobType'},
    const {'1': 'content', '3': 3, '4': 1, '5': 12, '10': 'content'},
    const {
      '1': 'last_changed',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastChanged'
    },
  ],
};

/// Descriptor for `Data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataDescriptor = $convert.base64Decode(
    'CgREYXRhEg4KAmlkGAEgASgJUgJpZBIbCglibG9iX3R5cGUYAiABKAlSCGJsb2JUeXBlEhgKB2NvbnRlbnQYAyABKAxSB2NvbnRlbnQSPQoMbGFzdF9jaGFuZ2VkGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILbGFzdENoYW5nZWQ=');
@$core.Deprecated('Use deleteRequestDescriptor instead')
const DeleteRequest$json = const {
  '1': 'DeleteRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRequestDescriptor =
    $convert.base64Decode('Cg1EZWxldGVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
@$core.Deprecated('Use getDeletedRequestDescriptor instead')
const GetDeletedRequest$json = const {
  '1': 'GetDeletedRequest',
  '2': const [
    const {'1': 'blob_type', '3': 1, '4': 1, '5': 9, '10': 'blobType'},
    const {'1': 'list', '3': 2, '4': 3, '5': 9, '10': 'list'},
  ],
};

/// Descriptor for `GetDeletedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeletedRequestDescriptor = $convert.base64Decode(
    'ChFHZXREZWxldGVkUmVxdWVzdBIbCglibG9iX3R5cGUYASABKAlSCGJsb2JUeXBlEhIKBGxpc3QYAiADKAlSBGxpc3Q=');
@$core.Deprecated('Use getDeletedResponseDescriptor instead')
const GetDeletedResponse$json = const {
  '1': 'GetDeletedResponse',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 9, '10': 'list'},
  ],
};

/// Descriptor for `GetDeletedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeletedResponseDescriptor = $convert
    .base64Decode('ChJHZXREZWxldGVkUmVzcG9uc2USEgoEbGlzdBgBIAMoCVIEbGlzdA==');
@$core.Deprecated('Use getUpdatedRequestDescriptor instead')
const GetUpdatedRequest$json = const {
  '1': 'GetUpdatedRequest',
  '2': const [
    const {'1': 'blob_type', '3': 1, '4': 1, '5': 9, '10': 'blobType'},
    const {
      '1': 'last_updated',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUpdated'
    },
  ],
};

/// Descriptor for `GetUpdatedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUpdatedRequestDescriptor = $convert.base64Decode(
    'ChFHZXRVcGRhdGVkUmVxdWVzdBIbCglibG9iX3R5cGUYASABKAlSCGJsb2JUeXBlEj0KDGxhc3RfdXBkYXRlZBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2xhc3RVcGRhdGVk');
@$core.Deprecated('Use getUpdatedResponseDescriptor instead')
const GetUpdatedResponse$json = const {
  '1': 'GetUpdatedResponse',
  '2': const [
    const {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.blob.Data',
      '10': 'items'
    },
  ],
};

/// Descriptor for `GetUpdatedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUpdatedResponseDescriptor = $convert.base64Decode(
    'ChJHZXRVcGRhdGVkUmVzcG9uc2USIAoFaXRlbXMYASADKAsyCi5ibG9iLkRhdGFSBWl0ZW1z');
