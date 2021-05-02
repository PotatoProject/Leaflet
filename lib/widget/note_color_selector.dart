import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class NoteColorSelector extends StatefulWidget {
  final int selectedColor;
  final void Function(int)? onColorSelect;

  const NoteColorSelector({required this.selectedColor, this.onColorSelect});

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
            context.notePalette.colors.length,
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
    required int index,
    required double size,
    required bool selected,
  }) {
    late Color iconColor;
    final Brightness themeBrightness = context.theme.brightness;

    if (themeBrightness == Brightness.light) {
      iconColor = ThemeData.light().iconTheme.color!;
    } else {
      iconColor = ThemeData.dark().iconTheme.color!;
    }

    return Builder(
      builder: (context) {
        return Material(
          color: context.notePalette.colors[index].color,
          child: SizedBox.fromSize(
            size: Size.square(size),
            child: Tooltip(
              message: context.notePalette.colors[index].label,
              child: InkWell(
                onTap: () => widget.onColorSelect?.call(index),
                child: Center(
                  child: Visibility(
                    visible: selected,
                    child: Icon(
                      Icons.check,
                      color: iconColor,
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
