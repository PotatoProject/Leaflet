// @dart=2.12

import 'package:flutter/material.dart';
import 'package:potato_notes/data/model/saved_image.dart';

abstract class QueueItem extends ChangeNotifier {
  final String localPath;
  final SavedImage savedImage;

  QueueItem({
    required this.localPath,
    required this.savedImage,
  });

  QueueItemStatus status = QueueItemStatus.PENDING;

  double? progress;
}

enum QueueItemStatus {
  PENDING,
  ONGOING,
  COMPLETE,
}
