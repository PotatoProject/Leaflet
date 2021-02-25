import 'dart:io';

import 'package:xml/xml.dart';

void main(List<String> args) async {
  if (args.isEmpty || args.length != 1) {
    print("Usage: dart bin/svg_to_pathinfo.dart <svg file>");
    return;
  }

  print(await xmlToFile(File(args[0])));
}

Future<String> xmlToFile(File file) async {
  StringBuffer fileContent = StringBuffer();
  final String xmlContent = await file.readAsString();
  final XmlDocument document = XmlDocument.parse(xmlContent);
  document.normalize();

  final XmlElement base = document.lastElementChild;
  final String width = base.getAttribute("width");
  final String height = base.getAttribute("height");

  fileContent.writeln('PathInfo(');
  fileContent.writeln('  name: "${getNameFromPath(file.path)}",');
  fileContent.writeln('  size: Size($width, $height),');
  fileContent.writeln('  data: [');

  for (XmlNode item in base.children) {
    if (item is XmlElement) {
      final XmlElement element = item;

      final String path = element.getAttribute("d");
      final String color = element.getAttribute("fill");
      final String colorString = getStringFromColor(color);
      final String opacity = element.getAttribute("opacity");
      final String opacityString =
          opacity != null ? ".withOpacity($opacity)" : "";
      if (path == null) continue;

      StringBuffer pathDataBuffer = StringBuffer();
      pathDataBuffer.writeln('    PathData(');
      pathDataBuffer.writeln('      path: "$path",');
      if (color != null)
        pathDataBuffer.writeln('      color: $colorString$opacityString,');
      pathDataBuffer.writeln('    ),');
      fileContent.write(pathDataBuffer.toString());
    }
  }
  fileContent.writeln('  ],');
  fileContent.writeln(');');

  return fileContent.toString();
}

String getStringFromColor(String color) {
  switch (color) {
    case "#FF0000":
      return "palette.invertedContrast";
    case "#00FF00":
      return "palette.contrast";
    case "#0000FF":
    default:
      return "palette.base";
  }
}

String getNameFromPath(String path) {
  final List<String> splitPath =
      Platform.isWindows ? path.split("\\") : path.split("/");
  return splitPath.last.split(".").first;
}
