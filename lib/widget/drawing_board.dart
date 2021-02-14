import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawingBoard extends StatefulWidget {
  final Key repaintKey;
  final DrawingBoardController controller;
  final Color color;
  final String path;

  DrawingBoard({
    this.repaintKey,
    this.controller,
    this.color,
    this.path,
  });

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<DrawObject> _objects = [];
  List<DrawObject> _backupObjects = [];
  int _currentIndex;
  int _actionQueueIndex = 0;
  bool _saved = true;
  ui.Image _image;

  bool get saved => _saved;
  set saved(bool value) {
    _saved = value;
    setState(() {});
  }

  set backupObjects(List<DrawObject> value) {
    _backupObjects = value;
    setState(() {});
  }

  void addObject(DrawObject object) {
    _objects.add(object);
    widget.controller._notifyListeners();
    setState(() {});
  }

  void addPointToObject(int objectIndex, Offset point) {
    _objects[objectIndex].points.add(point);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    widget.controller?._provideState(this);

    if (widget.path != null) {
      final ImageProvider image = FileImage(File(widget.path));

      image?.resolve(ImageConfiguration())?.addListener(
        ImageStreamListener((image, synchronousCall) {
          _image = image.image;
          setState(() {});
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.key,
      child: CustomPaint(
        painter: BackgroundPainter(_image),
        foregroundPainter: DrawPainter(List.from(_objects.map((e) => e.copy))),
        willChange: true,
        isComplex: true,
      ),
    );
  }

  void _clearCanvas() {
    _objects.clear();
    _backupObjects.clear();
    _actionQueueIndex = 0;
    widget.controller._notifyListeners();
    setState(() {});
  }

  void _undo() {
    setState(() {
      _objects.removeLast();
      _actionQueueIndex = _objects.length - 1;
      _saved = false;
      widget.controller._notifyListeners();
    });
  }

  void _redo() {
    setState(() {
      _actionQueueIndex = _objects.length;
      _objects.add(_backupObjects[_actionQueueIndex]);
      _saved = false;
      widget.controller._notifyListeners();
    });
  }

  bool get _canUndo => _objects.isNotEmpty;
  bool get _canRedo => _actionQueueIndex < _backupObjects.length - 1;
}

class DrawPainter extends CustomPainter {
  List<DrawObject> objects;

  DrawPainter(this.objects);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    objects.forEach((object) => object.render(canvas));
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawPainter old) {
    if (objects.length != old.objects.length) return true;

    for (int i = 0; i < objects.length; i++) {
      final DrawObject object = objects[i];
      final DrawObject oldObject = old.objects[i];

      if (!listEquals(object.points, oldObject.points)) return true;
    }

    return false;
  }
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
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.image != this.image;
  }
}

class DrawingBoardController extends ChangeNotifier {
  _DrawingBoardState _state;

  void _provideState(_DrawingBoardState state) => this._state = state;

  void clearCanvas() => _state._clearCanvas();

  void undo() => _state._undo();

  void redo() => _state._redo();

  void addObject(DrawObject object) => _state.addObject(object);
  void addPointToObject(int objectIndex, Offset point) =>
      _state.addPointToObject(objectIndex, point);

  bool get saved => _state?._saved ?? true;
  set saved(bool value) => _state._saved = value;

  int get currentIndex => _state._currentIndex;
  set currentIndex(int value) => _state._currentIndex = value;

  int get actionQueueIndex => _state._actionQueueIndex;
  set actionQueueIndex(int value) => _state._actionQueueIndex = value;

  List<DrawObject> get objects => _state._objects;
  set backupObjects(List<DrawObject> value) => _state.backupObjects = value;

  bool get canUndo => _state?._canUndo ?? false;
  bool get canRedo => _state?._canRedo ?? false;

  void _notifyListeners() => notifyListeners();
}

class DrawObject {
  final Paint paint;
  List<Offset> points;

  DrawObject(this.paint, this.points);

  void render(Canvas canvas) {
    if (points.length > 1) {
      final Path path = Path();

      path.addPolygon(points, false);

      canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    } else {
      canvas.drawCircle(points.last, paint.strokeWidth / 2,
          paint..style = PaintingStyle.fill);
    }
  }

  @override
  int get hashCode => hashValues(paint.hashCode, points.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is DrawObject) {
      return paint == other.paint && listEquals(points, other.points);
    }

    return false;
  }

  DrawObject get copy {
    return DrawObject(
      paint,
      List.from(points),
    );
  }
}
