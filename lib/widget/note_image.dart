import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image/queue_item.dart';

class NoteImage extends StatefulWidget {
  final SavedImage savedImage;
  final BoxFit fit;

  const NoteImage({
    required this.savedImage,
    this.fit = BoxFit.cover,
  });

  @override
  _NoteImageState createState() => _NoteImageState();

  static ImageProvider getProvider(SavedImage savedImage) {
    ImageProvider image;

    if (savedImage.existsLocally && savedImage.uploaded) {
      image = FileImage(File(savedImage.path));
    } else if (savedImage.hash != null) {
      image = BlurHashImage(savedImage.blurHash!);
    } else {
      image = FileImage(File(savedImage.path));
    }

    return image;
  }
}

class _NoteImageState extends State<NoteImage> {
  QueueItem? queueItem;

  @override
  void initState() {
    super.initState();
    _getQueueItem();
    imageQueue.addListener(_getQueueItem);
  }

  void _getQueueItem() {
    queueItem = imageQueue.queue.firstWhereOrNull(
      (e) => e.savedImage.id == widget.savedImage.id,
    );
    if (queueItem != null) setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QueueItemStatus>(
      valueListenable:
          queueItem?.status ?? ValueNotifier(QueueItemStatus.complete),
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NoteImage.getProvider(widget.savedImage),
              fit: widget.fit,
            ),
          ),
          child: SizedBox.expand(
            child: Align(
              alignment: Alignment.topLeft,
              child: Visibility(
                visible: value == QueueItemStatus.ongoing,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox.fromSize(
                    size: const Size.square(32),
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 4,
                      shape: const CircleBorder(),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ValueListenableBuilder<double?>(
                            valueListenable: queueItem?.progress ??
                                ValueNotifier<double?>(null),
                            builder: (context, value, _) {
                              return CircularProgressIndicator(
                                strokeWidth: 2,
                                value: value,
                              );
                            },
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
      },
    );
  }
}
