import 'dart:io';

import 'package:recase/recase.dart';

import 'xml_file_parser.dart';

class KeyGenerator {
  final String localeDir;
  final String outputDir;

  KeyGenerator(this.localeDir, this.outputDir);

  Future<void> generate() async {
    final List<String> locales = [];
    final List<File> paths = [];
    final Directory providedDir = Directory(localeDir);
    final Directory absoluteOutputDir = Directory(outputDir).absolute;
    final List<FileSystemEntity> files = providedDir.listSync();
    final StringBuffer commonBuffer = StringBuffer();
    final StringBuffer stringClassesBuffer = StringBuffer();

    final File localeStringsFile =
        File("${absoluteOutputDir.path}/locale_strings.g.dart");

    for (var element in files) {
      if (element is File) {
        final String locale = getNameFromPath(element.path);
        locales.add(locale);
        paths.add(element);
      }
    }

    final String locale = locales[0];
    final File path = paths[0];
    final Map<String, Map<String, StringInfo>> result =
        await XmlFileParser.loadWithStringInfo(path, locale);

    commonBuffer.writeln("// @dart=2.12");
    commonBuffer.writeln();
    commonBuffer
        .writeln("import 'package:easy_localization/easy_localization.dart';");
    commonBuffer.writeln();
    commonBuffer.writeln("class LocaleStrings {");
    commonBuffer.writeln("  LocaleStrings._();");
    commonBuffer.writeln();

    result.forEach((routeFile, keyStringInfo) {
      final StringBuffer currentBuffer = StringBuffer();
      final String recasedRouteFile = ReCase(routeFile).camelCase;

      currentBuffer.writeln("class ${getClassNameFromRouteFile(routeFile)} {");
      keyStringInfo.forEach((key, stringInfo) {
        if (stringInfo is CommonString) {
          final String varName = ReCase(key).camelCase;
          currentBuffer
              .writeln("  final String $varName = \"$routeFile.$key\".tr();");
        } else if (stringInfo is PluralString) {
          final String varName = ReCase(key).camelCase;
          currentBuffer.writeln(
              "  String $varName(num value) => \"$routeFile.$key\".plural(value);");
        } else if (stringInfo is ArgumentString) {
          final String varName = ReCase(key).camelCase;
          final int argNum = stringInfo.argNum;
          final List<String> args = [];
          String string = "";

          string += "  String $varName(";
          for (int i = 0; i < argNum; i++) {
            args.add("arg${i + 1}.toString()");
            if (i == argNum - 1) {
              string += "Object arg${i + 1}) => ";
            } else {
              string += "Object arg${i + 1}, ";
            }
          }
          string += "\"$routeFile.$key\".tr(args: [${args.join(", ")}]);";
          currentBuffer.writeln(string);
        }
      });
      currentBuffer.writeln("}");
      stringClassesBuffer.writeln(currentBuffer.toString());

      final String className = getClassNameFromRouteFile(routeFile);
      commonBuffer.writeln(
          "  static $className get $recasedRouteFile => $className();");
    });
    commonBuffer.writeln("}");

    await localeStringsFile.writeAsString(
        commonBuffer.toString() + "\n" + stringClassesBuffer.toString());
  }
}

String getNameFromPath(String path) {
  return path.split("/").last;
}

String getClassNameFromLocale(String locale) {
  return "_\$Locale${ReCase(locale).pascalCase}";
}

String getClassNameFromRouteFile(String routeFile) {
  return "_\$${ReCase(routeFile).pascalCase}LocaleStrings";
}
