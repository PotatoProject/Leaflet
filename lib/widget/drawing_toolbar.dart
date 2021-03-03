import 'package:flutter/material.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/widget/drawing_board.dart';

class DrawingToolbar extends StatefulWidget {
  final DrawingToolbarController controller;
  final List<DrawingTool> tools;
  final int toolIndex;
  final ValueChanged<int> onIndexChanged;
  final DrawingBoardController boardController;
  final VoidCallback clearCanvas;

  DrawingToolbar({
    @required this.tools,
    this.controller,
    this.boardController,
    this.toolIndex = 0,
    this.onIndexChanged,
    this.clearCanvas,
  });

  @override
  _DrawingToolbarState createState() => _DrawingToolbarState();
}

class _DrawingToolbarState extends State<DrawingToolbar>
    with TickerProviderStateMixin {
  AnimationController _ac;
  AnimationController _colorPanelAc;
  double _panelHeight = 0;
  Curve _curve = decelerateEasing;

  @override
  void initState() {
    _ac = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _colorPanelAc = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    widget.controller?._provideState(this);
    widget.boardController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _ac.dispose();
    _colorPanelAc.dispose();
    super.dispose();
  }

  void closePanel() {
    _ac.animateBack(0);
  }

  @override
  Widget build(BuildContext context) {
    final DrawingTool currentTool = widget.tools[widget.toolIndex];

    _panelHeight = 56;
    if (currentTool.allowColor) {
      _panelHeight += Tween<double>(begin: 48.0 + 1, end: 48.0 * 3 + 1)
          .evaluate(_colorPanelAc);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 360,
      ),
      child: Material(
        color: context.theme.scaffoldBackgroundColor,
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onVerticalDragStart: (details) {
                setState(() => _curve = Curves.linear);
              },
              onVerticalDragUpdate: (details) {
                _ac.value -= details.primaryDelta / _panelHeight;
              },
              onVerticalDragEnd: (details) {
                setState(() => _curve =
                    SuspendedCurve(_ac.value, curve: decelerateEasing));

                if (details.primaryVelocity > 350) {
                  final bool _animForward =
                      _ac.status == AnimationStatus.forward ||
                          _ac.status == AnimationStatus.completed;
                  if (!_animForward)
                    _ac.animateTo(1);
                  else
                    _ac.animateBack(0);
                }

                if (_ac.value > 0.5) {
                  _ac.animateTo(1);
                } else {
                  _ac.animateBack(0);
                }
              },
              child: Material(
                color: context.theme.cardColor,
                elevation: 4,
                child: Container(
                  height: 48,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.undo),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        tooltip: LocaleStrings.common.undo,
                        onPressed: widget.boardController.canUndo
                            ? () => widget.boardController.undo()
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.redo),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        tooltip: LocaleStrings.common.redo,
                        onPressed: widget.boardController.canRedo
                            ? () => widget.boardController.redo()
                            : null,
                      ),
                      VerticalDivider(
                        indent: 8,
                        endIndent: 8,
                      ),
                      ...List.generate(widget.tools.length, (i) {
                        final DrawingTool e = widget.tools[i];

                        return IconButton(
                          icon: Icon(e.icon),
                          tooltip: e.title,
                          color: widget.toolIndex == i
                              ? context.theme.accentColor
                              : null,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          onPressed: widget.toolIndex == i
                              ? () {
                                  _curve = decelerateEasing;
                                  final bool _animForward = _ac.status ==
                                          AnimationStatus.forward ||
                                      _ac.status == AnimationStatus.completed;
                                  if (!_animForward)
                                    _ac.animateTo(1);
                                  else
                                    _ac.animateBack(0);
                                }
                              : () async {
                                  _curve = decelerateEasing;
                                  await _ac.animateBack(0);
                                  widget.onIndexChanged?.call(i);
                                },
                        );
                      }),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        tooltip: "Clear canvas",
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        onPressed: widget.clearCanvas,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: CurvedAnimation(
                curve: _curve,
                parent: _ac,
              ),
              axis: Axis.vertical,
              axisAlignment: 1,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    padding: EdgeInsets.only(left: 4),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            ToolSize.values.length,
                            (index) => InkWell(
                              child: SizedBox.fromSize(
                                size: Size.square(42),
                                child: CustomPaint(
                                  size: Size.square(48),
                                  painter: _ToolSizeButtonPainter(
                                    ToolSize.values[index] / 2,
                                    currentTool.size == ToolSize.values[index],
                                    context.theme.disabledColor.withOpacity(1),
                                  ),
                                ),
                              ),
                              radius: 24,
                              customBorder: CircleBorder(),
                              onTap: () {
                                currentTool.size = ToolSize.values[index];
                                setState(() {});
                              },
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: RotationTransition(
                              turns: Tween<double>(begin: 0, end: 0.5)
                                  .animate(_colorPanelAc),
                              child: Icon(Icons.expand_less),
                            ),
                            onPressed: currentTool.allowColor
                                ? () {
                                    if (_colorPanelAc.value > 0.5)
                                      _colorPanelAc.animateBack(0);
                                    else
                                      _colorPanelAc.animateTo(1);
                                    setState(() {});
                                  }
                                : null,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.tools[widget.toolIndex].allowColor,
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  Visibility(
                    visible: widget.tools[widget.toolIndex].allowColor,
                    child: AnimatedBuilder(
                      animation: _colorPanelAc,
                      builder: (context, child) {
                        return Container(
                          height: Tween<double>(begin: 48, end: 48.0 * 3)
                              .evaluate(_colorPanelAc),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          _CollapsableWidget(
                            collapseStatus: _colorPanelAc,
                            child: _ColorStrip(
                              type: ColorType.LIGHT,
                              currentTool: widget.tools[widget.toolIndex],
                              onTap: (color) {
                                widget.tools[widget.toolIndex].color = color;
                                setState(() {});
                              },
                            ),
                          ),
                          _ColorStrip(
                            type: ColorType.NORMAL,
                            currentTool: widget.tools[widget.toolIndex],
                            onTap: (color) {
                              widget.tools[widget.toolIndex].color = color;
                              setState(() {});
                            },
                          ),
                          _CollapsableWidget(
                            collapseStatus: _colorPanelAc,
                            child: _ColorStrip(
                              type: ColorType.DARK,
                              currentTool: widget.tools[widget.toolIndex],
                              onTap: (color) {
                                widget.tools[widget.toolIndex].color = color;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: context.theme.cardColor,
              elevation: 4,
              child: Container(
                height: context.padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollapsableWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> collapseStatus;

  _CollapsableWidget({
    this.child,
    @required this.collapseStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: collapseStatus,
      builder: (context, child) => Align(
        heightFactor: collapseStatus.value,
        child: FadeTransition(
          opacity: collapseStatus,
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class _ColorStrip extends StatelessWidget {
  final ColorType type;
  final DrawingTool currentTool;
  final ValueChanged<Color> onTap;

  _ColorStrip({
    @required this.type,
    this.currentTool,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        height: 48,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            NoteColors.colorList.length,
            (index) {
              Color color;

              if (index == 0) {
                switch (type) {
                  case ColorType.DARK:
                    color = Colors.grey;
                    break;
                  case ColorType.LIGHT:
                    color = Colors.white;
                    break;
                  case ColorType.NORMAL:
                  default:
                    color = Colors.black;
                    break;
                }
              } else {
                switch (type) {
                  case ColorType.DARK:
                    color = Color(NoteColors.colorList[index].darkColor);
                    break;
                  case ColorType.LIGHT:
                    color = Color(NoteColors.colorList[index].lightColor);
                    break;
                  case ColorType.NORMAL:
                  default:
                    color = Color(NoteColors.colorList[index].color);
                    break;
                }
              }

              final double padding =
                  34.0 - (currentTool.color == color ? 30.0 : 20.0);

              return SizedBox.fromSize(
                size: Size.square(34),
                child: InkWell(
                  child: AnimatedPadding(
                    padding: EdgeInsets.all(padding / 2),
                    duration: Duration(milliseconds: 150),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(
                          side: color.value == Colors.white.value ||
                                  color.value == Colors.black.value
                              ? BorderSide(
                                  color: context.theme.disabledColor,
                                  width: 2,
                                )
                              : BorderSide.none,
                        ),
                        color: color,
                      ),
                    ),
                  ),
                  radius: 20,
                  customBorder: CircleBorder(),
                  onTap: () => onTap?.call(color),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DrawingToolbarController {
  DrawingToolbarController();

  _DrawingToolbarState _state;

  void _provideState(_DrawingToolbarState state) {
    this._state = state;
  }

  void closePanel() => _state.closePanel();
}

class DrawingTool {
  final String title;
  final IconData icon;
  final DrawTool toolType;
  final bool allowColor;
  Color color;
  double size;

  DrawingTool({
    @required this.title,
    @required this.icon,
    @required this.toolType,
    this.allowColor = true,
    this.color = Colors.black,
    this.size = ToolSize.FOUR,
  });
}

class ToolSize {
  static const double FOUR = 4;
  static const double EIGHT = 8;
  static const double TWELVE = 12;
  static const double SIXTEEN = 16;
  static const double TWENTYTWO = 22;
  static const double TWENTYSIX = 26;
  static const double THIRTYTWO = 32;

  static const List<double> values = [
    FOUR,
    EIGHT,
    TWELVE,
    SIXTEEN,
    TWENTYTWO,
    TWENTYSIX,
    THIRTYTWO,
  ];
}

enum DrawTool {
  PEN,
  ERASER,
  MARKER,
}

enum ColorType {
  NORMAL,
  LIGHT,
  DARK,
}

class _ToolSizeButtonPainter extends CustomPainter {
  final double radius;
  final bool selected;
  final Color color;

  _ToolSizeButtonPainter(
    this.radius,
    this.selected,
    this.color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 1.5
      ..color = color;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    if (selected) {
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 18, paint);
    }
  }

  @override
  bool shouldRepaint(_ToolSizeButtonPainter old) {
    return this.radius != old.radius || this.selected != old.selected;
  }
}
