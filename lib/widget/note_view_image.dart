import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';
import 'package:potato_notes/internal/providers.dart';

class NoteViewImage extends StatefulWidget {
  final SavedImage savedImage;
  final BoxFit fit;

  NoteViewImage({
    @required this.savedImage,
    this.fit = BoxFit.cover,
  });

  @override
  _NoteViewImageState createState() => _NoteViewImageState();
}

class _NoteViewImageState extends State<NoteViewImage> {
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
  void didUpdateWidget(NoteViewImage old) {
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
    ImageProvider image;

    if (widget.savedImage.existsLocally && widget.savedImage.uploaded) {
      image = FileImage(File(widget.savedImage.path));
    } else if (widget.savedImage.hash != null) {
      image = BlurHashImage(widget.savedImage.blurHash);
    } else {
      image = FileImage(File(widget.savedImage.uri.path));
    }

    final displayLoadingIndicator =
        queueItem != null && queueItem.status == QueueItemStatus.ONGOING;

    return Stack(
      children: [
        SizedBox.expand(
          child: Image(
            image: image,
            fit: widget.fit,
            alignment: Alignment.center,
            gaplessPlayback: true,
          ),
        ),
        if (displayLoadingIndicator)
          Card(
            margin: EdgeInsets.all(8),
            elevation: 4,
            shape: CircleBorder(),
            child: SizedBox.fromSize(
              size: Size.square(32),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: queueItem.progress,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
