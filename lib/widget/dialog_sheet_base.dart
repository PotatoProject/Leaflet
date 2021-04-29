import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';

class DialogSheetBase extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets contentPadding;
  final MainAxisAlignment actionsAlignment;

  const DialogSheetBase({
    this.title,
    this.content,
    this.actions,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.actionsAlignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                child: title!,
              ),
            ),
          if (content != null)
            Padding(
              padding: contentPadding,
              child: content,
            ),
          if (actions != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: actionsAlignment,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
}
