import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RGBColorPicker extends StatefulWidget {
  final Color initialColor;

  RGBColorPicker({
    this.initialColor = const Color(0xFFFF0000),
  });

  @override
  _RGBColorPickerState createState() => _RGBColorPickerState();
}

class _RGBColorPickerState extends State<RGBColorPicker> {
  Color currentColor;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    controller = TextEditingController(
        text:
            currentColor.value.toRadixString(16).substring(2, 8).toUpperCase());
  }

  @override
  void setState(fn) {
    super.setState(fn);
    controller.text =
        currentColor.value.toRadixString(16).substring(2, 8).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Theme(
      data: Theme.of(context).copyWith(
        cursorColor:
            currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        textSelectionHandleColor:
            currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        textSelectionColor: (currentColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white)
            .withOpacity(0.4),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "#",
                          style: TextStyle(
                            color: currentColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: TextField(
                            controller: controller,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(
                                  RegExp("[0-9|A-F|a-f]")),
                              LengthLimitingTextInputFormatter(6)
                            ],
                            onChanged: (text) {
                              if (text.length == 6) {
                                Color newColor =
                                    Color(int.parse(text, radix: 16));
                                setState(() =>
                                    currentColor = newColor.withAlpha(0xFF));
                              }
                            },
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            style: TextStyle(
                                color: currentColor.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: shortestSide / 2,
                    width: shortestSide / 2,
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ColorSlider(
                          color: currentColor,
                          onChange: (newColor) {
                            setState(() => currentColor = newColor);
                          },
                          rgb: RGB.RED,
                        ),
                        ColorSlider(
                          color: currentColor,
                          onChange: (newColor) {
                            setState(() => currentColor = newColor);
                          },
                          rgb: RGB.GREEN,
                        ),
                        ColorSlider(
                          color: currentColor,
                          onChange: (newColor) {
                            setState(() => currentColor = newColor);
                          },
                          rgb: RGB.BLUE,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context, -1),
                  textColor: currentColor,
                  child: Text("Reset"),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  textColor: currentColor,
                  child: Text("Cancel"),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(context, currentColor.value),
                  textColor: currentColor,
                  child: Text("Confirm"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorSlider extends StatelessWidget {
  final Color color;
  final Function(Color) onChange;
  final RGB rgb;

  ColorSlider({
    @required this.color,
    @required this.onChange,
    @required this.rgb,
  });

  @override
  Widget build(BuildContext context) {
    Color widgetColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 0),
          child: SizedBox.fromSize(
            size: Size.square(24),
            child: Center(
              child: Text(
                rgb == RGB.RED ? "R" : rgb == RGB.GREEN ? "G" : "B",
                style: TextStyle(
                  color: widgetColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(),
            child: Slider(
              activeColor: widgetColor,
              inactiveColor: widgetColor.withOpacity(0.4),
              max: 255,
              min: 0,
              value: (rgb == RGB.RED
                      ? color.red
                      : rgb == RGB.GREEN ? color.green : color.blue)
                  .toDouble(),
              onChanged: (value) => onChange(
                rgb == RGB.RED
                    ? color.withRed(value.toInt())
                    : rgb == RGB.GREEN
                        ? color.withGreen(value.toInt())
                        : color.withBlue(value.toInt()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

enum RGB { RED, GREEN, BLUE }
