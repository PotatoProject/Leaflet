import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class AndroidXmlAssetLoader extends AssetLoader {
  final List<String> routeFiles;

  const AndroidXmlAssetLoader(this.routeFiles);

  String getLocalePath(String basePath, String routeFile, Locale locale) {
    return '$basePath/${localeToString(locale, separator: "-")}/$routeFile.xml';
  }

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    Map<String, dynamic> returnMap = {};

    for (String routeFile in routeFiles) {
      var localePath = getLocalePath(path, routeFile, locale);
      var document = XmlDocument.parse(await rootBundle.loadString(localePath));
      document.normalize();

      XmlElement base = document.lastElementChild;

      for (XmlNode item in base.children) {
        if (item is XmlElement) {
          XmlElement element = item;

          String name = element.getAttribute("name");
          if (name == null) continue;

          if (element.name.toString() == "string") {
            returnMap["$routeFile.$name"] = replacer(element.text);
          } else if (element.name.toString() == "plurals") {
            for (XmlNode plural in element.children) {
              if (plural is XmlElement) {
                XmlElement pluralElement = plural;

                String pluralAttribute = pluralElement.getAttribute("quantity");
                if (pluralAttribute == null) continue;

                returnMap["$routeFile.$name.$pluralAttribute"] =
                    replacer(pluralElement.text);
              }
            }
          }
        }
      }
    }

    return returnMap;
  }

  String replacer(String base) {
    return base
        .replaceAll("%s", "{}")
        .replaceAll("\\\"", "\"")
        .replaceAll("\\\'", "\'");
  }
}
