import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

class NoteViewImages extends StatefulWidget {
  final List<SavedImage> images;
  final double borderRadius;
  final bool showPlusImages;
  final int numPlusImages;
  final Function(int) onImageTap;
  final bool useSmallFont;

  NoteViewImages({
    @required this.images,
    this.borderRadius = 0,
    this.showPlusImages = false,
    this.numPlusImages = 0,
    this.onImageTap,
    this.useSmallFont = true,
  });

  @override
  _NoteViewImagesState createState() => _NoteViewImagesState();
}

class _NoteViewImagesState extends State<NoteViewImages> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight != double.infinity
            ? constraints.maxHeight
            : maxWidth;

        return ClipRRect(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(widget.borderRadius)),
          child: SizedBox(
            width: maxWidth,
            height: constraints.maxHeight == double.infinity
                ? widget.images.length > (kMaxImageCount / 2)
                    ? maxWidth
                    : maxWidth / 2
                : maxHeight,
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(0),
              crossAxisCount: 12,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.images.length >= (kMaxImageCount)
                  ? kMaxImageCount
                  : widget.images.length,
              itemBuilder: (context, index) {
                SavedImage savedImage = widget.images[index];
                ImageProvider image;
                if (savedImage.existsLocally) {
                  image = FileImage(File(savedImage.path));
                } else {
                  image = BlurHashImage(savedImage.blurHash);
                }
                return Stack(
                  children: [
                    SizedBox.expand(
                      child: Image(
                          image: image,
                          fit: BoxFit.cover,
                          gaplessPlayback: true),
                    ),
                    SizedBox.expand(
                      child: Visibility(
                        visible: (index == widget.images.length - 1 &&
                                widget.numPlusImages > 0) &&
                            widget.showPlusImages,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0.4),
                          child: Text(
                            "+" + widget.numPlusImages.toString(),
                            style: TextStyle(
                              fontSize: widget.useSmallFont ? 24.0 : 36.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.expand(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () => widget.onImageTap(index),
                        ),
                      ),
                    ),
                  ],
                );
                //ImageProvider image;
                /*String scheme = widget.images[index].uri.scheme;

                if (scheme.startsWith("http")) {
                  image = CachedNetworkImageProvider(
                      widget.images[index].toString());
                } else {*/
                /*if (widget.images[index].uri != null) {

                }*/
                /*if (!ImageService.imageCached(widget.images[index])) {
                  imageService
                      .downloadImage(widget.images[index])
                      .then((path) => {
                            if (path != "") {setState(() => {})}
                          });
                }*/

                /*
                Image(
                  image: image
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                );
                SavedImage savedImage = widget.images[index];
                if(savedImage.existsLocally){

                }
                final Widget image = OctoImage(
                  image: CachedNetworkImageProvider(
                    () async {
                      try {
                        String url =
                            await ImageController.getDownloadUrlFromSync(
                                widget.images[index].hash);
                        return url;
                      } catch (e) {
                        return "";
                      }
                    },
                    cacheKey: widget.images[index].hash,
                  ),
                  placeholderBuilder:
                      OctoPlaceholder.blurHash(widget.images[index].blurHash),
                  fit: BoxFit.cover,
                  gaplessPlayback: false,
                  fadeInDuration: const Duration(milliseconds: 1000),
                  fadeOutDuration: const Duration(milliseconds: 500),
                );*/
              },
              staggeredTileBuilder: (index) {
                int crossAxisExtent = 1;
                int col1Length = widget.images.length > (kMaxImageCount / 2)
                    ? kMaxImageCount ~/ 2
                    : widget.images.length;
                int col2Length = widget.images.length - (kMaxImageCount ~/ 2);

                if ((index + 1) > (kMaxImageCount / 2)) {
                  crossAxisExtent = 12 ~/ col2Length;
                  return StaggeredTile.extent(
                    crossAxisExtent,
                    col2Length == 1 ? maxHeight : maxHeight / 2,
                  );
                } else {
                  crossAxisExtent = 12 ~/ col1Length;
                  return StaggeredTile.extent(
                    crossAxisExtent,
                    col1Length == 1 ||
                            (deviceInfo.isLandscape && col2Length <= 0)
                        ? maxHeight
                        : maxHeight / 2,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
