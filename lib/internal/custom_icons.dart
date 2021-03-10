import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore_for_file: constant_identifier_names
class CustomIcons {
  CustomIcons._();

  static const String _kFontFam = 'CustomIcons';

  static const IconData notes = IconData(0xe800, fontFamily: _kFontFam);
  static const IconData settings_outline =
      IconData(0xe801, fontFamily: _kFontFam);
}

class SpinningSyncIcon extends StatefulWidget {
  final bool spin;

  const SpinningSyncIcon({
    this.spin = false,
  });

  @override
  _SpinningSyncIconState createState() => _SpinningSyncIconState();
}

class _SpinningSyncIconState extends State<SpinningSyncIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _updateAnim();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SpinningSyncIcon old) {
    super.didUpdateWidget(old);

    if (widget.spin != old.spin) {
      _updateAnim();
    }
  }

  void _updateAnim() {
    if (widget.spin) {
      _controller.repeat();
    } else {
      _controller.stop(canceled: true);
      _controller.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.square(24),
      child: RotationTransition(
        turns: Tween<double>(begin: 0, end: 1)
            .animate(ReverseAnimation(_controller)),
        child: const Icon(Icons.sync),
      ),
    );
  }
}
