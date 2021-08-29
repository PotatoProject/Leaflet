import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class BackupPasswordPrompt extends StatefulWidget {
  final bool confirmationMode;

  const BackupPasswordPrompt({
    this.confirmationMode = true,
  });

  @override
  _BackupPasswordPromptState createState() => _BackupPasswordPromptState();
}

class _BackupPasswordPromptState extends State<BackupPasswordPrompt> {
  TextEditingController controller = TextEditingController();

  bool showPass = false;
  bool _useMasterPass = false;

  bool get useMasterPass => !widget.confirmationMode ? _useMasterPass : false;

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Text(LocaleStrings.common.backupPasswordTitle),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.visiblePassword,
              controller: controller,
              obscureText: !showPass,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    showPass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => showPass = !showPass),
                ),
              ),
              style: TextStyle(
                color: context.theme.textTheme.bodyText2!.color!
                    .withOpacity(useMasterPass ? 0.4 : 1.0),
              ),
              enabled: !useMasterPass,
              onFieldSubmitted: controller.text.length >= 4 || useMasterPass
                  ? (text) => _onSubmit(
                        useMasterPass
                            ? prefs.masterPass
                            : Utils.hashedPass(text),
                      )
                  : null,
              maxLength: 64,
            ),
          ),
          if (!widget.confirmationMode)
            CheckboxListTile(
              value: useMasterPass,
              title: Text(LocaleStrings.common.backupPasswordUseMasterPass),
              secondary: const Icon(Icons.vpn_key_outlined),
              onChanged: prefs.masterPass != ""
                  ? (value) => setState(() => _useMasterPass = value!)
                  : null,
              subtitle: prefs.masterPass == ""
                  ? Text(
                      LocaleStrings.notePage.privacyLockNoteMissingPass,
                      style: const TextStyle(color: Colors.red),
                    )
                  : null,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: controller.text.length >= 4 || useMasterPass
              ? () => _onSubmit(
                    useMasterPass
                        ? prefs.masterPass
                        : Utils.hashedPass(controller.text),
                  )
              : null,
          child: Text(LocaleStrings.common.confirm),
        ),
      ],
      contentPadding: EdgeInsets.zero,
    );
  }

  void _onSubmit(String text) {
    Navigator.pop(
      context,
      text,
    );
  }
}
