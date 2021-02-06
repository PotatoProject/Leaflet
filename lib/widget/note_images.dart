import 'package:flutter/material.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/widget/note_image.dart';

class NoteImages extends StatelessWidget {
  final List<SavedImage> images;
  final ValueChanged<int> onImageTap;
  final ImageLayoutType layoutType;
  final Axis stripAxis;
  final int maxGridRows;

  NoteImages({
    @required this.images,
    this.onImageTap,
    this.layoutType = ImageLayoutType.GRID,
    this.stripAxis = Axis.horizontal,
    this.maxGridRows,
  });

  @override
  Widget build(BuildContext context) {
    switch (layoutType) {
      case ImageLayoutType.STRIP:
        return _ImageStrip(
          images: images,
          onImageTap: onImageTap,
          axis: stripAxis,
        );
      case ImageLayoutType.GRID:
      default:
        return _ImageGrid(
          images: images,
          onImageTap: onImageTap,
          maxGridRows: maxGridRows,
        );
    }
  }
}

class _ImageGrid extends StatelessWidget {
  final List<SavedImage> images;
  final ValueChanged<int> onImageTap;
  final int maxGridRows;

  _ImageGrid({
    @required this.images,
    this.onImageTap,
    this.maxGridRows,
  });

  @override
  Widget build(BuildContext context) {
    final _groupedImages = images.group(3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final _rows = <Widget>[];

        final _forLength = maxGridRows != null
            ? _groupedImages.length.clamp(0, maxGridRows)
            : _groupedImages.length;
        for (int i = 0; i < _forLength; i++) {
          _rows.add(
            buildImageRow(
              _groupedImages[i],
              constraints.maxWidth,
              i,
            ),
          );
        }

        return Column(children: _rows);
      },
    );
  }

  Widget buildImageRow(
      List<SavedImage> images, double baseWidth, int forLoopIndex) {
    assert(images.length > 0 && images.length <= 3);

    final _sizes = images
        .map(
          (image) => Size(image.width, image.height),
        )
        .toList();

    final _height = _getMinHeight(_sizes);
    final _transformedWidths =
        _sizes.map((s) => s.aspectRatio * _height).toList();

    final _widthSum = _sumWidths(_transformedWidths);
    final _newHeight = baseWidth * _height / _widthSum;

    final _newWidths = _sizes.map((s) => s.aspectRatio * _newHeight).toList();
    final _children = <Widget>[];

    for (int i = 0; i < images.length; i++) {
      final _savedImage = images[i];
      final _width = _newWidths[i];

      _children.add(
        SizedBox(
          width: _width,
          height: _newHeight,
          child: InkWell(
            onTap: () => onImageTap?.call(i + 3 * forLoopIndex),
            child: NoteImage(
              savedImage: _savedImage,
            ),
          ),
        ),
      );
    }

    return Row(children: _children);
  }

  double _sumWidths(List<double> sizes) {
    double w = 0;

    sizes.forEach((n) => w += n);

    return w;
  }

  double _getMinHeight(List<Size> sizes) {
    double minHeight;

    for (Size size in sizes) {
      if (minHeight == null) {
        minHeight = size.height;
        continue;
      } else {
        if (size.height < minHeight) minHeight = size.height;
      }
    }

    return minHeight;
  }
}

class _ImageStrip extends StatelessWidget {
  final List<SavedImage> images;
  final Axis axis;
  final ValueChanged<int> onImageTap;

  _ImageStrip({
    @required this.images,
    this.axis = Axis.horizontal,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final _image = images[index];
            Size _imageWidgetSize;

            if (axis == Axis.horizontal) {
              _imageWidgetSize = Size(
                constraints.maxHeight * _image.size.aspectRatio,
                constraints.maxHeight,
              );
            } else {
              _imageWidgetSize = Size(
                constraints.maxWidth,
                constraints.maxWidth / _image.size.aspectRatio,
              );
            }

            return SizedBox.fromSize(
              size: _imageWidgetSize,
              child: InkWell(
                onTap: () => onImageTap?.call(index),
                child: NoteImage(savedImage: _image),
              ),
            );
          },
          itemCount: images.length,
          scrollDirection: axis,
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}

enum ImageLayoutType {
  GRID,
  STRIP,
}

extension ListGrouping<T> on List<T> {
  List<List<T>> group(int size) {
    List<List<T>> groups = [];

    for (var i = 0; i < length; i += size) {
      var end = (i + size < length) ? i + size : length;
      groups.add(sublist(i, end));
    }

    return groups;
  }
}
