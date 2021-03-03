import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';

class SyncUrlEditor extends StatefulWidget {
  @override
  _SyncUrlEditorState createState() => _SyncUrlEditorState();
}

class _SyncUrlEditorState extends State<SyncUrlEditor> {
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: prefs.apiUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "Change sync API url",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "URL",
                border: UnderlineInputBorder(),
              ),
              controller: controller,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(LocaleStrings.common.cancel),
                ),
                Spacer(),
                TextButton(
                  onPressed: () async {
                    prefs.apiUrl = Utils.defaultApiUrl;
                    await helper.deleteAllNotes();
                    context.pop();
                  },
                  child: Text(LocaleStrings.common.reset),
                ),
                TextButton(
                  onPressed: controller.text.isNotEmpty
                      ? () async {
                          prefs.apiUrl = controller.text;
                          await helper.deleteAllNotes();
                          context.pop();
                        }
                      : null,
                  child: Text(LocaleStrings.common.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
