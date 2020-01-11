import 'package:flutter/material.dart';

class UserInfoListTile extends StatelessWidget {
  final EdgeInsets padding;
  final Color color;
  final Function onTap;
  final double height;
  final Widget icon;
  final Widget text;
  final Size iconSize;

  UserInfoListTile({
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.color = Colors.transparent,
    this.onTap,
    this.height = 50,
    this.icon,
    this.text,
    this.iconSize = const Size.square(44),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding,
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 6,
                  right: 20,
                ),
                child: SizedBox.fromSize(
                  size: iconSize,
                  child: Center(child: icon),
                ),
              ),
              text ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
