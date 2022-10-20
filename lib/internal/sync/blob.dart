class Blob {
  final String id;
  final String content;
  final String blobType;
  final DateTime lastChanged;

  Blob(this.id, this.content, this.blobType, this.lastChanged);

  Blob.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        content = json['content'] as String,
        blobType = json['blob_type'] as String,
        lastChanged =
            DateTime.fromMillisecondsSinceEpoch(json['last_changed'] as int);

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'blob_type': blobType,
        'last_changed': lastChanged.millisecondsSinceEpoch
      };
}
