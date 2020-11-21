import 'package:flutter/material.dart';

class FakeAppbar extends StatelessWidget with PreferredSizeWidget {
  final Widget child;

  FakeAppbar({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child;

  @override
  Size get preferredSize => Size.fromHeight(56);
}
