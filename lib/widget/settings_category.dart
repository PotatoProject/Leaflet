import 'package:flutter/material.dart';

class SettingsCategory extends StatelessWidget {
  final String header;
  final List<Widget> children;

  SettingsCategory({
    @required this.header,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            0,
          ),
          child: headerWidget(header),
        ),
        ...(children ?? []),
      ],
    );
  }

  Widget headerWidget(String text) => Builder(
        builder: (context) {
          TextStyle heading = TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 2,
          );

          return Text(
            text.toUpperCase(),
            style: heading,
          );
        },
      );
}
