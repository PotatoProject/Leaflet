import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:potato_notes/data/database.dart';
import 'package:spicy_components/spicy_components.dart';

class NotePageImageGallery extends StatefulWidget {
  final Note note;
  final int currentImage;

  NotePageImageGallery({
    @required this.note,
    @required this.currentImage,
  });

  @override
  _NotePageImageGalleryState createState() => _NotePageImageGalleryState();
}

class _NotePageImageGalleryState extends State<NotePageImageGallery> {
  PageController pageController;
  int currentPage;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.currentImage);
    currentPage = widget.currentImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: widget.note.images.images.length,
        builder: (context, index) {
          ImageProvider image;
          String scheme = widget.note.images.images[index].scheme;

          if (scheme.startsWith("http")) {
            image = NetworkImage(widget.note.images.images[index].toString());
          } else {
            image = FileImage(File(widget.note.images.images[index].path));
          }

          return PhotoViewGalleryPageOptions(
            imageProvider: image,
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: 2.0,
          );
        },
        pageController: PageController(initialPage: widget.currentImage),
        onPageChanged: (index) => setState(() => currentPage = index),
      ),
      bottomNavigationBar: SpicyBottomBar(
        leftItems: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            (currentPage + 1).toString() +
                " of " +
                widget.note.images.images.length.toString(),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
        rightItems: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            padding: EdgeInsets.all(0),
            onPressed: () {
              setState(() => widget.note.images.images.removeAt(currentPage));
              if (widget.note.images.images.length == 0) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
