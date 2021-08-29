import 'dart:io';

import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final Directory appDir = Directory("appdir");
  final Directory linuxOut = Directory("build/linux/x64/release/bundle");
  final Directory resDir = Directory("linux/resources");
  final File appImageTool = File("bin/appimagetool.AppImage");

  if (await appDir.exists()) await appDir.delete(recursive: true);
  await appDir.create();

  if (!args.contains("--skip-build")) {
    Loggy.defaultLogger.d("Building app");
    final ProcessResult result =
        await Process.run("flutter", ["build", "linux"]);
    if (result.exitCode != 0) {
      Loggy.defaultLogger
          .d("Something went wrong while building:\n${result.stderr}");
      await appDir.delete(recursive: true);
      return;
    }
    Loggy.defaultLogger.d("Build done: ${result.exitCode}");
  }

  await copyPath(linuxOut, Directory(p.join(appDir.path, "usr/bin")));
  await copyPath(resDir, Directory(appDir.path));

  if (!await appImageTool.exists()) {
    Loggy.defaultLogger.d("AppImageTool missing, downloading...");
    final Response response = await get(
      Uri.parse(
        "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage",
      ),
    );
    await appImageTool.create();
    await appImageTool.writeAsBytes(response.bodyBytes);
  }

  final ProcessResult result = await Process.run(
    appImageTool.absolute.path,
    [appDir.absolute.path],
    environment: {"ARCH": "x86_64"},
  );

  if (result.exitCode != 0) {
    Loggy.defaultLogger
        .d("An error occurred while running appImageTool:\n${result.stderr}");
    await appDir.delete(recursive: true);
    return;
  }
  Loggy.defaultLogger.d("Done!");
  await appDir.delete(recursive: true);
  return;
}

Future<void> copyPath(Directory from, Directory to) async {
  await to.create(recursive: true);
  await for (final file in from.list(recursive: true)) {
    final copyTo = p.join(to.path, p.relative(file.path, from: from.path));
    if (file is Directory) {
      await Directory(copyTo).create(recursive: true);
    } else if (file is File) {
      await File(file.path).copy(copyTo);
    } else if (file is Link) {
      await Link(copyTo).create(await file.target(), recursive: true);
    }
  }
}
