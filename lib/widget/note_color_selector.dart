import 'package:flutter/material.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/utils.dart';

class NoteColorSelector extends StatefulWidget {
  final int selectedColor;
  final void Function(int) onColorSelect;

  const NoteColorSelector({@required this.selectedColor, this.onColorSelect});

  @override
  _NoteColorSelectorState createState() => _NoteColorSelectorState();
}

class _NoteColorSelectorState extends State<NoteColorSelector> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          children: List.generate(
            NoteColors.colorList.length,
            (index) => noteColorItem(
              index: index,
              size: constraints.maxWidth / 5,
              selected: widget.selectedColor == index,
            ),
          ),
        );
      },
    );
  }

  Widget noteColorItem({
    @required int index,
    @required double size,
    @required bool selected,
  }) {
    Color getIconColor() {
      if (index == 0) {
        final Brightness themeBrightness = context.theme.brightness;

        if (themeBrightness == Brightness.light) {
          return ThemeData.light().iconTheme.color;
        } else {
          return ThemeData.dark().iconTheme.color;
        }
      } else {
        final Color color =
            Color(NoteColors.colorList[index].dynamicColor(context));

        if (color.computeLuminance() > 0.5) {
          return Colors.black;
        } else {
          return Colors.white;
        }
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
