import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:provider/provider.dart';
import 'package:potato_notes/routes/draw_page.dart';
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
    final appInfo = Provider.of<AppInfoProvider>(context);

    appInfo.barManager.lightNavBarColor = Colors.black;
    appInfo.barManager.darkNavBarColor = Colors.black;
    appInfo.barManager.lightIconColor = Brightness.light;
    appInfo.barManager.darkIconColor = Brightness.light;

    appInfo.barManager.updateColors();

    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        itemCount: widget.note.images.data.length,
        builder: (context, index) {
          ImageProvider image;
          String scheme = widget.note.images.uris[index].scheme;

          if (scheme.startsWith("http")) {
            image = NetworkImage(widget.note.images.data[index].toString());
          } else {
            image = FileImage(File(widget.note.images.uris[index].path));
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
        bgColor: Colors.black,
        elevation: 0,
        leftItems: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.pop(context),
            color: Colors.white.withOpacity(0.7),
          ),
          Text(
            (currentPage + 1).toString() +
                " of " +
                widget.note.images.data.length.toString(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
        rightItems: [
          /*IconButton(
            icon: Icon(CommunityMaterialIcons.pencil_outline),
            padding: EdgeInsets.all(0),
            onPressed: widget.note.images.data[currentPage].drawing
                ? () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrawPage(
                            note: widget.note,
                            data: widget.note.images.data[currentPage],
                          ),
                        ));
                  }
                : null,
          ),*/
          IconButton(
            icon: Icon(Icons.delete_outline),
            padding: EdgeInsets.all(0),
            onPressed: () {
              setState(() => widget.note.images.data.removeAt(currentPage));
              Navigator.pop(context);
            },
            color: Colors.white.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
