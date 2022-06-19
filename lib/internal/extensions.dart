import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:liblymph/database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/selection_state.dart';
import 'package:potato_notes/internal/theme/colors.dart';
import 'package:potato_notes/internal/theme/data.dart';
import 'package:potato_notes/internal/theme/theme.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:recase/recase.dart';

extension NoteX on Note {
  static Note get emptyNote => Note(
        id: "",
        title: "",
        content: "",
        starred: false,
        creationDate: DateTime.now(),
        color: 0,
        images: [],
        list: false,
        listContent: [],
        reminders: [],
        tags: [],
        hideContent: false,
        lockNote: false,
        usesBiometrics: false,
        folder: BuiltInFolders.home.id,
        lastChanged: DateTime.now(),
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
          final List<String> images = list.map((i) => i.toString()).toList();
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
    Map<String, dynamic> original,
  ) {
    final Map<String, dynamic> derivated = Map.from(original);
    derivated.putIfAbsent('id', () => '');
    derivated.putIfAbsent('title', () => '');
    derivated.putIfAbsent('content', () => '');
    derivated.putIfAbsent('styleJson', () => []);
    derivated.putIfAbsent('starred', () => false);
    derivated.putIfAbsent('creationDate', () => DateTime.now());
    derivated.putIfAbsent('lastChanged', () => DateTime.now());
    derivated.putIfAbsent('color', () => 0);
    derivated.putIfAbsent('images', () => []);
    derivated.putIfAbsent('list', () => false);
    derivated.putIfAbsent('listContent', () => []);
    derivated.putIfAbsent('reminders', () => []);
    derivated.putIfAbsent('tags', () => []);
    derivated.putIfAbsent('hideContent', () => false);
    derivated.putIfAbsent('lockNote', () => false);
    derivated.putIfAbsent('usesBiometrics', () => false);
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
            final List<String> images = Utils.asList<String>(value);
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
    return copyWith(lastChanged: DateTime.now());
  }

  int get notificationId =>
      int.parse(id.split("-")[0], radix: 16).toUnsigned(31);

  bool get pinned {
    return appInfo.activeNotifications.any(
      (e) => e.id == notificationId,
    );
  }

  UnmodifiableNoteView get view => UnmodifiableNoteView(note: this);

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
    return copyWith(lastChanged: DateTime.now());
  }
}

extension NoteImageX on NoteImage {
  Size get size => Size(width.toDouble(), height.toDouble());
  bool get existsLocally => File(path).existsSync();
  String get path => join(appDirectories.imagesDirectory.path, "$id$type");
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

extension ListX<T> on List<T> {
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

  //BasePageState? get basePage => BasePage.maybeOf(this);
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

extension BrightnessX on Brightness {
  Brightness get reverse {
    switch (this) {
      case Brightness.light:
        return Brightness.dark;
      case Brightness.dark:
        return Brightness.light;
    }
  }
}

extension OutlinedBorderX on OutlinedBorder {
  OutlinedBorder excludeCorners({
    bool excludeTopStart = false,
    bool excludeTopEnd = false,
    bool excludeBottomStart = false,
    bool excludeBottomEnd = false,
  }) {
    if (this is RoundedRectangleBorder) {
      final RoundedRectangleBorder shape = this as RoundedRectangleBorder;
      return shape.copyWith(
        borderRadius: shape.borderRadius.excludeCorners(
          excludeTopStart: excludeTopStart,
          excludeTopEnd: excludeTopEnd,
          excludeBottomStart: excludeBottomStart,
          excludeBottomEnd: excludeBottomEnd,
        ),
      );
    }

    if (this is BeveledRectangleBorder) {
      final BeveledRectangleBorder shape = this as BeveledRectangleBorder;
      return shape.copyWith(
        borderRadius: shape.borderRadius.excludeCorners(
          excludeTopStart: excludeTopStart,
          excludeTopEnd: excludeTopEnd,
          excludeBottomStart: excludeBottomStart,
          excludeBottomEnd: excludeBottomEnd,
        ),
      );
    }

    if (this is ContinuousRectangleBorder) {
      final ContinuousRectangleBorder shape = this as ContinuousRectangleBorder;
      return shape.copyWith(
        borderRadius: shape.borderRadius.excludeCorners(
          excludeTopStart: excludeTopStart,
          excludeTopEnd: excludeTopEnd,
          excludeBottomStart: excludeBottomStart,
          excludeBottomEnd: excludeBottomEnd,
        ),
      );
    }

    return this;
  }
}

extension BorderRadiusGeometryX on BorderRadiusGeometry {
  BorderRadiusGeometry excludeCorners({
    bool excludeTopStart = false,
    bool excludeTopEnd = false,
    bool excludeBottomStart = false,
    bool excludeBottomEnd = false,
  }) {
    if (this is BorderRadius) {
      final BorderRadius border = this as BorderRadius;
      return border.copyWith(
        topLeft: !excludeTopStart ? border.topLeft : Radius.zero,
        topRight: !excludeTopEnd ? border.topRight : Radius.zero,
        bottomLeft: !excludeBottomStart ? border.bottomLeft : Radius.zero,
        bottomRight: !excludeBottomEnd ? border.bottomRight : Radius.zero,
      );
    }

    if (this is BorderRadiusDirectional) {
      final BorderRadiusDirectional border = this as BorderRadiusDirectional;
      return border.copyWith(
        topStart: !excludeTopStart ? border.topStart : Radius.zero,
        topEnd: !excludeTopEnd ? border.topEnd : Radius.zero,
        bottomStart: !excludeBottomStart ? border.bottomStart : Radius.zero,
        bottomEnd: !excludeBottomEnd ? border.bottomEnd : Radius.zero,
      );
    }

    return this;
  }

  BorderRadiusGeometry borderCopyWith({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    if (this is BorderRadius) {
      return (this as BorderRadius).copyWith(
        topLeft: topStart,
        topRight: topEnd,
        bottomLeft: bottomStart,
        bottomRight: bottomEnd,
      );
    }

    if (this is BorderRadiusDirectional) {
      return (this as BorderRadiusDirectional).copyWith(
        topStart: topStart,
        topEnd: topEnd,
        bottomStart: bottomStart,
        bottomEnd: bottomEnd,
      );
    }

    return this;
  }
}

extension BorderRadiusDirectionalX on BorderRadiusDirectional {
  BorderRadiusDirectional copyWith({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    return BorderRadiusDirectional.only(
      topStart: topStart ?? this.topStart,
      topEnd: topEnd ?? this.topEnd,
      bottomStart: bottomStart ?? this.bottomStart,
      bottomEnd: bottomEnd ?? this.bottomEnd,
    );
  }
}

extension DynamicX on dynamic {
  T toType<T>() {
    return this as T;
  }
}

extension ColorX on Color {
  Color get contrasting {
    if (ThemeData.estimateBrightnessForColor(this) == Brightness.light) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
