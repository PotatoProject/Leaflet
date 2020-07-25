import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class NotesLogo extends StatelessWidget {
  final double height;
  final Color bgColor;
  final Color fgColor;
  final Color penColor;

  NotesLogo({
    this.height = 36,
    this.bgColor = const Color(0xFFE07F00),
    this.fgColor = const Color(0xFFFF9100),
    this.penColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        height / 1.2183908046,
        height,
      ),
      isComplex: true,
      painter: NotesPainter(
        bg: PathData(
          "M 77.694 0.093 L 9.556 0.093 C 4.701 0.093 0.764 4.03 0.764 8.885 L 0.764 96.804 C 0.764 101.66 4.701 105.596 9.556 105.596 L 77.694 105.596 C 82.549 105.596 86.486 101.66 86.486 96.804 L 86.486 8.885 C 86.486 4.03 82.549 0.093 77.694 0.093 Z",
          bgColor,
        ),
        fg: PathData(
          "M 86.486 23.271 L 86.486 96.804 C 86.486 99.136 85.559 101.372 83.91 103.021 C 82.262 104.67 80.025 105.596 77.694 105.596 L 9.556 105.596 C 7.225 105.596 4.988 104.67 3.339 103.021 C 1.691 101.372 0.764 99.136 0.764 96.804 L 0.764 23.271 C 0.764 22.105 1.228 20.987 2.052 20.163 C 2.876 19.338 3.994 18.875 5.16 18.875 L 82.09 18.875 C 83.255 18.875 84.374 19.338 85.198 20.163 C 86.022 20.987 86.486 22.105 86.486 23.271 Z",
          fgColor,
        ),
        pen: PathData(
          "M 52.417 62.626 L 52.417 105.596 L 34.833 105.596 L 34.833 62.626 C 34.832 61.134 35.21 59.667 35.932 58.362 L 41.68 47.998 C 41.87 47.655 42.148 47.368 42.487 47.169 C 42.825 46.97 43.21 46.864 43.603 46.864 C 43.996 46.864 44.381 46.97 44.719 47.169 C 45.058 47.368 45.336 47.655 45.526 47.998 L 51.274 58.362 C 52.011 59.663 52.405 61.13 52.417 62.626 Z",
          penColor,
        ),
        height: height,
      ),
    );
  }
}

class NotesPainter extends CustomPainter {
  NotesPainter({
    this.bg,
    this.fg,
    this.pen,
    this.height,
  });

  final PathData bg;
  final PathData fg;
  final PathData pen;
  final double height;

  @override
  bool shouldRepaint(NotesPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Path bgPath = parseSvgPathData(bg.path);
    Rect rect = bgPath.getBounds();
    canvas.scale(height / rect.bottom);
    canvas.drawPath(bgPath, new Paint()..color = bg.color);

    Path fgPath = parseSvgPathData(fg.path);
    canvas.drawPath(fgPath, new Paint()..color = fg.color);

    Path penPath = parseSvgPathData(pen.path);
    canvas.drawPath(penPath, new Paint()..color = pen.color);
  }
}

class PathData {
  String path;
  Color color;

  PathData(this.path, this.color);
}
