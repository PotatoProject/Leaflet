import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';


class QueueItem extends ChangeNotifier {
  final String localPath;
  final SavedImage savedImage;

  QueueItem({
    required this.localPath,
    required this.savedImage,
  });

  QueueItemStatus _status = QueueItemStatus.PENDING;
  QueueItemStatus get status => _status;
  set status(QueueItemStatus value){
    _status = value;
    imageQueue.notifyListeners();
  }
}

enum QueueItemStatus {
  PENDING,
  ONGOING,
  COMPLETE,
}