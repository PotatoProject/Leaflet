import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';
import 'package:potato_notes/internal/providers.dart';

class NoteImage extends StatefulWidget {
  final SavedImage savedImage;
  final BoxFit fit;

  NoteImage({
    @required this.savedImage,
    this.fit = BoxFit.cover,
  });

  @override
  _NoteImageState createState() => _NoteImageState();

  static ImageProvider getProvider(SavedImage savedImage) {
    ImageProvider image;

    if (savedImage.existsLocally && savedImage.uploaded) {
      image = FileImage(File(savedImage.path));
    } else if (savedImage.hash != null) {
      image = BlurHashImage(savedImage.blurHash);
    } else {
      image = FileImage(File(savedImage.path));
    }

    return image;
  }
}

class _NoteImageState extends State<NoteImage> {
  QueueItem queueItem;

  @override
  void initState() {
    super.initState();
    _getQueueItem();
    imageQueue.addListener(_getQueueItem);
  }

  void _getQueueItem() {
    queueItem?.removeListener(refresh);
    queueItem = imageQueue.queue.firstWhere(
      (e) => e.savedImage.id == widget.savedImage.id,
      orElse: () => null,
    );
    queueItem?.addListener(refresh);
  }

  @override
  void didUpdateWidget(NoteImage old) {
    super.didUpdateWidget(old);
    if (widget.savedImage.id != old.savedImage.id) {
      _getQueueItem();
    }
  }

  @override
  void dispose() {
    super.dispose();
    imageQueue.removeListener(_getQueueItem);
    queueItem?.removeListener(refresh);
  }

  // dummy method so we can dispose of the listener
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final displayLoadingIndicator =
        queueItem != null && queueItem.status == QueueItemStatus.ONGOING;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NoteImage.getProvider(widget.savedImage),
          fit: widget.fit,
          alignment: Alignment.center,
        ),
      ),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.topLeft,
          child: Visibility(
            visible: displayLoadingIndicator,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox.fromSize(
                size: Size.square(32),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  shape: CircleBorder(),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: queueItem?.progress,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
