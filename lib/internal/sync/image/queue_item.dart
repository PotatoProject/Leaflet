import 'package:flutter/material.dart';
import 'package:potato_notes/data/model/saved_image.dart';

abstract class QueueItem {
  final String localPath;
  final SavedImage savedImage;

  QueueItem({
    required this.localPath,
    required this.savedImage,
  });

  ValueNotifier<QueueItemStatus> status =
      ValueNotifier<QueueItemStatus>(QueueItemStatus.pending);

  ValueNotifier<double?> progress = ValueNotifier<double?>(null);
}

enum QueueItemStatus {
  pending,
  ongoing,
  complete,
}
