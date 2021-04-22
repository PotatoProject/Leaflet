import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

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
    return Padding(
      padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Input backup password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: controller,
              obscureText: !showPass,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(showPass
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => showPass = !showPass),
                ),
              ),
              style: TextStyle(
                color: context.theme.textTheme.bodyText2!.color!
                    .withOpacity(useMasterPass ? 0.4 : 1.0),
              ),
              enabled: !useMasterPass,
              onFieldSubmitted: controller.text.length >= 4
                  ? (text) => Navigator.pop(context, text)
                  : null,
              maxLength: 64,
            ),
          ),
          if (!widget.confirmationMode)
            CheckboxListTile(
              value: useMasterPass,
              title: const Text("Use master pass as password"),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: controller.text.length >= 4 || useMasterPass
                      ? () => Navigator.pop(
                            context,
                            useMasterPass
                                ? prefs.masterPass
                                : Utils.hashedPass(controller.text),
                          )
                      : null,
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
