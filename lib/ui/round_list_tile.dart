import 'package:flutter/material.dart';

class RoundListTile extends StatelessWidget {
  final double height;
  final double borderRadius;
  final double endMargin;
  final double topBottomMargin;
  final bool selected;
  final Color selectedColor;
  final Color splashColor;

  final Widget leading;
  final Widget title;
  final Function() onTap;
  final Function() onLongPress;

  RoundListTile({
    this.height = 60,
    this.borderRadius,
    this.endMargin = 8,
    this.topBottomMargin = 4,
    this.selected = false,
    this.selectedColor,
    this.splashColor,
    this.leading,
    this.title,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: endMargin),
      padding: EdgeInsets.symmetric(vertical: topBottomMargin),
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(borderRadius ?? height / 2),
                topRight: Radius.circular(borderRadius ?? height / 2),
              ),
              color: selected
                  ? (selectedColor ?? Theme.of(context).accentColor)
                  : Colors.transparent,
            ),
          ),
          InkWell(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(borderRadius ?? height / 2),
                topRight: Radius.circular(borderRadius ?? height / 2),
              ),
              splashColor: splashColor ?? Theme.of(context).splashColor,
              onTap: onTap,
              onLongPress: onLongPress,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: IconTheme(
                        data: IconThemeData(
                            color: selected
                                ? selectedColor ?? Theme.of(context).canvasColor
                                : Theme.of(context).iconTheme.color),
                        child: leading ?? const SizedBox(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: AnimatedDefaultTextStyle(
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? selectedColor ?? Theme.of(context).canvasColor
                                : Theme.of(context).textTheme.subhead.color),
                        duration: kThemeChangeDuration,
                        child: title,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
