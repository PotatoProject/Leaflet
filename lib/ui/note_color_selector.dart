import 'package:flutter/material.dart';
import 'package:potato_notes/internal/localizations.dart';

const double _kDialogCorners = 12.0;

class NoteColorSelector extends StatefulWidget {
  final int selectedColor;
  final void Function(int) onColorSelect;

  NoteColorSelector({@required this.selectedColor, this.onColorSelect});

  @override
  _NoteColorSelectorState createState() => _NoteColorSelectorState();
}

class _NoteColorSelectorState extends State<NoteColorSelector> {
  int rowsNumber = 0;

  @override
  Widget build(BuildContext context) {
    rowsNumber = (NoteColors.colorList(context).length / 4).ceil();
    double dialogPadding = MediaQuery.of(context).viewInsets.horizontal + 80.0;
    double boxWidth = MediaQuery.of(context).size.width - dialogPadding;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_kDialogCorners),
        topRight: Radius.circular(_kDialogCorners),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rowsNumber, (index) {
          return Row(
            children: List.generate(4, (sIndex) {
              return noteColorItem(sIndex + (4 * index), boxWidth / 4,
                  widget.selectedColor == (sIndex + (4 * index)));
            }),
          );
        }),
      ),
    );
  }

  Widget noteColorItem(int index, double size, bool selected) {
    Color getIconColor() {
      if (index == 0) {
        Brightness themeBrightness = Theme.of(context).brightness;

        if (themeBrightness == Brightness.light)
          return ThemeData.light().iconTheme.color;
        else
          return ThemeData.dark().iconTheme.color;
      } else {
        Color color = Color(NoteColors.colorList(context)[index]["hex"]);

        if (color.computeLuminance() > 0.5)
          return Colors.black;
        else
          return Colors.white;
      }
    }

    return Builder(
      builder: (context) {
        return Material(
          color: Color(NoteColors.colorList(context)[index]["hex"]),
          child: SizedBox.fromSize(
            size: Size.square(size),
            child: Tooltip(
              message: NoteColors.colorList(context)[index]["label"],
              child: InkWell(
                onTap: () => widget.onColorSelect(index),
                child: Center(
                  child: Visibility(
                    visible: selected,
                    child: Icon(
                      Icons.check,
                      color: getIconColor(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NoteColors {
  static List<Map<String, dynamic>> colorList(BuildContext context) => [
        NoteColors.none(context),
        NoteColors.orange(context),
        NoteColors.yellow(context),
        NoteColors.beige(context),
        NoteColors.purple(context),
        NoteColors.blue(context),
        NoteColors.pink(context),
        NoteColors.green(context),
      ];

  static Map<String, dynamic> none(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_none,
      "hex": 0x00000000,
    };
  }

  static Map<String, dynamic> orange(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_orange,
      "hex": 0xFFFFB182,
    };
  }

  static Map<String, dynamic> yellow(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_yellow,
      "hex": 0xFFFFF18E,
    };
  }

  static Map<String, dynamic> beige(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_beige,
      "hex": 0xFFFFE8D1,
    };
  }

  static Map<String, dynamic> purple(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_purple,
      "hex": 0xFFD8D4F2,
    };
  }

  static Map<String, dynamic> blue(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_blue,
      "hex": 0xFFB9D6F2,
    };
  }

  static Map<String, dynamic> pink(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_pink,
      "hex": 0xFFFFB8D1,
    };
  }

  static Map<String, dynamic> green(BuildContext context) {
    AppLocalizations locales = AppLocalizations.of(context);

    return {
      "label": locales.semantics_color_green,
      "hex": 0xFFBCFFC3,
    };
  }
}
