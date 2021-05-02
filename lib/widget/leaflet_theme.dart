import 'package:flutter/cupertino.dart';
import 'package:potato_notes/internal/note_color_palette.dart';
import 'package:potato_notes/widget/illustrations.dart';

class LeafletTheme extends StatelessWidget {
  final Widget child;
  final LeafletThemeData data;

  const LeafletTheme({
    required this.child,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _LeafletThemeInheritedWidget(
      data: data,
      child: child,
    );
  }

  static LeafletThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LeafletThemeInheritedWidget>()!
        .data;
  }

  static LeafletThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LeafletThemeInheritedWidget>()
        ?.data;
  }
}

class LeafletThemeData {
  final NoteColorPalette notePalette;
  final IllustrationPalette illustrationPalette;

  const LeafletThemeData({
    required this.notePalette,
    required this.illustrationPalette,
  });

  @override
  bool operator ==(Object? other) {
    if (other is LeafletThemeData) {
      return notePalette == other.notePalette &&
          illustrationPalette == other.illustrationPalette;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(notePalette, illustrationPalette);
}

class _LeafletThemeInheritedWidget extends InheritedWidget {
  final LeafletThemeData data;

  const _LeafletThemeInheritedWidget({
    required this.data,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant _LeafletThemeInheritedWidget old) {
    return data != old.data;
  }
}
