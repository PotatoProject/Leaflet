import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/image/image_service.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/draw_page.dart';

class NotePageImageGallery extends StatefulWidget {
  final Note note;
  final int currentImage;

  NotePageImageGallery({
    required this.note,
    required this.currentImage,
  });

  @override
  _NotePageImageGalleryState createState() => _NotePageImageGalleryState();
}

class _NotePageImageGalleryState extends State<NotePageImageGallery> {
  late PageController pageController;
  late int currentPage;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.currentImage);
    currentPage = widget.currentImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PhotoViewGallery.builder(
        itemCount: widget.note.images.length,
        backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        builder: (context, index) {
          SavedImage savedImage = widget.note.images[index];
          ImageProvider image;
          if (savedImage.existsLocally) {
            image = FileImage(File(savedImage.path));
          } else {
            image = BlurHashImage(savedImage.blurHash);
          }
          return PhotoViewGalleryPageOptions(
            imageProvider: image,
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: 3.0,
          );
        },
        pageController: PageController(initialPage: widget.currentImage),
        onPageChanged: (index) => setState(() => currentPage = index),
      ),
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        title: Text(
          LocaleStrings.common.xOfY(
            (currentPage + 1),
            widget.note.images.length,
          ),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            padding: EdgeInsets.all(0),
            tooltip: LocaleStrings.common.edit,
            onPressed: !kIsWeb
                ? () async {
                    await Utils.showSecondaryRoute(
                      context,
                      DrawPage(
                        note: widget.note,
                        savedImage: widget.note.images[currentPage],
                      ),
                      allowGestures: false,
                    );

                    setState(() {});
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            padding: EdgeInsets.all(0),
            tooltip: LocaleStrings.common.delete,
            onPressed: () {
              ImageService.deleteImage(widget.note.images[currentPage]);
              widget.note.images.removeWhere((savedImage) =>
                  widget.note.images[currentPage].id == savedImage.id);
              helper.saveNote(widget.note.markChanged());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
