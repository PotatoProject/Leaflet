import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class FlatIconButton extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final VoidCallback? onPressed;

  const FlatIconButton({
    required this.icon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color highlightColor = context.theme.accentColor.withOpacity(0.1);
    final ThemeData theme = context.theme;
    final Color accent = context.theme.accentColor;

    return InkResponse(
      onTap: onPressed,
      highlightShape: BoxShape.rectangle,
      containedInkWell: true,
      splashColor: highlightColor,
      highlightColor: highlightColor,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [
            DefaultTextStyle(
              style: theme.textTheme.button!.copyWith(
                color: onPressed != null ? accent : accent.withOpacity(0.38),
              ),
              child: text,
            ),
            const SizedBox(width: 8),
            Theme(
              data: theme.copyWith(
                iconTheme: theme.iconTheme.copyWith(
                  color: onPressed != null ? accent : accent.withOpacity(0.38),
                ),
              ),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
