import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class RGBColorPicker extends StatefulWidget {
  final Color initialColor;

  const RGBColorPicker({
    this.initialColor = const Color(0xFFFF0000),
  });

  @override
  _RGBColorPickerState createState() => _RGBColorPickerState();
}

class _RGBColorPickerState extends State<RGBColorPicker> {
  late Color currentColor;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    controller = TextEditingController(
      text: currentColor.value.toRadixString(16).substring(2, 8).toUpperCase(),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    controller.text =
        currentColor.value.toRadixString(16).substring(2, 8).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      content: Theme(
        data: context.theme.copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: currentColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
            selectionHandleColor: currentColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
            selectionColor: (currentColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white)
                .withOpacity(0.4),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double shortestSide = constraints.maxWidth;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: currentColor,
                  width: shortestSide,
                  height: shortestSide / 2,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: shortestSide / 2,
                        width: shortestSide / 2,
                        alignment: Alignment.center,
                        child: IntrinsicWidth(
                          child: TextField(
                            controller: controller,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("[0-9|A-F|a-f]"),
                              ),
                              LengthLimitingTextInputFormatter(6),
                            ],
                            onChanged: (text) {
                              if (text.length == 6) {
                                final Color newColor =
                                    Color(int.parse(text, radix: 16));
                                setState(
                                  () => currentColor = newColor.withAlpha(0xFF),
                                );
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixText: "#",
                              prefixStyle: TextStyle(
                                color: currentColor.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            style: TextStyle(
                              color: currentColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: shortestSide / 2,
                        width: shortestSide / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ColorSlider(
                              color: currentColor,
                              onChange: (newColor) {
                                setState(() => currentColor = newColor);
                              },
                              rgb: RGB.red,
                            ),
                            ColorSlider(
                              color: currentColor,
                              onChange: (newColor) {
                                setState(() => currentColor = newColor);
                              },
                              rgb: RGB.green,
                            ),
                            ColorSlider(
                              color: currentColor,
                              onChange: (newColor) {
                                setState(() => currentColor = newColor);
                              },
                              rgb: RGB.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        TextButton(
          onPressed: () => context.pop(-1),
          child: Text(strings.common.reset),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(strings.common.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(currentColor.value),
          child: Text(strings.common.confirm),
        ),
      ],
    );
  }
}

class ColorSlider extends StatelessWidget {
  final Color color;
  final Function(Color) onChange;
  final RGB rgb;

  const ColorSlider({
    required this.color,
    required this.onChange,
    required this.rgb,
  });

  @override
  Widget build(BuildContext context) {
    final Color widgetColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.zero,
          child: SizedBox.fromSize(
            size: const Size.square(24),
            child: Center(
              child: Text(
                rgb == RGB.red
                    ? "R"
                    : rgb == RGB.green
                        ? "G"
                        : "B",
                style: TextStyle(
                  color: widgetColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Slider(
            activeColor: widgetColor,
            inactiveColor: widgetColor.withOpacity(0.4),
            max: 255,
            value: (rgb == RGB.red
                    ? color.red
                    : rgb == RGB.green
                        ? color.green
                        : color.blue)
                .toDouble(),
            onChanged: (value) => onChange(
              rgb == RGB.red
                  ? color.withRed(value.toInt())
                  : rgb == RGB.green
                      ? color.withGreen(value.toInt())
                      : color.withBlue(value.toInt()),
            ),
          ),
        ),
      ],
    );
  }
}

enum RGB { red, green, blue }
