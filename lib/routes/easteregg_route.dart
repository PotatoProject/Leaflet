import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:provider/provider.dart';

class EasterEggRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawScreen(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class DrawScreen extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<DrawScreen> {
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  double opacity = 1.0;
  StrokeCap strokeCap = StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  static List<Color> colors = [];
  Color pickerColor;
  Color selectedColor;
  bool firstTimeRunning = false;

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.amber,
      Theme.of(context).textTheme.title.color
    ];

    if (!firstTimeRunning) {
      pickerColor = colors.last;
      selectedColor = colors.last;
    }

    firstTimeRunning = true;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: _bottomAppBar,
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(
            pointsList: points,
          ),
        ),
      ),
    );
  }

  Widget get _bottomAppBar {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      height: 136,
      child: Builder(builder: (context) {
        return BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 48,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Icon(selectedMode == SelectedMode.StrokeWidth
                            ? Icons.blur_circular
                            : selectedMode == SelectedMode.Opacity
                                ? Icons.opacity
                                : Icons.color_lens),
                      ),
                      selectedMode == SelectedMode.Color
                          ? Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  colorCircle(colors[0]),
                                  colorCircle(colors[1]),
                                  colorCircle(colors[2]),
                                  colorCircle(colors[3]),
                                  colorCircle(colors[4]),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Slider(
                                value:
                                    (selectedMode == SelectedMode.StrokeWidth)
                                        ? strokeWidth
                                        : opacity,
                                max: (selectedMode == SelectedMode.StrokeWidth)
                                    ? 50.0
                                    : 1.0,
                                min: 0.0,
                                onChanged: (val) => setState(() {
                                  if (selectedMode == SelectedMode.StrokeWidth)
                                    strokeWidth = val;
                                  else
                                    opacity = val;
                                }),
                              ),
                            ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  height: 64,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.blur_circular),
                          onPressed: () {
                            setState(() {
                              selectedMode = SelectedMode.StrokeWidth;
                            });
                          }),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.opacity),
                          onPressed: () {
                            setState(() {
                              selectedMode = SelectedMode.Opacity;
                            });
                          }),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.color_lens),
                          color: selectedColor,
                          onPressed: () {
                            setState(() {
                              selectedMode = SelectedMode.Color;
                            });
                          }),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              points.clear();
                            });
                          }),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget colorCircle(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(34.0)),
        onTap: () {
          setState(() {
            selectedColor = color;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: ClipOval(
            child: Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              height: 36,
              width: 36,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
