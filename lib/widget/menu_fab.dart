import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class MenuFab extends StatefulWidget {
  final MenuFabEntry mainEntry;
  final List<MenuFabEntry> entries;
  final ShapeBorder? fabShape;
  final ShapeBorder? menuShape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor mouseCursor;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final PageTransitionSwitcherTransitionBuilder? transitionBuilder;

  const MenuFab({
    Key? key,
    required this.mainEntry,
    required this.entries,
    this.fabShape,
    this.menuShape,
    this.backgroundColor,
    this.foregroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.materialTapTargetSize,
    this.mouseCursor = SystemMouseCursors.click,
    this.clipBehavior = Clip.antiAlias,
    this.focusNode,
    this.autofocus = false,
    this.transitionBuilder,
  }) : super(key: key);

  static const double _defaultElevation = 6;
  static const double _defaultFocusElevation = 8;
  static const double _defaultHoverElevation = 10;
  static const double _defaultHighlightElevation = 12;

  @override
  _MenuFabState createState() => _MenuFabState();
}

class _MenuFabState extends State<MenuFab> {
  static const Object heroTag = _DefaultHeroTag();

  late Color foregroundColor;
  late Color backgroundColor;
  late Color focusColor;
  late Color hoverColor;
  late Color splashColor;
  late double elevation;
  late double focusElevation;
  late double hoverElevation;
  late double disabledElevation;
  late double highlightElevation;
  late MaterialTapTargetSize materialTapTargetSize;
  late TextStyle textStyle;
  late ShapeBorder shape;
  late ShapeBorder menuShape;

  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  bool _disableElevation = false;
  double? _elevation;

  void _updateColors() {
    final ThemeData theme = context.theme;
    final FloatingActionButtonThemeData floatingActionButtonTheme =
        theme.floatingActionButtonTheme;

    foregroundColor = widget.foregroundColor ??
        floatingActionButtonTheme.foregroundColor ??
        theme.colorScheme.onSecondary;
    backgroundColor = widget.backgroundColor ??
        floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    focusColor = widget.focusColor ??
        floatingActionButtonTheme.focusColor ??
        theme.focusColor;
    hoverColor = widget.hoverColor ??
        floatingActionButtonTheme.hoverColor ??
        theme.hoverColor;
    splashColor = widget.splashColor ??
        floatingActionButtonTheme.splashColor ??
        theme.splashColor;
    elevation = widget.elevation ??
        floatingActionButtonTheme.elevation ??
        MenuFab._defaultElevation;
    focusElevation = widget.focusElevation ??
        floatingActionButtonTheme.focusElevation ??
        MenuFab._defaultFocusElevation;
    hoverElevation = widget.hoverElevation ??
        floatingActionButtonTheme.hoverElevation ??
        MenuFab._defaultHoverElevation;
    disabledElevation = widget.disabledElevation ??
        floatingActionButtonTheme.disabledElevation ??
        elevation;
    highlightElevation = widget.highlightElevation ??
        floatingActionButtonTheme.highlightElevation ??
        MenuFab._defaultHighlightElevation;
    materialTapTargetSize =
        widget.materialTapTargetSize ?? theme.materialTapTargetSize;
    textStyle = theme.textTheme.button!.copyWith(
      color: foregroundColor,
      letterSpacing: 1.2,
      fontWeight: FontWeight.normal,
    );
    shape = widget.fabShape ?? floatingActionButtonTheme.shape!;
    menuShape = widget.menuShape ??
        context.leafletTheme.shapes.menuShapeOverride ??
        context.leafletTheme.shapes.mediumComponents;
  }

  @override
  void didUpdateWidget(MenuFab oldWidget) {
    _updateColors();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_elevation == null) {
      _updateColors();
      _elevation = elevation;
    }

    if (_disableElevation) {
      _elevation = 0;
    } else if (_highlighted) {
      _elevation = highlightElevation;
    } else if (_hovered) {
      _elevation = hoverElevation;
    } else if (_focused) {
      _elevation = focusElevation;
    } else {
      _elevation = elevation;
    }

    final Widget _child = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 56.0,
        minHeight: 56.0,
      ),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: widget.mainEntry.onTap,
          onLongPress: () => _showFabMenu(),
          onFocusChange: (value) => setState(() => _focused = value),
          onHover: (value) => setState(() => _hovered = value),
          onHighlightChanged: (value) => setState(() => _highlighted = value),
          focusColor: focusColor,
          hoverColor: hoverColor,
          splashColor: splashColor,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          mouseCursor: widget.mouseCursor,
          child: DefaultTextStyle.merge(
            style: textStyle,
            child: IconTheme.merge(
              data: IconThemeData(
                color: foregroundColor,
              ),
              child: widget.mainEntry.icon,
            ),
          ),
        ),
      ),
    );

    Widget result = GestureDetector(
      onSecondaryTap: () => _showFabMenu(),
      child: Hero(
        tag: heroTag,
        child: _child,
      ),
    );

    result = Material(
      shape: shape,
      elevation: _elevation!,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      child: result,
    );

    return MergeSemantics(child: result);
  }

  Future<void> _showFabMenu() async {
    setState(() => _disableElevation = true);
    await context.push(
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => _MenuFabRoute(
          animation: CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
          secondaryAnimation: CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.fastOutSlowIn,
          ),
          box: context.findRenderObject()! as RenderBox,
          fabIcon: widget.mainEntry.icon,
          fabLabel: widget.mainEntry.label,
          fabOnTap: widget.mainEntry.onTap,
          heroTag: heroTag,
          entries: widget.entries,
          beginShape: shape,
          endShape: menuShape,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          elevation: elevation,
          transitionBuilder: widget.transitionBuilder,
        ),
        barrierColor: Colors.black38,
        barrierDismissible: true,
        fullscreenDialog: true,
        opaque: false,
      ),
    );
    setState(() => _disableElevation = false);
  }
}

class _MenuFabRoute extends StatelessWidget {
  final RenderBox box;
  final Widget fabIcon;
  final String fabLabel;
  final VoidCallback fabOnTap;
  final Object heroTag;
  final List<MenuFabEntry> entries;
  final ShapeBorder beginShape;
  final ShapeBorder endShape;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color focusColor;
  final Color hoverColor;
  final double elevation;
  final PageTransitionSwitcherTransitionBuilder? transitionBuilder;

  const _MenuFabRoute({
    required this.box,
    required this.fabIcon,
    required this.fabLabel,
    required this.fabOnTap,
    required this.heroTag,
    required this.entries,
    required this.beginShape,
    required this.endShape,
    required this.animation,
    required this.secondaryAnimation,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.focusColor,
    required this.hoverColor,
    required this.elevation,
    required this.transitionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final Size fabSize = box.size;
    final Offset fabTopLeftPosition = box.localToGlobal(
      Offset.zero,
    );

    final List<Widget> entries = _buildEntries(context)
      ..add(
        _MenuEntryListTile(
          leading: IconTheme.merge(
            data: IconThemeData(
              color: foregroundColor,
            ),
            child: fabIcon,
          ),
          textColor: foregroundColor,
          title: fabLabel,
          onTap: fabOnTap,
          tileColor: backgroundColor,
          iconColor: foregroundColor,
          hoverColor: hoverColor,
          focusColor: focusColor,
        ),
      );

    return CustomSingleChildLayout(
      delegate: _FabMenuLayoutDelegate(
        Rect.fromLTWH(
          fabTopLeftPosition.dx,
          fabTopLeftPosition.dy,
          fabSize.width,
          fabSize.height,
        ),
      ),
      child: Hero(
        createRectTween: (begin, end) => RectTween(begin: begin, end: end),
        flightShuttleBuilder: (
          flightContext,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) {
          final Animation<ShapeBorder?> shapeAnim = ShapeBorderTween(
            begin: beginShape,
            end: endShape,
          ).animate(animation);

          Widget optionallyAnimate({
            required Widget child,
            required bool animate,
          }) =>
              Positioned.fill(
                child: animate
                    ? transitionBuilder?.call(
                          child,
                          animation,
                          secondaryAnimation,
                        ) ??
                        FadeThroughTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        )
                    : child,
              );

          final List<Widget> children = [
            optionallyAnimate(
              child: fromHeroContext.widget,
              animate: flightDirection == HeroFlightDirection.pop,
            ),
            optionallyAnimate(
              child: toHeroContext.widget,
              animate: flightDirection == HeroFlightDirection.push,
            ),
          ];

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => CustomPaint(
              painter: _AnimatedShapeShadowPainter(
                shapeAnim.value!,
                elevation,
                animation.value,
              ),
              child: ClipPath(
                clipper: ShapeBorderClipper(shape: shapeAnim.value!),
                child: Material(
                  color: foregroundColor,
                  child: Stack(
                    children: flightDirection == HeroFlightDirection.push
                        ? children
                        : children.reversed.toList(),
                  ),
                ),
              ),
            ),
          );
        },
        tag: heroTag,
        child: Material(
          elevation: elevation,
          clipBehavior: Clip.antiAlias,
          shape: endShape,
          child: Align(
            alignment: Alignment.bottomRight,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: entries,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEntries(BuildContext context) {
    return entries
        .map(
          (e) => _MenuEntryListTile(
            leading: e.icon,
            title: e.label,
            onTap: e.onTap,
            iconColor: backgroundColor,
            hoverColor: hoverColor,
            focusColor: focusColor,
          ),
        )
        .toList();
  }
}

class _FabMenuLayoutDelegate extends SingleChildLayoutDelegate {
  final Rect fabRect;

  _FabMenuLayoutDelegate(this.fabRect);

  @override
  bool shouldRelayout(_FabMenuLayoutDelegate old) {
    return fabRect != old.fabRect;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return const BoxConstraints(maxWidth: 240);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final bool isOnTop = fabRect.top < size.height / 2;
    final bool isOnLeft = fabRect.left < size.width / 2;
    final bool isHorizontallyCentered =
        fabRect.left < size.width / 2 && fabRect.right > size.width / 2;

    final double top =
        isOnTop ? fabRect.top : fabRect.bottom - childSize.height;
    double left = isOnLeft ? fabRect.left : fabRect.right - childSize.width;

    if (isHorizontallyCentered) {
      left = (size.width - childSize.width) / 2;
    }

    return Offset(left, top);
  }
}

class _MenuEntryListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final VoidCallback? onTap;
  final Color tileColor;
  final Color iconColor;
  final Color? textColor;
  final Color? focusColor;
  final Color? hoverColor;

  const _MenuEntryListTile({
    this.leading,
    required this.title,
    required this.onTap,
    this.tileColor = Colors.transparent,
    required this.iconColor,
    this.textColor,
    this.focusColor,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    final baseAdjustment = context.theme.visualDensity.baseSizeAdjustment;

    return Material(
      color: tileColor,
      child: InkWell(
        onTap: () {
          context.pop();
          onTap?.call();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 56.0 + baseAdjustment.dy,
          child: Row(
            children: [
              if (leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: iconColor,
                    ),
                    child: leading!,
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuFabEntry {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const MenuFabEntry({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _DefaultHeroTag {
  const _DefaultHeroTag();

  @override
  String toString() => '<default FloatingActionButton tag>';
}

class _AnimatedShapeShadowPainter extends CustomPainter {
  final ShapeBorder shape;
  final double elevation;
  final double elevationOpacity;

  _AnimatedShapeShadowPainter(
    this.shape,
    this.elevation,
    this.elevationOpacity,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    final Path path = shape.getOuterPath(rect);

    canvas.drawShadow(
      path,
      Colors.black.withOpacity(elevationOpacity),
      elevation,
      true,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
