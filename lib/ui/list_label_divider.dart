import 'package:flutter/material.dart';

class ListLabelDivider extends StatelessWidget {
  final String label;

  ListLabelDivider({
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}
