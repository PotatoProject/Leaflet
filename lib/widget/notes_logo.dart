import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class IconLogo extends StatelessWidget {
  static const Size logoSize = Size(46, 64);
  final double height;

  IconLogo({
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        height * logoSize.aspectRatio,
        height,
      ),
      isComplex: true,
      painter: IconLogoPainter(
        height: height,
      ),
    );
  }
}

class IconLogoPainter extends CustomPainter {
  IconLogoPainter({
    required this.height,
  });

  final double height;

  @override
  bool shouldRepaint(IconLogoPainter oldDelegate) =>
      oldDelegate.height != this.height;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _logoPaths.length; i++) {
      final pathData = _logoPaths[i];
      final path = parseSvgPathData(pathData.path);
      final paint = Paint()..color = pathData.color;

      if (i == 0) {
        Rect rect = path.getBounds();
        canvas.scale(height / rect.bottom);
      }

      canvas.drawPath(path, paint);
    }
  }
}

class PathData {
  final String path;
  final Color color;

  const PathData(this.path, this.color);
}

const List<PathData> _logoPaths = [
  PathData(
    "M0 41.8462C0 19.6923 23 0 23 0C23 0 46 19.6923 46 41.8462C46 59.5443 25.5091 64 23 64C20.4909 64 0 59.5443 0 41.8462Z",
    Color(0xFF66BB6A),
  ),
  PathData(
    "M45.2224 34.6307C41.2071 15.589 22.9996 0 22.9996 0C22.9996 0 4.79205 15.5891 0.776855 34.6309L22.9995 47.3924L45.2224 34.6307Z",
    Color(0xFF81C784),
  ),
  PathData(
    "M22.9996 47.3925L0.777875 34.627L0.626953 35.3793L22.9996 48.227L45.3726 35.3791L45.2215 34.6257L22.9996 47.3925Z",
    Color(0x3333691E),
  ),
  PathData(
    "M38.1014 17.8594C31.4457 7.23119 22.9999 0 22.9999 0C22.9999 0 14.5541 7.23119 7.89844 17.8594L22.9999 26.5315L38.1014 17.8594Z",
    Color(0xFFA5D6A7),
  ),
  PathData(
    "M22.9996 26.5315L7.8981 17.8594L7.51709 18.475L22.9996 27.366L38.4827 18.4747L38.1011 17.8594L22.9996 26.5315Z",
    Color(0x3333691E),
  ),
  PathData(
    "M23 64V0C23 0 46 19.6923 46 41.8462C46 59.5443 25.5091 64 23 64Z",
    Color(0x3333691E),
  ),
  PathData(
    "M19.6548 63.3976C21.2823 63.8225 22.4995 64 23.0002 64C23.501 64 24.7181 63.8225 26.3457 63.3976L26.3457 36.2531C26.3457 36.2531 24.4639 31.7975 23.6693 29.7721C23.3515 28.962 22.6657 28.962 22.3312 29.7721L19.6548 36.2531L19.6548 63.3976Z",
    Color(0xFFE8F5E9),
  ),
];
