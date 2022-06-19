import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:liblymph/database.dart' as db;
import 'package:potato_notes/internal/extensions.dart';

class NoteImage extends StatefulWidget {
  final db.NoteImage savedImage;
  final BoxFit fit;

  const NoteImage({
    required this.savedImage,
    this.fit = BoxFit.cover,
  });

  @override
  _NoteImageState createState() => _NoteImageState();

  static ImageProvider getProvider(db.NoteImage noteImage) {
    ImageProvider image;

    if (noteImage.existsLocally && noteImage.uploaded) {
      image = FileImage(File(noteImage.path));
    } else if (noteImage.blurHash != null) {
      image = BlurHashImage(noteImage.blurHash!);
    } else {
      image = FileImage(File(noteImage.path));
    }

    return image;
  }
}

class _NoteImageState extends State<NoteImage> {
  @override
  Widget build(BuildContext context) {
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
            visible: false,
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
                        valueListenable: ValueNotifier<double?>(null),
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
  }
}
