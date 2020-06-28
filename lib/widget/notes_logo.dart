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
        height / 1.3,
        height,
      ),
      isComplex: true,
      painter: NotesPainter(
        bg: PathData(
          "M17.9487 0H2.05128C0.91839 0 0 0.97005 0 2.16667V23.8333C0 25.03 0.91839 26 2.05128 26H17.9487C19.0816 26 20 25.03 20 23.8333V2.16667C20 0.97005 19.0816 0 17.9487 0Z",
          bgColor,
        ),
        fg: PathData(
          "M20 6.0645V23.871C20 24.4356 19.7839 24.9772 19.3992 25.3764C19.0145 25.7757 18.4928 26 17.9487 26H2.05128C1.50725 26 0.985495 25.7757 0.600805 25.3764C0.216115 24.9772 0 24.4356 0 23.871V6.0645C0 5.78218 0.108058 5.51143 0.300403 5.3118C0.492748 5.11217 0.753624 5 1.02564 5H18.9744C19.2464 5 19.5073 5.11217 19.6996 5.3118C19.8919 5.51143 20 5.78218 20 6.0645Z",
          fgColor,
        ),
        pen: PathData(
          "M12 15.7571V26H8V15.7571C7.9997 15.4015 8.08574 15.0518 8.25 14.7406L9.5575 12.2703C9.60074 12.1884 9.66412 12.1201 9.74106 12.0726C9.818 12.0251 9.90568 12 9.995 12C10.0843 12 10.172 12.0251 10.2489 12.0726C10.3259 12.1201 10.3893 12.1884 10.4325 12.2703L11.74 14.7406C11.9078 15.0508 11.9972 15.4006 12 15.7571Z",
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
