import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Widget icon;
  final Widget activeIcon;
  final Widget title;
  final bool showTitle;
  final void Function() onTap;
  final bool active;
  final double height;
  final ShapeBorder activeShape;
  final EdgeInsets activeShapePadding;
  final Color activeColor;

  DrawerListTile({
    @required this.icon,
    this.activeIcon,
    @required this.title,
    this.showTitle = true,
    this.onTap,
    this.active = false,
    this.height = 56,
    this.activeShape,
    this.activeShapePadding =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    Color contrast = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData iconTheme = Theme.of(context).iconTheme;
    Color _activeColor = activeColor ?? Theme.of(context).accentColor;
    ShapeBorder _activeShape = activeShape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        );

    return SizedBox(
      height: height,
      child: showTitle
          ? Stack(
              children: <Widget>[
                Container(
                  margin: activeShapePadding,
                  decoration: ShapeDecoration(
                    shape: _activeShape,
                    color: active
                        ? _activeColor.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    leading: Theme(
                      data: Theme.of(context).copyWith(
                        iconTheme: iconTheme.copyWith(
                          color:
                              active ? _activeColor : contrast.withOpacity(0.7),
                        ),
                      ),
                      child: active ? (activeIcon ?? icon) : icon,
                    ),
                    title: DefaultTextStyle(
                      style: textTheme.bodyText1.copyWith(
                        color:
                            active ? _activeColor : contrast.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      child: title,
                    ),
                    onTap: onTap,
                    contentPadding: EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: iconTheme.copyWith(
                    color: active ? _activeColor : contrast.withOpacity(0.7),
                    size: 24,
                  ),
                ),
                child: active ? (activeIcon ?? icon) : icon,
              ),
              onPressed: onTap,
            ),
    );
  }
}

class DrawerListTileData {
  final Widget icon;
  final Widget activeIcon;
  final Widget title;

  DrawerListTileData({
    this.icon,
    this.activeIcon,
    this.title,
  });
}
