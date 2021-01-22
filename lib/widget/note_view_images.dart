import 'package:flutter/material.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/widget/note_view_image.dart';

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
    this.showPlusImages = true,
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
    return _ImageGrid(
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final showPlus =
            index == 3 && widget.numPlusImages > 0 && widget.showPlusImages;

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NoteViewImage.getProvider(widget.images[index]),
              fit: BoxFit.cover,
            ),
          ),
          child: Material(
            color:
                showPlus ? Colors.black.withOpacity(0.4) : Colors.transparent,
            child: InkWell(
              onTap: () => widget.onImageTap(index),
              child: SizedBox.expand(
                child: Align(
                  alignment: Alignment.center,
                  child: showPlus
                      ? Text(
                          "+" + widget.numPlusImages.toString(),
                          style: TextStyle(
                            fontSize: widget.useSmallFont ? 24.0 : 36.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// An image grid that supports max 4 images
class _ImageGrid extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  _ImageGrid({
    @required this.itemBuilder,
    @required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
            minHeight: constraints.maxWidth / 2,
            maxHeight: constraints.maxWidth,
          ),
          child: _gridBuilder(context, constraints),
        );
      },
    );
  }

  Widget _gridBuilder(BuildContext context, BoxConstraints constraints) {
    final imageWidgets = [];
    Widget firstRow;
    Widget secondRow;

    for (int i = 0; i < 4; i++) {
      try {
        imageWidgets.add(itemBuilder(context, i));
      } catch (e) {
        imageWidgets.add(null);
      }
    }

    if (imageWidgets[0] != null) {
      firstRow = SizedBox(
        height: constraints.maxWidth / 2,
        child: Row(
          children: [
            Expanded(
              child: imageWidgets[0],
            ),
            if (imageWidgets[1] != null)
              Expanded(
                child: imageWidgets[1],
              ),
          ],
        ),
      );

      if (imageWidgets[2] != null) {
        secondRow = SizedBox(
          height: constraints.maxWidth / 2,
          child: Row(
            children: [
              Expanded(
                child: imageWidgets[2],
              ),
              if (imageWidgets[3] != null)
                Expanded(
                  child: imageWidgets[3],
                ),
            ],
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (firstRow != null) firstRow,
        if (secondRow != null) secondRow,
      ],
    );
  }
}
