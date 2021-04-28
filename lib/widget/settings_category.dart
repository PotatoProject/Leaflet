import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class SettingsCategory extends StatelessWidget {
  final String header;
  final List<Widget> children;

  const SettingsCategory({
    required this.header,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.viewPadding.left + 16,
            8,
            16,
            8,
          ),
          child: headerWidget(header),
        ),
        ...children,
      ],
    );
  }

  Widget headerWidget(String text) => Builder(
        builder: (context) => Text(
          text.toUpperCase(),
          style: TextStyle(
            color: context.theme.accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      );
}
