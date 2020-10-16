import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:potato_notes/internal/draw_object.dart';

class DrawingBoard extends StatefulWidget {
  final Key repaintKey;
  final List<DrawObject> objects;
  final Color color;
  final Uri uri;

  DrawingBoard({
    this.repaintKey,
    @required this.objects,
    this.color,
    this.uri,
  });

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    Completer<ui.Image> completer = Completer<ui.Image>();

    if (widget.uri != null) {
      String scheme = widget.uri.scheme;

      if (scheme.startsWith("http")) {
        image = CachedNetworkImageProvider(widget.uri.toString());
      } else {
        image = FileImage(File(widget.uri.path));
      }

      image?.resolve(ImageConfiguration())?.addListener(
        ImageStreamListener(
          (image, synchronousCall) {
            completer.complete(image.image);
          },
        ),
      );
    }

    return RepaintBoundary(
      key: widget.repaintKey,
      child: image != null
          ? FutureBuilder<ui.Image>(
              future: completer.future,
              builder: (context, snapshot) {
                return getCommonChild(snapshot.data);
              },
            )
          : getCommonChild(null),
    );
  }

  Widget getCommonChild(ui.Image image) {
    return ClipRect(
      child: CustomPaint(
        willChange: true,
        painter: BackgroundPainter(
          image,
        ),
        foregroundPainter: DrawPainter(
          widget.objects,
        ),
        isComplex: true,
      ),
    );
  }
}

class CommonClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(ui.Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class DrawPainter extends CustomPainter {
  List<DrawObject> objects;

  DrawPainter(this.objects);

  @override
  void paint(Canvas canvas, Size size) {
    objects.forEach((object) {
      if (object.points.length > 1) {
        Path path = Path();

        path.addPolygon(object.points, false);

        canvas.drawPath(path, object.paint..style = PaintingStyle.stroke);
      } else {
        canvas.drawCircle(object.points.last, object.paint.strokeWidth / 2,
            object.paint..style = PaintingStyle.fill);
      }
    });
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) => true;
}

class BackgroundPainter extends CustomPainter {
  ui.Image image;

  BackgroundPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.none,
      );
    } else {
      canvas.drawColor(Colors.white, BlendMode.srcOver);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.image != this.image;
}
