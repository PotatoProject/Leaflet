import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';

class AppDirectories {
  final Directory tempDirectory;
  final Directory supportDirectory;
  final Directory imagesDirectory;
  final Directory themesDirectory;
  final Directory backupDirectory;

  const AppDirectories({
    required this.tempDirectory,
    required this.supportDirectory,
    required this.imagesDirectory,
    required this.themesDirectory,
    required this.backupDirectory,
  });

  static Future<AppDirectories> initWithDefaults() async {
    final Directory support = await getApplicationSupportDirectory();
    final Directory images = Directory(p.join(support.path, "images"));
    final Directory themes = Directory(p.join(support.path, "themes"));
    final Directory backup = Directory(await _getBackupsDir());
    images.create();
    themes.create();
    backup.create();

    return AppDirectories(
      tempDirectory: await getTemporaryDirectory(),
      supportDirectory: support,
      imagesDirectory: images,
      themesDirectory: themes,
      backupDirectory: backup,
    );
  }

  static Future<String> _getBackupsDir() async {
    if (UniversalPlatform.isAndroid) {
      final List<Directory>? directories =
          await getExternalStorageDirectories(type: StorageDirectory.documents);
      return p.join(directories!.first.path, "LeafletBackups");
    }
    return p.join(
      (await getApplicationDocumentsDirectory()).path,
      "LeafletBackups",
    );
  }
}
