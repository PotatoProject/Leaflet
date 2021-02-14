import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class LeafletLogo extends StatelessWidget {
  static const Size size = Size(46, 64);
  final double height;

  LeafletLogo({
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        height * size.aspectRatio,
        height,
      ),
      isComplex: true,
      painter: _LeafletLogoPainter(
        height: height,
      ),
    );
  }
}

class _LeafletLogoPainter extends CustomPainter {
  _LeafletLogoPainter({
    this.height,
  });

  final double height;

  @override
  bool shouldRepaint(_LeafletLogoPainter oldDelegate) =>
      oldDelegate.height != this.height;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _leafletLogoPaths.length; i++) {
      final pathData = _leafletLogoPaths[i];
      final path = _PathCache.instance.getPath(pathData);
      final paint = Paint()..color = pathData.color;

      if (i == 0) {
        Rect rect = path.getBounds();
        canvas.scale(height / rect.bottom);
      }

      canvas.drawPath(path, paint);
    }
  }
}

class PospLogo extends StatelessWidget {
  static const Size size = Size(100, 24);
  final Color color;
  final double height;

  PospLogo({
    this.color,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        height * size.aspectRatio,
        height,
      ),
      isComplex: true,
      painter: _PospLogoPainter(
        color: color ?? Theme.of(context).iconTheme.color,
        height: height,
      ),
    );
  }
}

class _PospLogoPainter extends CustomPainter {
  _PospLogoPainter({
    this.color,
    this.height,
  });

  final Color color;
  final double height;

  @override
  bool shouldRepaint(_PospLogoPainter old) =>
      this.color != old.color || this.height != old.height;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _pospLogoPaths.length; i++) {
      final pathData = _pospLogoPaths[i];
      final path = _PathCache.instance.getPath(pathData);
      final paint = Paint()..color = color ?? Colors.transparent;

      if (i == 0) {
        Rect rect = path.getBounds();
        canvas.scale(height / rect.bottom);
      }

      canvas.drawPath(path, paint);
    }
  }
}

class _PathCache {
  static final _PathCache instance = _PathCache._();
  _PathCache._();

  final Map<String, Path> _cache = {};

  Path getPath(PathData pathData) {
    if (_cache.containsKey(pathData.name)) {
      return _cache[pathData.name];
    }

    final Path parsedPath = parseSvgPathData(pathData.path);
    _cache[pathData.name] = parsedPath;
    return parsedPath;
  }
}

class PathData {
  final String name;
  final String path;
  final Color color;

  const PathData(this.name, this.path, [this.color]);
}

const List<PathData> _leafletLogoPaths = [
  PathData(
    "leaf_bg1",
    "M0 41.8462C0 19.6923 23 0 23 0C23 0 46 19.6923 46 41.8462C46 59.5443 25.5091 64 23 64C20.4909 64 0 59.5443 0 41.8462Z",
    Color(0xFF66BB6A),
  ),
  PathData(
    "leaf_bg2",
    "M45.2224 34.6307C41.2071 15.589 22.9996 0 22.9996 0C22.9996 0 4.79205 15.5891 0.776855 34.6309L22.9995 47.3924L45.2224 34.6307Z",
    Color(0xFF81C784),
  ),
  PathData(
    "leaf_shadow1",
    "M22.9996 47.3925L0.777875 34.627L0.626953 35.3793L22.9996 48.227L45.3726 35.3791L45.2215 34.6257L22.9996 47.3925Z",
    Color(0x3333691E),
  ),
  PathData(
    "leaf_bg3",
    "M38.1014 17.8594C31.4457 7.23119 22.9999 0 22.9999 0C22.9999 0 14.5541 7.23119 7.89844 17.8594L22.9999 26.5315L38.1014 17.8594Z",
    Color(0xFFA5D6A7),
  ),
  PathData(
    "leaf_shadow3",
    "M22.9996 26.5315L7.8981 17.8594L7.51709 18.475L22.9996 27.366L38.4827 18.4747L38.1011 17.8594L22.9996 26.5315Z",
    Color(0x3333691E),
  ),
  PathData(
    "leaf_sideshade",
    "M23 64V0C23 0 46 19.6923 46 41.8462C46 59.5443 25.5091 64 23 64Z",
    Color(0x3333691E),
  ),
  PathData(
    "leaf_pen",
    "M19.6548 63.3976C21.2823 63.8225 22.4995 64 23.0002 64C23.501 64 24.7181 63.8225 26.3457 63.3976L26.3457 36.2531C26.3457 36.2531 24.4639 31.7975 23.6693 29.7721C23.3515 28.962 22.6657 28.962 22.3312 29.7721L19.6548 36.2531L19.6548 63.3976Z",
    Color(0xFFE8F5E9),
  ),
];

const List<PathData> _pospLogoPaths = [
  PathData(
    "posp_potato",
    "M19.0617 9.07722L19.0532 9.06956C18.4012 8.47134 17.8336 8.13811 17.3987 7.88278L17.3671 7.86419C17.1189 7.7184 16.9154 7.59825 16.6737 7.43431L16.6678 7.43034L16.6619 7.42636C16.462 7.29229 16.3188 7.18153 15.8837 6.8399L15.7769 6.75599L15.7569 6.7404C15.5018 6.54076 15.0834 6.2133 14.5453 5.732L14.5361 5.72382L14.5269 5.71575C13.9895 5.24368 13.338 4.61474 12.6605 3.821L12.6268 3.78156L12.5917 3.74339C12.0836 3.19179 11.7259 2.76348 11.4217 2.39889C11.3855 2.35555 11.3485 2.31075 11.3105 2.26476L11.3069 2.26036C10.7419 1.57626 9.95701 0.625934 8.45773 0.210349L8.45599 0.209868C5.99252 -0.471244 3.56488 0.607227 2.15007 1.98347C0.331064 3.74854 0.121457 5.97905 0.0479965 6.76078L0.0434981 6.80843C-0.235215 9.60894 0.876281 11.8338 1.92686 13.9368L1.99875 14.0807C2.44847 14.9856 3.05221 16.1827 4.09721 17.6112L4.19546 17.7454C5.04994 18.9122 6.07192 20.3077 7.27478 21.4345C8.55697 22.6356 10.2144 23.7 12.3742 23.946C15.0668 24.2589 18.937 23.2501 20.8847 19.8918C22.0023 17.9758 22.1 15.9257 21.7764 14.218C21.4573 12.534 20.7036 11.0141 19.8493 9.92209L19.8426 9.91358L19.8358 9.90508C19.6367 9.65466 19.4428 9.4489 19.3038 9.30924C19.2842 9.28949 19.2652 9.27067 19.2471 9.25287L19.2122 9.21876L19.1766 9.1844L19.1598 9.16839L19.1229 9.13357C19.099 9.11122 19.0784 9.09235 19.0617 9.07722Z",
  ),
  PathData(
    "posp_p",
    "M67.9016 11.8536C67.9016 17.7859 63.2082 22.3359 57.4206 22.3359C51.6331 22.3359 46.9397 17.7859 46.9397 11.8536C46.9397 5.92135 51.6331 1.37134 57.4206 1.37134C63.2082 1.37134 67.9016 5.92135 67.9016 11.8536ZM51.5467 11.8536C51.5467 15.4533 54.1381 17.8435 57.4206 17.8435C60.7031 17.8435 63.2945 15.4533 63.2945 11.8536C63.2945 8.25395 60.7031 5.86375 57.4206 5.86375C54.1381 5.86375 51.5467 8.25395 51.5467 11.8536Z",
  ),
  PathData(
    "posp_o",
    "M31.5361 1.7745H39.1665C43.14 1.7745 46.221 4.85584 46.221 8.68591C46.221 12.516 43.14 15.5973 39.1665 15.5973H36.1431V21.9328H31.5361V1.7745ZM36.1431 11.2777H39.1665C40.5774 11.2777 41.614 10.1546 41.614 8.68591C41.614 7.21724 40.5774 6.09413 39.1665 6.09413H36.1431V11.2777Z",
  ),
  PathData(
    "posp_s",
    "M76.243 22.3359C80.6196 22.3359 83.7294 20.0321 83.7294 16.1445C83.7294 11.8824 80.3029 10.8169 77.2508 9.89541C74.1122 8.94509 73.6227 8.31154 73.6227 7.39002C73.6227 6.58369 74.3426 5.86375 75.7823 5.86375C77.6251 5.86375 78.5753 6.75648 79.2663 8.19635L83.1535 5.92135C81.685 2.9552 79.0936 1.37134 75.7823 1.37134C72.2982 1.37134 69.0157 3.61755 69.0157 7.50521C69.0157 11.3641 71.9527 12.804 74.9473 13.6391C77.9706 14.4742 79.1223 14.9638 79.1223 16.2021C79.1223 16.9796 78.5753 17.8435 76.3869 17.8435C74.1122 17.8435 72.8741 16.7204 72.1543 15.0502L68.1807 17.354C69.3037 20.3201 72.0103 22.3359 76.243 22.3359Z",
  ),
  PathData(
    "posp_p2",
    "M85.3153 1.7745H92.9456C96.9192 1.7745 100 4.85584 100 8.68591C100 12.516 96.9192 15.5973 92.9456 15.5973H89.9223V21.9328H85.3153V1.7745ZM89.9223 11.2777H92.9456C94.3565 11.2777 95.3931 10.1546 95.3931 8.68591C95.3931 7.21724 94.3565 6.09413 92.9456 6.09413H89.9223V11.2777Z",
  ),
];
