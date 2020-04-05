import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:potato_notes/widget/drawing_board.dart';

class NoteViewImages extends StatefulWidget {
  final List<Uri> images;
  final int numOfImages;
  final double borderRadius;
  final bool showPlusImages;
  final int numPlusImages;
  final Function(int) onImageTap;

  NoteViewImages({
    @required this.images,
    this.numOfImages = 3,
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

        return ClipRRect(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(widget.borderRadius)),
          child: SizedBox(
            width: maxWidth,
            height: widget.images.length > widget.numOfImages
                ? maxWidth
                : maxWidth / 2,
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(0),
              crossAxisCount: 12,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.images.length >= (widget.numOfImages * 2)
                  ? widget.numOfImages * 2
                  : widget.images.length,
              itemBuilder: (context, index) {
                ImageProvider image;
                String scheme = widget.images[index].scheme;

                if (scheme.startsWith("http")) {
                  image = NetworkImage(widget.images[index].toString());
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

                if ((index + 1) > widget.numOfImages) {
                  int col2Length = widget.images.length - widget.numOfImages;
                  crossAxisExtent = 12 ~/ col2Length;
                  return StaggeredTile.extent(crossAxisExtent, maxWidth / 2);
                } else {
                  int col1Length = widget.images.length > widget.numOfImages
                      ? widget.numOfImages
                      : widget.images.length;

                  crossAxisExtent = 12 ~/ col1Length;
                  return StaggeredTile.extent(crossAxisExtent, maxWidth / 2);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
