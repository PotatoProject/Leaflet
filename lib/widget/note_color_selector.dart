import 'package:flutter/material.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/providers.dart';

class NoteColorSelector extends StatefulWidget {
  final int selectedColor;
  final void Function(int) onColorSelect;

  NoteColorSelector({@required this.selectedColor, this.onColorSelect});

  @override
  _NoteColorSelectorState createState() => _NoteColorSelectorState();
}

class _NoteColorSelectorState extends State<NoteColorSelector> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: List.generate(
            NoteColors.colorList.length,
            (index) => noteColorItem(
              index,
              constraints.maxWidth / (deviceInfo.uiSizeFactor + 3),
              widget.selectedColor == index,
            ),
          ),
        );
      },
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
        Color color = Color(NoteColors.colorList[index].dynamicColor(context));

        if (color.computeLuminance() > 0.5)
          return Colors.black;
        else
          return Colors.white;
      }
    }

    return Builder(
      builder: (context) {
        return Material(
          color: Color(NoteColors.colorList[index].dynamicColor(context)),
          child: SizedBox.fromSize(
            size: Size.square(size),
            child: Tooltip(
              message: NoteColors.colorList[index].label,
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
