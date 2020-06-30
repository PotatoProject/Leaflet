import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:loggy/loggy.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/draw_object.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/drawing_board.dart';
import 'package:spicy_components/spicy_components.dart';

class DrawPage extends StatefulWidget {
  final Note note;
  final MapEntry<String, Uri> data;

  DrawPage({
    @required this.note,
    this.data,
  });

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage>
    with SingleTickerProviderStateMixin {
  static const List<Color> availableColors = Colors.primaries;

  BuildContext globalContext;
  List<DrawObject> objects = [];
  List<DrawObject> backupObjects = [];
  int currentIndex;
  int actionQueueIndex = 0;
  double strokeWidth = 6;
  Color selectedColor = Colors.black;
  DrawTool currentTool = DrawTool.PEN;
  MenuShowReason showReason = MenuShowReason.COLOR_PICKER;
  AnimationController controller;
  bool saved = true;

  String filePath;

  final GlobalKey key = new GlobalKey();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    BackButtonInterceptor.add(exitPrompt);
  }

  bool exitPrompt(bool _) {
    Uri uri = filePath != null ? Uri.file(filePath) : null;

    void _internal() async {
      if (!saved) {
        bool exit = await showDialog(
          context: globalContext,
          builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            content:
                Text("Any unsaved change will be lost. Do you want to exit?"),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                textColor: Theme.of(context).accentColor,
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, true),
                textColor: Theme.of(context).accentColor,
                child: Text("Exit"),
              ),
            ],
          ),
        );

        if (exit != null) {
          Navigator.pop(globalContext, uri);
        }
      } else {
        Navigator.pop(globalContext, uri);
      }
    }

    _internal();

    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(exitPrompt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this.globalContext == null) this.globalContext = context;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () => exitPrompt(true)),
        actions: [
          IconButton(
            icon: Icon(CommunityMaterialIcons.undo),
            padding: EdgeInsets.all(0),
            onPressed: objects.isNotEmpty
                ? () => setState(() {
                      objects.removeLast();
                      actionQueueIndex = objects.length - 1;
                      saved = false;
                    })
                : null,
          ),
          IconButton(
            icon: Icon(CommunityMaterialIcons.redo),
            padding: EdgeInsets.all(0),
            onPressed: actionQueueIndex < backupObjects.length - 1
                ? () => setState(() {
                      actionQueueIndex = objects.length;
                      objects.add(backupObjects[actionQueueIndex]);
                      saved = false;
                    })
                : null,
          ),
          IconButton(
            icon: Icon(CommunityMaterialIcons.content_save_outline),
            padding: EdgeInsets.all(0),
            onPressed: !saved
                ? () async {
                    ui.Image image = await (key.currentContext
                            .findRenderObject() as RenderRepaintBoundary)
                        .toImage();
                    ByteData byteData =
                        await image.toByteData(format: ui.ImageByteFormat.png);
                    Uint8List pngBytes = byteData.buffer.asUint8List();
                    DateTime now = DateTime.now();
                    String timestamp =
                        DateFormat("HH_ss-MM_dd_yyyy").format(now);

                    String drawing;
                    if (widget.data == null) {
                      if (filePath == null) {
                        drawing =
                            "${(await getApplicationDocumentsDirectory()).path}/drawing-$timestamp.png";
                        filePath = drawing;
                      } else {
                        drawing = filePath;
                      }
                    } else {
                      drawing = widget.data.key;
                    }

                    File imgFile = File(drawing);
                    await imgFile.writeAsBytes(pngBytes, flush: true);
                    Loggy.d(message: drawing);

                    if (!widget.note.images.data.containsKey(drawing)) {
                      widget.note.images.data[drawing] = Uri.file(drawing);
                      helper.saveNote(widget.note);
                    }

                    imageCache.clear();
                    imageCache.clearLiveImages();
                    setState(() => saved = true);
                  }
                : null,
          ),
        ],
      ),
      extendBody: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            56 -
            48 -
            MediaQuery.of(context).padding.top,
        child: GestureDetector(
          onPanStart: currentTool == DrawTool.ERASER
              ? _eraserModePan
              : _normalModePanStart,
          onPanUpdate: currentTool == DrawTool.ERASER
              ? _eraserModePan
              : _normalModePanUpdate,
          onPanEnd: currentTool == DrawTool.ERASER ? null : _normalModePanEnd,
          child: DrawingBoard(
            repaintKey: key,
            objects: objects,
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height -
                  56 -
                  48 -
                  MediaQuery.of(context).padding.top,
            ),
            uri: widget.data != null ? widget.data.value : null,
            color: Colors.grey[50],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizeTransition(
              sizeFactor: controller,
              axis: Axis.vertical,
              axisAlignment: 1,
              child: Material(
                color: Theme.of(context).cardColor,
                child: SizedBox(
                  height: 48,
                  child: showReason == MenuShowReason.RADIUS_PICKER
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(width: 16),
                            Text(strokeWidth.toInt().toString()),
                            Expanded(
                              child: Slider(
                                value: strokeWidth,
                                min: 4,
                                max: 50,
                                onChanged: (value) =>
                                    setState(() => strokeWidth = value),
                                activeColor: Theme.of(context).accentColor,
                                inactiveColor: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availableColors.length + 1,
                          itemBuilder: (context, index) {
                            Color currentColor = index == 0
                                ? Colors.black
                                : availableColors[index - 1];

                            return IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: currentColor,
                                ),
                                width: 32,
                                height: 32,
                                child: currentColor == selectedColor
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ),
                              onPressed: () {
                                setState(() => selectedColor = currentColor);
                                controller.animateBack(0);
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
            SpicyBottomBar(
              height: 48,
              elevation: 0,
              leftItems: <Widget>[
                IconButton(
                  icon: Icon(CommunityMaterialIcons.brush),
                  color: currentTool == DrawTool.PEN
                      ? Theme.of(context).accentColor
                      : null,
                  padding: EdgeInsets.all(0),
                  onPressed: () => setState(() => currentTool = DrawTool.PEN),
                ),
                IconButton(
                  icon: Icon(CommunityMaterialIcons.eraser_variant),
                  color: currentTool == DrawTool.ERASER
                      ? Theme.of(context).accentColor
                      : null,
                  padding: EdgeInsets.all(0),
                  onPressed: () =>
                      setState(() => currentTool = DrawTool.ERASER),
                ),
                IconButton(
                  icon: Icon(CommunityMaterialIcons.marker),
                  color: currentTool == DrawTool.MARKER
                      ? Theme.of(context).accentColor
                      : null,
                  padding: EdgeInsets.all(0),
                  onPressed: () =>
                      setState(() => currentTool = DrawTool.MARKER),
                ),
              ],
              rightItems: <Widget>[
                IconButton(
                  icon: Icon(OMIcons.colorLens),
                  padding: EdgeInsets.all(0),
                  onPressed: () async {
                    if (showReason == MenuShowReason.COLOR_PICKER &&
                        controller.value > 0) {
                      await controller.animateBack(0);
                    } else {
                      await controller.animateBack(0);
                      setState(() => showReason = MenuShowReason.COLOR_PICKER);
                      await controller.animateTo(1);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(CommunityMaterialIcons.radius_outline),
                  padding: EdgeInsets.all(0),
                  onPressed: () async {
                    if (showReason == MenuShowReason.RADIUS_PICKER &&
                        controller.value > 0) {
                      await controller.animateBack(0);
                    } else {
                      await controller.animateBack(0);
                      setState(() => showReason = MenuShowReason.RADIUS_PICKER);
                      await controller.animateTo(1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _normalModePanStart(details) {
    controller.animateTo(0);
    setState(() => saved = false);
    if (currentTool == DrawTool.MARKER) {
      objects.add(DrawObject(
          Paint()
            ..strokeCap = StrokeCap.square
            ..isAntiAlias = true
            ..color = selectedColor.withOpacity(0.5)
            ..strokeWidth = strokeWidth
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
          []));
    } else {
      objects.add(DrawObject(
          Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = selectedColor
            ..strokeWidth = strokeWidth
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
          []));
    }

    currentIndex = objects.length - 1;
    actionQueueIndex = currentIndex;

    RenderBox box = context.findRenderObject();

    Offset point = box.globalToLocal(Offset(details.globalPosition.dx,
        details.globalPosition.dy - MediaQuery.of(context).padding.top - 56));

    setState(() => objects[currentIndex].points.add(point));
  }

  void _normalModePanUpdate(details) {
    RenderBox box = context.findRenderObject();

    Offset point = box.globalToLocal(Offset(details.globalPosition.dx,
        details.globalPosition.dy - MediaQuery.of(context).padding.top - 56));

    setState(() => objects[currentIndex].points.add(point));
  }

  void _eraserModePan(details) {
    controller.animateTo(0);
    setState(() => saved = false);
    RenderBox box = context.findRenderObject();

    for (int i = 0; i < objects.length; i++) {
      DrawObject object = objects[i];
      Offset touchPoint = box.globalToLocal(Offset(details.globalPosition.dx,
          details.globalPosition.dy - MediaQuery.of(context).padding.top - 56));

      if (object.points.length > 1) {
        for (int j = 1; j < object.points.length - 1; j++) {
          double distanceAC =
              distanceBetweenPoints(object.points[j], touchPoint);
          double distanceCB =
              distanceBetweenPoints(touchPoint, object.points[j + 1]);
          double distanceAB =
              distanceBetweenPoints(object.points[j], object.points[j + 1]);

          if (distanceAB - distanceCB >=
              distanceAC - (object.paint.strokeWidth / 2)) {
            setState(() {
              objects.remove(object);
              actionQueueIndex = objects.length - 1;
            });
          }
        }
      } else {
        double distanceAC = distanceBetweenPoints(object.points[0], touchPoint);

        if (distanceAC < object.paint.strokeWidth / 2) {
          setState(() {
            objects.remove(object);
            actionQueueIndex = objects.length - 1;
          });
        }
      }
    }
  }

  void _normalModePanEnd(details) {
    currentIndex = null;
    backupObjects = List.from(objects);
  }

  double distanceBetweenPoints(Offset p1, Offset p2) {
    double pXDifference = p2.dx - p1.dx;
    double pYDifference = p2.dy - p1.dy;

    double xDiffPlusYDiff =
        (pXDifference * pXDifference) + (pYDifference * pYDifference);
    double squaredXDiffPlusYDiff = sqrt(xDiffPlusYDiff);

    return squaredXDiffPlusYDiff;
  }
}

enum DrawTool {
  PEN,
  ERASER,
  MARKER,
}

enum MenuShowReason {
  COLOR_PICKER,
  RADIUS_PICKER,
}
