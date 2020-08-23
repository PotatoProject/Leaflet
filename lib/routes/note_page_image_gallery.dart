import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/image_controller.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/draw_page.dart';

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

          image = CachedNetworkImageProvider(() async {
            try {
              String url = await ImageController.getDownloadUrlFromSync(
                  widget.note.images.data[index].hash);
              return url;
            } catch (e) {
              return "";
            }
          }, cacheKey: widget.note.images.data[index].hash);

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
            widget.note.images.data.length,
          ),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.pencilOutline),
            padding: EdgeInsets.all(0),
            tooltip: LocaleStrings.common.edit,
            onPressed: !DeviceInfo.isDesktopOrWeb
                ? () async {
                    await Utils.showSecondaryRoute(
                      context,
                      DrawPage(
                        note: widget.note,
                        savedImage: widget.note.images.data[currentPage],
                      ),
                      sidePadding: kTertiaryRoutePadding,
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
              widget.note.images.data.removeWhere((savedImage) =>
                  widget.note.images.data[currentPage].id == savedImage.id);

              helper.saveNote(Utils.markNoteChanged(widget.note));

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
