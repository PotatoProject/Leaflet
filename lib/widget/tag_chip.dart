import 'package:flutter/material.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/tag_model.dart';

class TagChip extends StatelessWidget {
  final String title;
  final int color;
  final bool showIcon;

  TagChip({
    @required this.title,
    this.color,
    this.showIcon = true,
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
        vertical: 4,
        horizontal: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: showIcon,
            child: Icon(
              Icons.brightness_1,
              color: _color,
              size: 10,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
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
