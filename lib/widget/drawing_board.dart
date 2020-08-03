import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  Offset offset = Offset.zero;

  @override
  void initState() {
    /*widget.controller?.addListener(() {
      offset = Offset(
        offset.dx + widget.controller.delta.dx,
        offset.dy + widget.controller.delta.dy,
      );
      setState(() {});
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image;

    if (widget.uri != null) {
      String scheme = widget.uri.scheme;

      if (scheme.startsWith("http")) {
        image = CachedNetworkImageProvider(widget.uri.toString());
      } else {
        image = FileImage(File(widget.uri.path));
      }
    }

    Completer<ui.Image> completer = Completer<ui.Image>();

    image?.resolve(ImageConfiguration())?.addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          completer.complete(image.image);
        },
      ),
    );

    return RepaintBoundary(
      key: widget.repaintKey,
      child: FutureBuilder<ui.Image>(
        future: completer.future,
        builder: (context, snapshot) {
          return CustomPaint(
            size: snapshot.data != null
                ? Size(
                    snapshot.data.width.toDouble(),
                    snapshot.data.height.toDouble(),
                  )
                : Size.zero,
            painter: DrawPainter(
              widget.objects,
              snapshot.data,
              offset,
            ),
            isComplex: true,
          );
        },
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  List<DrawObject> objects;
  ui.Image image;
  Offset offset;

  DrawPainter(this.objects, this.image, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawColor(Colors.white, BlendMode.srcOver);

    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.none,
      );
    }

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
