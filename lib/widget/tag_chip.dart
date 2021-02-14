import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String title;
  final bool showIcon;
  final bool shrink;

  TagChip({
    @required this.title,
    this.showIcon = true,
    this.shrink = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color contrast = Theme.of(context).iconTheme.color.withOpacity(0.2);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: StadiumBorder(
              side: BorderSide(
                color: contrast,
                width: 2,
              ),
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
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
                  maxWidth: constraints.maxWidth -
                      (shrink ? 10 : 16) -
                      (shrink ? 8 : 12) -
                      (shrink ? 12 : 16),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: shrink ? 12 : 14,
                    color: Theme.of(context).iconTheme.color.withOpacity(1),
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
