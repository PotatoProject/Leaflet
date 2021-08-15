import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class TagChip extends StatelessWidget {
  final String title;
  final bool showIcon;
  final bool shrink;

  const TagChip({
    required this.title,
    this.showIcon = true,
    this.shrink = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color contrast = context.theme.iconTheme.color!.withOpacity(0.2);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: context.leafletTheme.shapes.chipShape.copyWith(
              side: BorderSide(
                color: contrast,
                width: 2,
              ),
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: constraints.normalize().maxWidth,
          ),
          padding: EdgeInsets.symmetric(
            vertical: shrink ? 4 : 6,
            horizontal: shrink ? 6 : 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: shrink ? 4 : 6),
                constraints: BoxConstraints(
                  maxWidth: constraints.normalize().maxWidth -
                      (shrink ? 10 : 16) -
                      (shrink ? 8 : 12) -
                      (shrink ? 12 : 16),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: shrink ? 12 : 14,
                    color: context.theme.iconTheme.color!.withOpacity(1),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
