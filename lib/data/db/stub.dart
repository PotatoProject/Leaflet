// @dart=2.12

export 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'io.dart';
