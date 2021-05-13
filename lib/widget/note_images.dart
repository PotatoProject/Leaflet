import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/widget/note_image.dart';
import 'package:potato_notes/widget/separated_list.dart';

const double _imageGridSpacing = 2.0;
const double _imageStripSpacing = 8.0;

class NoteImages extends StatelessWidget {
  final List<SavedImage> images;
  final ValueChanged<int>? onImageTap;
  final ImageLayoutType layoutType;
  final Axis stripAxis;
  final int? maxGridRows;

  const NoteImages({
    required this.images,
    this.onImageTap,
    this.layoutType = ImageLayoutType.grid,
    this.stripAxis = Axis.horizontal,
    this.maxGridRows,
  });

  @override
  Widget build(BuildContext context) {
    switch (layoutType) {
      case ImageLayoutType.strip:
        return _ImageStrip(
          images: images,
          onImageTap: onImageTap,
          axis: stripAxis,
        );
      case ImageLayoutType.grid:
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
  final ValueChanged<int>? onImageTap;
  final int? maxGridRows;

  const _ImageGrid({
    required this.images,
    this.onImageTap,
    this.maxGridRows,
  });

  @override
  Widget build(BuildContext context) {
    final List<List<SavedImage>> _groupedImages = images.group(3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final List<Widget> _rows = <Widget>[];

        final int _forLength = maxGridRows != null
            ? _groupedImages.length.clamp(0, maxGridRows ?? 2)
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

        return SeparatedList(
          separator: const SizedBox(height: _imageGridSpacing),
          children: _rows,
        );
      },
    );
  }

  Widget buildImageRow(
      List<SavedImage> images, double baseWidth, int forLoopIndex) {
    assert(images.isNotEmpty && images.length <= 3);

    final List<Size> _sizes = images
        .map(
          (image) => Size(image.width!, image.height!),
        )
        .toList();

    final double _height = _getMinHeight(_sizes);
    final List<double> _transformedWidths =
        _sizes.map((s) => s.aspectRatio * _height).toList();

    final double _widthSum = _sumWidths(_transformedWidths);
    final double _newHeight =
        (baseWidth - (images.length - 1) * _imageGridSpacing) *
            _height /
            _widthSum;

    final List<double> _newWidths =
        _sizes.map((s) => s.aspectRatio * _newHeight).toList();
    final List<Widget> _children = <Widget>[];

    for (int i = 0; i < images.length; i++) {
      final SavedImage _savedImage = images[i];
      final double _width = _newWidths[i];

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

    return SeparatedList(
      axis: Axis.horizontal,
      separator: const SizedBox(width: _imageGridSpacing),
      children: _children,
    );
  }

  double _sumWidths(List<double> sizes) {
    double width = 0;

    for (final double size in sizes) {
      width += size;
    }

    return width;
  }

  double _getMinHeight(List<Size> sizes) {
    double? minHeight;

    for (final Size size in sizes) {
      if (minHeight == null) {
        minHeight = size.height;
        continue;
      } else {
        if (size.height < minHeight) minHeight = size.height;
      }
    }

    return minHeight!;
  }
}

class _ImageStrip extends StatelessWidget {
  final List<SavedImage> images;
  final Axis axis;
  final ValueChanged<int>? onImageTap;

  const _ImageStrip({
    required this.images,
    this.axis = Axis.horizontal,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: Padding(
        padding: const EdgeInsets.all(_imageStripSpacing),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_imageStripSpacing / 2),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                  },
                ),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final SavedImage _image = images[index];
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
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(_imageStripSpacing / 2),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: NoteImage(savedImage: _image),
                            ),
                            Positioned.fill(
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () => onImageTap?.call(index),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox.fromSize(
                    size: const Size.square(_imageStripSpacing),
                  ),
                  itemCount: images.length,
                  scrollDirection: axis,
                  padding: EdgeInsets.zero,
                  controller: ScrollController(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum ImageLayoutType {
  grid,
  strip,
}

extension ListGrouping<T> on List<T> {
  List<List<T>> group(int size) {
    final List<List<T>> groups = [];

    for (var i = 0; i < length; i += size) {
      final int end = (i + size < length) ? i + size : length;
      groups.add(sublist(i, end));
    }

    return groups;
  }
}
