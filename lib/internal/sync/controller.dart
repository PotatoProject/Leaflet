import 'package:potato_notes/internal/logger_provider.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/sync/image/files_controller.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/sync/setting_controller.dart';
import 'package:potato_notes/internal/sync/tag_controller.dart';

abstract class Controller with LoggerProvider {
  String get prefix;

  String url(String route) {
    return "${prefs.apiUrl}/$prefix/$route";
  }

  static Map<String, dynamic> get tokenHeaders => {"useToken": true};
  static Map<String, dynamic> get refreshTokenHeaders =>
      {"useRefreshToken": true};

  static final AccountController account = AccountController();
  static final NoteController note = NoteController();
  static final SettingController setting = SettingController();
  static final TagController tag = TagController();
  static final FilesController files = FilesController();
}

class AuthResponse {
  final bool status;
  final Object? message;

  AuthResponse({
    required this.status,
    this.message,
  });
}
