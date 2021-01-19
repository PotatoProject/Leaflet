import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final bool enabled;
  final VoidCallback onTap;

  const SettingsTile({
    Key key,
    @required this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    this.onTap,
  }) : super(key: key);

  SettingsTile.withSwitch({
    Key key,
    @required this.title,
    this.icon,
    this.subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    Color activeColor,
    this.enabled = true,
  })  : this.trailing = Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: activeColor,
        ),
        this.onTap = (() => onChanged(!value)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _subtitle;

    if (subtitle != null) {
      _subtitle = DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle2.copyWith(
              color: Theme.of(context).textTheme.caption.color,
            ),
        child: subtitle,
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(
        16 + MediaQuery.of(context).viewPadding.left,
        4,
        16 + MediaQuery.of(context).viewPadding.right,
        4,
      ),
      leading: icon,
      title: title,
      trailing: trailing ?? _subtitle,
      enabled: enabled,
      onTap: onTap,
    );
  }
}
