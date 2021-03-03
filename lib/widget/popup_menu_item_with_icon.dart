import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:potato_notes/internal/utils.dart';

class PopupMenuItemWithIcon<T> extends PopupMenuEntry<T> {
  final T value;
  final Widget child;
  final Widget icon;
  final bool enabled;
  final MouseCursor mouseCursor;
  final TextStyle textStyle;

  PopupMenuItemWithIcon({
    @required this.value,
    @required this.child,
    this.icon,
    this.enabled = true,
    this.mouseCursor,
    this.textStyle,
  });

  @override
  _PopupMenuItemWithIconState createState() => _PopupMenuItemWithIconState();

  @override
  double get height => 48;

  @override
  bool represents(T value) => this.value == value;
}

class _PopupMenuItemWithIconState<T> extends State<PopupMenuItemWithIcon<T>> {
  @protected
  Widget buildChild() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.icon != null) widget.icon,
        SizedBox(width: 16),
        widget.child,
      ],
    );
  }

  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final PopupMenuThemeData popupMenuTheme = context.theme.popupMenuTheme;
    TextStyle style = widget.textStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.subtitle1;

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: buildChild(),
      ),
    );

    final bool isDark = theme.brightness == Brightness.dark;
    item = IconTheme.merge(
      data: IconThemeData(
        color: context.theme.iconTheme.color,
        opacity: widget.enabled
            ? 1.0
            : isDark
                ? 0.58
                : 0.38,
      ),
      child: item,
    );
    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          child: item,
        ),
      ),
    );
  }
}
