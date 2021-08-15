import 'dart:io';

import 'package:potato_notes/internal/theme/data.dart';
import 'package:toml/toml.dart';

Future<void> main() async {
  final ThemeParser parser = await ThemeParser.fromFile(File(
    "D:\\dnbia\\Documents\\theme-sample.toml",
  ));
  parser.parse();
}

class ThemeParser {
  final Map<String, dynamic> data;

  const ThemeParser(this.data);

  factory ThemeParser.fromString(String rawContents) {
    return ThemeParser(TomlDocument.parse(rawContents).toMap());
  }

  static Future<ThemeParser> fromFile(File file) async {
    final String fileContents = await file.readAsString();
    return ThemeParser.fromString(fileContents);
  }

  void /* LeafletThemeData */ parse() {
    final String name = data["name"]! as String;

    print(name);
    print(data);
  }
}
