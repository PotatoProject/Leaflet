import 'package:loggy/loggy.dart';

mixin LoggerProvider {
  Logger get logger => Logger(super.runtimeType.toString());
}
