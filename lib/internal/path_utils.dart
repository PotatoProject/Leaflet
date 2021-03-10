// @dart=2.12

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:path_drawing/path_drawing.dart';

class PathCache {
  static final PathCache instance = PathCache._();
  PathCache._();

  final Map<String, Path> _cache = {};

  Path getPath(String name, String path) {
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    }

    final Path parsedPath = parseSvgPathData(path);
    _cache[name] = parsedPath;
    return parsedPath;
  }
}

@immutable
class PathInfo {
  final String name;
  final Size size;
  final List<PathData> data;
  final Color? tint;

  const PathInfo({
    required this.name,
    required this.size,
    this.data = const <PathData>[],
    this.tint,
  });

  @override
  bool operator ==(Object? other) {
    if (other is PathInfo) {
      return name == other.name &&
          size == other.size &&
          listEquals(data, other.data);
    }
    return false;
  }

  @override
  int get hashCode => hashValues(name, size, data);

  PathInfo copyWith({
    String? name,
    Size? size,
    List<PathData>? data,
    Color? tint,
  }) {
    return PathInfo(
      name: name ?? this.name,
      size: size ?? this.size,
      data: data ?? this.data,
      tint: tint ?? this.tint,
    );
  }
}

@immutable
class PathData {
  final String path;
  final Color? color;

  const PathData({
    required this.path,
    this.color,
  });

  @override
  bool operator ==(Object? other) {
    if (other is PathData) {
      return path == other.path && color?.value == other.color?.value;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(path, color);
}

class PathInfoPainter extends CustomPainter {
  final PathInfo info;
  final double? height;

  PathInfoPainter({
    required this.info,
    this.height,
  });

  @override
  bool shouldRepaint(PathInfoPainter old) =>
      info != old.info || height != old.height;

  @override
  void paint(Canvas canvas, Size size) {
    if (height != null) canvas.scale(height! / info.size.height);

    for (int i = 0; i < info.data.length; i++) {
      final PathData pathData = info.data[i];
      final Path path = PathCache.instance
          .getPath("${info.name}_path${i + 1}", pathData.path);
      final Paint paint = Paint()
        ..color = info.tint ?? pathData.color ?? const Color(0xFF000000);

      canvas.drawPath(path, paint);
    }
  }
}
