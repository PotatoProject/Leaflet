import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListTilePopupMenuItem<T> extends PopupMenuEntry<T> {
  const ListTilePopupMenuItem({
    Key key,
    this.value,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.textStyle,
    this.mouseCursor,
    @required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  })  : assert(enabled != null),
        assert(height != null),
        super(key: key);

  final T value;

  final bool enabled;

  @override
  final double height;

  final TextStyle textStyle;

  final MouseCursor mouseCursor;

  final Widget title;

  final Widget subtitle;

  final Widget leading;

  final Widget trailing;

  @override
  bool represents(T value) => value == this.value;

  @override
  ListTilePopupMenuItemState<T, ListTilePopupMenuItem<T>> createState() =>
      ListTilePopupMenuItemState<T, ListTilePopupMenuItem<T>>();
}

class ListTilePopupMenuItemState<T, W extends ListTilePopupMenuItem<T>>
    extends State<W> {
  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.subtitle1;

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        constraints: BoxConstraints(minHeight: widget.height),
        child: ListTile(
          title: widget.title,
          subtitle: widget.subtitle,
          leading: widget.leading,
          trailing: widget.trailing,
        ),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }
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
    ));
  }
}
