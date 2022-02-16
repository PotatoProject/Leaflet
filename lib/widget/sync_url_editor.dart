import 'package:flutter/material.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class SyncUrlEditor extends StatefulWidget {
  @override
  _SyncUrlEditorState createState() => _SyncUrlEditorState();
}

class _SyncUrlEditorState extends State<SyncUrlEditor> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: prefs.apiUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: const Text("Change sync API url"),
      content: TextFormField(
        decoration: const InputDecoration(
          labelText: "URL",
          border: UnderlineInputBorder(),
        ),
        autofocus: true,
        controller: controller,
        onFieldSubmitted: controller.text.isNotEmpty ? _onSubmit : null,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(LocaleStrings.common.cancel),
        ),
        const Spacer(),
        TextButton(
          onPressed: () async {
            prefs.apiUrl = Constants.defaultApiUrl;
            await noteHelper.deleteAllNotes();

            if (!mounted) return;
            context.pop();
          },
          child: Text(LocaleStrings.common.reset),
        ),
        TextButton(
          onPressed: controller.text.isNotEmpty
              ? () => _onSubmit(controller.text)
              : null,
          child: Text(LocaleStrings.common.save),
        ),
      ],
    );
  }

  Future<void> _onSubmit(String text) async {
    prefs.apiUrl = text;
    await noteHelper.deleteAllNotes();

    if (!mounted) return;
    context.pop();
  }
}
