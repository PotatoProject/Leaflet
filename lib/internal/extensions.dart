import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/note_color_palette.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/selection_state.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/leaflet_theme.dart';
import 'package:recase/recase.dart';

extension NoteX on Note {
  static Note get emptyNote => Note(
        id: "",
        title: "",
        content: "",
        starred: false,
        creationDate: DateTime.now(),
        lastModifyDate: DateTime.now(),
        color: 0,
        images: [],
        list: false,
        listContent: [],
        reminders: [],
        tags: [],
        hideContent: false,
        lockNote: false,
        usesBiometrics: false,
        deleted: false,
        archived: false,
        synced: false,
      );

  static Note fromSyncMap(Map<String, dynamic> syncMap) {
    final Map<String, dynamic> newMap = {};
    syncMap.forEach((key, value) {
      Object? newValue = value;
      String newKey = ReCase(key).camelCase;
      switch (key) {
        case "style_json":
          final List<int> map = Utils.asList<int>(
            json.decode(value.toString()),
          );
          final List<int> data = List<int>.from(map.map((i) => i)).toList();
          newValue = data;
          break;
        case "images":
          final List<Map<String, dynamic>> list =
              Utils.asList<Map<String, dynamic>>(
            json.decode(value.toString()),
          );
          final List<SavedImage> images =
              list.map((i) => SavedImage.fromJson(i)).toList();
          newValue = images;
          break;
        case "list_content":
          final List<Map<String, dynamic>> map =
              Utils.asList<Map<String, dynamic>>(
            json.decode(value.toString()),
          );
          final List<ListItem> content = Utils.asList<ListItem>(
            map.map((i) => ListItem.fromJson(i)).toList(),
          );
          newValue = content;
          break;
        case "reminders":
          final List<String> map =
              Utils.asList<String>(json.decode(value.toString()));
          final List<DateTime> reminders = Utils.asList<DateTime>(
            map.map((i) => DateTime.parse(i)).toList(),
          );
          newValue = reminders;
          break;
        case "tags":
          final List<String> map = Utils.asList<String>(
            json.decode(value.toString()),
          );
          newValue = map;
          break;
        case "note_id":
          newKey = "id";
          break;
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });

    return Note.fromJson(fillInMissingFields(newMap));
  }

  static Map<String, dynamic> fillInMissingFields(
      Map<String, dynamic> original) {
    final Map<String, dynamic> derivated = Map.from(original);
    derivated.putIfAbsent('id', () => '');
    derivated.putIfAbsent('title', () => '');
    derivated.putIfAbsent('content', () => '');
    derivated.putIfAbsent('styleJson', () => []);
    derivated.putIfAbsent('starred', () => false);
    derivated.putIfAbsent('creationDate', () => DateTime.now());
    derivated.putIfAbsent('lastModifyDate', () => DateTime.now());
    derivated.putIfAbsent('color', () => 0);
    derivated.putIfAbsent('images', () => []);
    derivated.putIfAbsent('list', () => false);
    derivated.putIfAbsent('listContent', () => []);
    derivated.putIfAbsent('reminders', () => []);
    derivated.putIfAbsent('tags', () => []);
    derivated.putIfAbsent('hideContent', () => false);
    derivated.putIfAbsent('lockNote', () => false);
    derivated.putIfAbsent('usesBiometrics', () => false);
    derivated.putIfAbsent('deleted', () => false);
    derivated.putIfAbsent('archived', () => false);
    derivated.putIfAbsent('synced', () => false);
    return derivated;
  }

  bool get isEmpty {
    final bool titleEmpty = title.isEmpty;
    final bool contentEmpty = content.isEmpty;
    final bool imagesEmpty = images.isEmpty;
    final bool listContentEmpty = listContent.isEmpty;
    final bool listContentItemsEmpty = listContent.every(
      (element) => element.text.trim().isEmpty,
    );

    return titleEmpty &&
        contentEmpty &&
        imagesEmpty &&
        (listContentEmpty || listContentItemsEmpty);
  }

  Map<String, dynamic> toSyncMap() {
    final Map<String, dynamic> originalMap = toJson();
    final Map<String, dynamic> newMap = {};
    originalMap.forEach((key, value) {
      Object? newValue = value;
      String newKey = key.snakeCase;
      switch (key) {
        case "styleJson":
          {
            final List<int> style = Utils.asList<int>(value);
            newValue = json.encode(style);
            break;
          }
        case "images":
          {
            final List<SavedImage> images = Utils.asList<SavedImage>(value);
            newValue = json.encode(images);
            break;
          }
        case "listContent":
          {
            final List<ListItem> listContent = Utils.asList<ListItem>(value);
            newValue = json.encode(listContent);
            break;
          }
        case "reminders":
          {
            final List<DateTime> reminders = Utils.asList<DateTime>(value);
            newValue = json.encode(reminders);
            break;
          }
        case "tags":
          {
            final List<String> tags = Utils.asList<String>(value);
            newValue = json.encode(tags);
            break;
          }
      }
      if (key == "id") {
        newKey = "note_id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return newMap;
  }

  Note markChanged() {
    return copyWith(synced: false, lastModifyDate: DateTime.now());
  }

  int get notificationId =>
      int.parse(id.split("-")[0], radix: 16).toUnsigned(31);

  bool get pinned {
    return appInfo.activeNotifications.any(
      (e) => e.id == notificationId,
    );
  }

  List<String> getActualTags({List<Tag>? overrideTags}) {
    final List<String> actualTags = [];
    final List<Tag> providedTags = overrideTags ?? prefs.tags;
    for (final String tag in tags) {
      final Tag? actualTag = providedTags.firstWhereOrNull(
        (t) => t.id == tag,
      );
      if (actualTag != null) actualTags.add(actualTag.id);
    }
    return actualTags;
  }
}

extension TagX on Tag {
  Tag markChanged() {
    return copyWith(lastModifyDate: DateTime.now());
  }
}

extension PackageInfoX on PackageInfo {
  int get buildNumberInt {
    // This terrible hack is necessary on windows because of a bug on
    // package_info_plus where each field gets a null character
    // appended at the end
    final String cleanBuildNumber = buildNumber.replaceAll('\u0000', '');
    return int.tryParse(cleanBuildNumber) ?? -1;
  }
}

extension UriX on Uri {
  ImageProvider toImageProvider() {
    if (data != null) {
      return MemoryImage(data!.contentAsBytes());
    } else if (scheme.startsWith("http") || scheme.startsWith("blob")) {
      return NetworkImage(toString());
    } else {
      return FileImage(File(path));
    }
  }
}

extension ResponseX on Response {
  dynamic get bodyJson {
    try {
      return json.decode(body);
    } on FormatException {
      return body;
    }
  }
}

extension SafeGetList<T> on List<T> {
  T get(int index) {
    if (index >= length) {
      return last;
    } else {
      return this[index];
    }
  }

  T? maybeGet(int index) {
    if (index >= length) {
      return null;
    } else {
      return this[index];
    }
  }

  Iterable<T> safeWhere(bool Function(T) test) {
    try {
      return where(test);
    } on StateError {
      return [];
    }
  }
}

extension ContextProviders on BuildContext {
  ThemeData get theme => Theme.of(this);
  LeafletThemeData get leafletTheme => LeafletTheme.of(this);
  NoteColorPalette get notePalette => leafletTheme.notePalette;
  IllustrationPalette get illustrationPalette =>
      leafletTheme.illustrationPalette;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get mSize => mediaQuery.size;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsetsDirectional get viewPaddingDirectional {
    switch (directionality) {
      case TextDirection.ltr:
        return EdgeInsetsDirectional.fromSTEB(
          viewPadding.left,
          viewPadding.top,
          viewPadding.right,
          viewPadding.bottom,
        );
      case TextDirection.rtl:
        return EdgeInsetsDirectional.fromSTEB(
          viewPadding.right,
          viewPadding.top,
          viewPadding.left,
          viewPadding.bottom,
        );
    }
  }

  BasePageState? get basePage => BasePage.maybeOf(this);
  TextDirection get directionality => Directionality.of(this);

  NavigatorState get navigator => Navigator.of(this);
  void pop<T extends Object?>([T? result]) => navigator.pop<T?>(result);
  Future<T?> push<T extends Object?>(Route<T> route) =>
      navigator.push<T?>(route);

  SelectionState get selectionState => SelectionState.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  DismissibleRouteState? get dismissibleRoute => DismissibleRoute.maybeOf(this);

  OverlayState? get overlay => Overlay.of(this);
}

extension NoteColorX on NoteColor {
  String get label {
    switch (type) {
      case NoteColorType.empty:
        return LocaleStrings.common.colorNone;
      case NoteColorType.red:
        return LocaleStrings.common.colorRed;
      case NoteColorType.orange:
        return LocaleStrings.common.colorOrange;
      case NoteColorType.yellow:
        return LocaleStrings.common.colorYellow;
      case NoteColorType.green:
        return LocaleStrings.common.colorGreen;
      case NoteColorType.cyan:
        return LocaleStrings.common.colorCyan;
      case NoteColorType.lightBlue:
        return LocaleStrings.common.colorLightBlue;
      case NoteColorType.blue:
        return LocaleStrings.common.colorBlue;
      case NoteColorType.purple:
        return LocaleStrings.common.colorPurple;
      case NoteColorType.pink:
        return LocaleStrings.common.colorPink;
    }
  }
}
