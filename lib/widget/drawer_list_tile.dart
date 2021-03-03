import 'package:flutter/material.dart';
import 'package:potato_notes/internal/utils.dart';

class DrawerListTile extends StatefulWidget {
  final Widget icon;
  final Widget activeIcon;
  final Text title;
  final bool showTitle;
  final void Function() onTap;
  final bool active;

  DrawerListTile({
    @required this.icon,
    this.activeIcon,
    @required this.title,
    this.showTitle = true,
    this.onTap,
    this.active = false,
  });

  @override
  _DrawerListTileState createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile>
    with SingleTickerProviderStateMixin {
  AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(covariant DrawerListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.showTitle != widget.showTitle) {
      _ac.animateTo(widget.showTitle ? 1 : 0);
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color contrast = context.theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final TextTheme textTheme = context.theme.textTheme;
    final IconThemeData iconTheme = context.theme.iconTheme;
    final Color _activeColor = context.theme.accentColor;
    final VisualDensity visualDensity = context.theme.visualDensity;
    final Offset baseDensity = visualDensity.baseSizeAdjustment;
    final double height = 56 + baseDensity.dy;

    final Animation<double> _curvedAc = CurvedAnimation(
      parent: _ac,
      curve: decelerateEasing,
    );

    final Widget child = Row(
      children: [
        Theme(
          data: context.theme.copyWith(
            iconTheme: iconTheme.copyWith(
              color: widget.active ? _activeColor : contrast.withOpacity(0.7),
              size: 24,
            ),
          ),
          child:
              widget.active ? (widget.activeIcon ?? widget.icon) : widget.icon,
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _ac,
            builder: (context, _) {
              return ClipRect(
                child: Align(
                  alignment: AlignmentDirectional(-1, 0),
                  widthFactor: _curvedAc.value,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        width: 24,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: DefaultTextStyle(
                          style: textTheme.bodyText1.copyWith(
                            color: widget.active
                                ? _activeColor
                                : contrast.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          child: widget.title,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget parent = InkWell(
          onTap: widget.onTap,
          child: Container(
            height: height,
            width: constraints.maxWidth,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        );
        return !widget.showTitle
            ? Tooltip(message: widget.title.data, child: parent)
            : parent;
      },
    );
  }
}

@immutable
class DrawerListTileData {
  final Widget icon;
  final Widget activeIcon;
  final Widget title;

  const DrawerListTileData({
    this.icon,
    this.activeIcon,
    this.title,
  });
}
