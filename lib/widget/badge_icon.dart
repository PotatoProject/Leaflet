import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class BadgeIcon extends StatelessWidget {
  final Widget icon;
  final Widget? badgeIcon;
  final bool showBadge;
  final double size;
  final double badgeSize;
  final AlignmentGeometry? badgeAlignment;

  const BadgeIcon({
    required this.icon,
    this.badgeIcon,
    this.showBadge = true,
    this.size = 24,
    this.badgeSize = 12,
    this.badgeAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(size),
      child: badgeIcon != null && showBadge
          ? Stack(
              children: [
                ClipPath(
                  clipper: _BadgeClipper(
                    badgeAlignment ?? AlignmentDirectional.topEnd,
                    badgeSize,
                    context.directionality,
                  ),
                  child: IconTheme.merge(
                    data: IconThemeData(size: size),
                    child: icon,
                  ),
                ),
                CustomSingleChildLayout(
                  delegate: _BadgeLayoutDelegate(
                    badgeAlignment ?? AlignmentDirectional.topEnd,
                    context.directionality,
                  ),
                  child: SizedBox.fromSize(
                    size: Size.square(badgeSize),
                    child: IconTheme.merge(
                      data: IconThemeData(size: badgeSize),
                      child: badgeIcon!,
                    ),
                  ),
                ),
              ],
            )
          : SizedBox.fromSize(
              size: Size.square(size),
              child: IconTheme.merge(
                data: IconThemeData(size: size),
                child: icon,
              ),
            ),
    );
  }
}

class _BadgeClipper extends CustomClipper<Path> {
  final AlignmentGeometry alignment;
  final double size;
  final TextDirection direction;

  _BadgeClipper(
    this.alignment,
    this.size,
    this.direction,
  );

  @override
  Path getClip(Size _size) {
    final resolvedAlignment = alignment.resolve(direction);
    final halfWidth = _size.width / 2;
    final halfHeight = _size.height / 2;

    final x = resolvedAlignment.x * halfWidth + halfWidth;
    final y = resolvedAlignment.y * halfHeight + halfHeight;

    final xAdjust = size / 2 * resolvedAlignment.x;
    final yAdjust = size / 2 * resolvedAlignment.y;
    final xInset = size / 4 * resolvedAlignment.x;
    final yInset = size / 4 * resolvedAlignment.y;

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & _size),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(x - xAdjust + xInset, y - yAdjust + yInset),
            radius: size / 2 + size / 16,
          ),
        ),
    );
  }

  @override
  bool shouldReclip(_BadgeClipper old) {
    return alignment != old.alignment || size != old.size;
  }
}

class _BadgeLayoutDelegate extends SingleChildLayoutDelegate {
  final AlignmentGeometry alignment;
  final TextDirection direction;

  _BadgeLayoutDelegate(
    this.alignment,
    this.direction,
  );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final Alignment resolvedAlignment = alignment.resolve(direction);
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    final double x = resolvedAlignment.x * halfWidth + halfWidth;
    final double y = resolvedAlignment.y * halfHeight + halfHeight;

    final double xAdjust = childSize.width / 2 * resolvedAlignment.x;
    final double yAdjust = childSize.height / 2 * resolvedAlignment.y;
    final double xInset = childSize.width / 4 * resolvedAlignment.x;
    final double yInset = childSize.height / 4 * resolvedAlignment.y;

    final Offset point = Offset(x - xAdjust + xInset, y - yAdjust + yInset);

    return point.translate(-halfWidth / 2, -halfHeight / 2);
  }

  @override
  bool shouldRelayout(_BadgeLayoutDelegate old) {
    return alignment != old.alignment || direction != old.direction;
  }
}
