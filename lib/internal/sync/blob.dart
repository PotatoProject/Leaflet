class Blob {
  final String id;
  final String content;
  final DateTime lastChanged;

  Blob(this.id, this.content, this.lastChanged);

  Blob.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        content = json['content'] as String,
        lastChanged =
            DateTime.fromMillisecondsSinceEpoch(json['last_changed'] as int);

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'last_changed': lastChanged.millisecondsSinceEpoch
      };
}
