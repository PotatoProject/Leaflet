import 'package:flutter/material.dart';

class GlobalKeyRegistry {
  GlobalKeyRegistry._();

  static final Map<dynamic, GlobalKey> _registry = {};

  static GlobalKey get(dynamic id) {
    final GlobalKey key = _registry[id];

    if (key == null) {
      _registry[id] = GlobalKey();
    }

    return _registry[id];
  }
}
