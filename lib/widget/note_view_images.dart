import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:potato_notes/internal/utils.dart';

class NoteViewImages extends StatefulWidget {
  final List<Uri> images;
  final double borderRadius;
  final bool showPlusImages;
  final int numPlusImages;
  final Function(int) onImageTap;

  NoteViewImages({
    @required this.images,
    this.borderRadius = 0,
    this.showPlusImages = false,
    this.numPlusImages = 0,
    this.onImageTap,
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
                ? widget.images.length > (Utils.kMaxImageCount / 2)
                    ? maxWidth
                    : maxWidth / 2
                : maxHeight,
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(0),
              crossAxisCount: 12,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.images.length >= (Utils.kMaxImageCount)
                  ? Utils.kMaxImageCount
                  : widget.images.length,
              itemBuilder: (context, index) {
                ImageProvider image;
                String scheme = widget.images[index].scheme;

                if (scheme.startsWith("http")) {
                  image = CachedNetworkImageProvider(
                      widget.images[index].toString());
                } else {
                  image = FileImage(File(widget.images[index].path));
                }

                return InkWell(
                  onTap: () => widget.onImageTap(index),
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: Image(
                          image: image,
                          fit: BoxFit.cover,
                          gaplessPlayback: false,
                        ),
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
                                fontSize: 36.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              staggeredTileBuilder: (index) {
                int crossAxisExtent = 1;
                int col1Length =
                    widget.images.length > (Utils.kMaxImageCount / 2)
                        ? Utils.kMaxImageCount ~/ 2
                        : widget.images.length;
                int col2Length =
                    widget.images.length - (Utils.kMaxImageCount ~/ 2);

                if ((index + 1) > (Utils.kMaxImageCount / 2)) {
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
                            (MediaQuery.of(context).orientation ==
                                    Orientation.landscape &&
                                col2Length <= 0)
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
