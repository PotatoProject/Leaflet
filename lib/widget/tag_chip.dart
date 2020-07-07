import 'package:flutter/material.dart';
import 'package:potato_notes/internal/colors.dart';

class TagChip extends StatelessWidget {
  final String title;
  final int color;
  final bool showIcon;
  final bool shrink;

  TagChip({
    @required this.title,
    this.color,
    this.showIcon = true,
    this.shrink = true,
  });

  @override
  Widget build(BuildContext context) {
    Color contrast = Theme.of(context).iconTheme.color.withOpacity(0.1);

    Color _color = color != 0
        ? Color(NoteColors.colorList[color ?? 0].color)
        : Theme.of(context).iconTheme.color.withOpacity(1);

    return Container(
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(256),
          side: BorderSide(
            color: contrast,
            width: 1.5,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: shrink ? 4 : 6,
        horizontal: shrink ? 6 : 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: showIcon,
            child: Icon(
              Icons.brightness_1,
              color: _color,
              size: shrink ? 10 : 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shrink ? 4 : 6),
            child: Text(
              title,
              style: TextStyle(
                fontSize: shrink ? 12 : 14,
                color: Theme.of(context).iconTheme.color.withOpacity(1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
