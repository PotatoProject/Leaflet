import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/draw_page.dart';
import 'package:potato_notes/widget/dismissible_route.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PhotoViewGallery.builder(
        itemCount: widget.note.images.data.length,
        backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        builder: (context, index) {
          ImageProvider image;
          String scheme = widget.note.images.uris[index].scheme;

          if (scheme.startsWith("http")) {
            image = CachedNetworkImageProvider(
                widget.note.images.uris[index].toString());
          } else {
            image = FileImage(File(widget.note.images.uris[index].path));
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (currentPage + 1).toString() +
              " of " +
              widget.note.images.data.length.toString(),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(CommunityMaterialIcons.pencil_outline),
            padding: EdgeInsets.all(0),
            onPressed: !kIsWeb
                ? () {
                    Navigator.pop(context);

                    Utils.showSecondaryRoute(
                      context,
                      DrawPage(
                        note: widget.note,
                        data: MapEntry(
                          widget.note.images.uris[currentPage].path,
                          widget.note.images.uris[currentPage],
                        ),
                      ),
                      sidePadding: kTertiaryRoutePadding,
                      allowGestures: false,
                    );
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            padding: EdgeInsets.all(0),
            onPressed: () {
              widget.note.images.data
                  .remove(widget.note.images.uris[currentPage].path);

              helper.saveNote(widget.note);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
