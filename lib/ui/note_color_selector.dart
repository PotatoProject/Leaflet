import 'package:flutter/material.dart';
import 'package:potato_notes/ui/themes.dart';

const double _kDialogCorners = 12.0;

class NoteColorSelector extends StatefulWidget {
  final int selectedColor;
  final void Function(int) onColorSelect;

  NoteColorSelector({@required this.selectedColor, this.onColorSelect});

  @override
  _NoteColorSelectorState createState() => _NoteColorSelectorState();
}

class _NoteColorSelectorState extends State<NoteColorSelector> {
  int get rowsNumber => (NoteColors.colorList.length / 4).ceil();

  @override
  Widget build(BuildContext context) {
    double dialogPadding = MediaQuery.of(context).viewInsets.horizontal + 80.0;
    double boxWidth = MediaQuery.of(context).size.width - dialogPadding;

    print(widget.selectedColor);

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
      if(index == 0) {
        Brightness themeBrightness = Theme.of(context).brightness;

        if(themeBrightness == Brightness.light)
          return ThemeData.light().iconTheme.color;
        else
          return ThemeData.dark().iconTheme.color;
      } else {
        Color color = Color(NoteColors.colorList[index]["hex"]);

        if (color.computeLuminance() > 0.5)
          return Colors.black;
        else
          return Colors.white;
      }
    }

    return Builder(
      builder: (context) {
        return Material(
          color: Color(NoteColors.colorList[index]["hex"]),
          child: SizedBox.fromSize(
            size: Size.square(size),
            child: Tooltip(
              message: NoteColors.colorList[index]["label"],
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
  static List<Map<String, dynamic>> get colorList => [
        NoteColors.none,
        NoteColors.orange,
        NoteColors.yellow,
        NoteColors.beige,
        NoteColors.purple,
        NoteColors.blue,
        NoteColors.pink,
        NoteColors.green,
      ];

  static Map<String, dynamic> get none => {
        "label": "None",
        "hex": 0x00000000,
      };

  static Map<String, dynamic> get orange => {
        "label": "Orange",
        "hex": 0xFFFFB182,
      };

  static Map<String, dynamic> get yellow => {
        "label": "Yellow",
        "hex": 0xFFFFF18E,
      };

  static Map<String, dynamic> get beige =>
      {"label": "Beige", "hex": 0xFFFFE8D1};

  static Map<String, dynamic> get purple => {
        "label": "Purple",
        "hex": 0xFFD8D4F2,
      };

  static Map<String, dynamic> get blue => {
        "label": "Blue",
        "hex": 0xFFB9D6F2,
      };

  static Map<String, dynamic> get pink => {
        "label": "Pink",
        "hex": 0xFFFFB8D1,
      };

  static Map<String, dynamic> get green => {
        "label": "Green",
        "hex": 0xFFBCFFC3,
      };
}
