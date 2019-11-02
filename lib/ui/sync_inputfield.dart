import 'package:flutter/material.dart';

class SyncInputField extends StatelessWidget {
  final String title;
  final String errorMessage;
  final bool emptyHandler;
  final bool selectHandler;
  final FocusNode focusNode;
  final double sidePadding;
  final Widget trailing;
  final bool isPassword;
  final bool showPassword;
  final TextInputType keyboardType;

  final Function(String text) onChanged;

  SyncInputField({
    @required this.title,
    @required this.errorMessage,
    @required this.emptyHandler,
    @required this.selectHandler,
    @required this.focusNode,
    this.sidePadding = 20,
    this.trailing,
    this.isPassword = false,
    this.showPassword = true,
    this.keyboardType = TextInputType.text,
    @required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          Card(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: emptyHandler ? Colors.red :
                    selectHandler ?
                        Theme.of(context).accentColor :
                        Theme.of(context).textTheme.title.color.withAlpha(100),
                width: 1.5,
              )
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      autocorrect: false,
                      keyboardType: keyboardType,
                      focusNode: focusNode,
                      onChanged: onChanged,
                    ),
                  ),
                  trailing ?? Container(),
                ],
              )
            ),
          ),
          Text(
            emptyHandler ? errorMessage : "",
            style: TextStyle(
              color: emptyHandler ? Colors.red : Colors.transparent,
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}