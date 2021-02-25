// @dart=2.12

import 'package:flutter/material.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';

abstract class QueueItem extends ChangeNotifier {
  final String localPath;
  final SavedImage savedImage;

  QueueItem({
    required this.localPath,
    required this.savedImage,
  });

  QueueItemStatus _status = QueueItemStatus.PENDING;
  QueueItemStatus get status => _status;
  set status(QueueItemStatus value) {
    _status = value;
    notifyListeners();
    imageQueue.notifyListeners();
  }

  double? _progress;
  double? get progress => _progress;
  set progress(double? value) {
    _progress = value;
    notifyListeners();
    imageQueue.notifyListeners();
  }
}

enum QueueItemStatus {
  PENDING,
  ONGOING,
  COMPLETE,
}
