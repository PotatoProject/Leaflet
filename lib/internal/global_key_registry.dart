import 'package:flutter/material.dart';

class GlobalKeyRegistry {
  static Map<dynamic, GlobalKey> _registry = {};

  static GlobalKey get(dynamic id) {
    GlobalKey? key = _registry[id];

    if (key == null) {
      _registry[id] = GlobalKey();
    }

    return _registry[id]!;
  }
}
