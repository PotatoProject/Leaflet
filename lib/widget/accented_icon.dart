import 'package:flutter/material.dart';

/* Fast wrapper class to get accented icon */
class AccentedIcon extends StatelessWidget {
  final IconData data;

  AccentedIcon(this.data);

  @override
  Widget build(BuildContext context) => Icon(
        data,
        color: Theme.of(context).accentColor,
      );
}
