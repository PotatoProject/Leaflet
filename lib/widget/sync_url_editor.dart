import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';

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
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(LocaleStrings.common.cancel),
                  textColor: Theme.of(context).accentColor,
                ),
                Spacer(),
                FlatButton(
                  onPressed: () async {
                    prefs.apiUrl = Utils.defaultApiUrl;
                    await helper.deleteAllNotes();
                    Navigator.pop(context);
                  },
                  child: Text(LocaleStrings.common.reset),
                  textColor: Theme.of(context).accentColor,
                ),
                FlatButton(
                  onPressed: controller.text.isNotEmpty
                      ? () async {
                          prefs.apiUrl = controller.text;
                          await helper.deleteAllNotes();
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text(LocaleStrings.common.save),
                  color: Theme.of(context).accentColor,
                  disabledColor: Theme.of(context).disabledColor,
                  textColor: Theme.of(context).cardColor,
                  disabledTextColor: Theme.of(context).cardColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
