import 'dart:io';

import 'package:flutter/material.dart';
import 'package:potato_notes/internal/draw_object.dart';

class DrawingBoard extends StatelessWidget {
  final Key repaintKey;
  final List<DrawObject> objects;
  final Color color;
  final Uri uri;
  final Size size;

  DrawingBoard({
    this.repaintKey,
    @required this.objects,
    this.color,
    this.uri,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider image;

    if (uri != null) {
      String scheme = uri.scheme;

      if (scheme.startsWith("http")) {
        image = NetworkImage(uri.toString());
      } else {
        image = FileImage(File(uri.path));
      }
    }

    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          image: image != null
              ? DecorationImage(
                  image: image,
                  fit: BoxFit.contain,
                )
              : null,
        ),
        child: CustomPaint(
          size: size,
          foregroundPainter: DrawPainter(objects),
          isComplex: true,
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  List<DrawObject> objects;

  DrawPainter(this.objects);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < objects.length; i++) {
      DrawObject object = objects[i];

      if (object.points.length > 1) {
        Path path = Path();

        List<Offset> offsets = [];

        object.points.forEach((item) {
          offsets.add(item);
        });

        path.addPolygon(offsets, false);

        canvas.drawPath(path, object.paint..style = PaintingStyle.stroke);
      } else {
        canvas.drawCircle(object.points.last, object.paint.strokeWidth / 2,
            object.paint..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
