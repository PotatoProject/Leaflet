import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class TagEditor extends StatefulWidget {
  final Tag? tag;
  final String initialInput;
  final ValueChanged<Tag>? onSave;
  final ValueChanged<Tag>? onDelete;

  const TagEditor({
    this.tag,
    this.initialInput = "",
    this.onSave,
    this.onDelete,
  });

  @override
  _NewTagState createState() => _NewTagState();
}

class _NewTagState extends State<TagEditor> {
  Tag tag = Tag(
    id: "",
    name: "",
    lastChanged: DateTime.now(),
  );
  late TextEditingController controller;

  @override
  void initState() {
    if (widget.tag == null) {
      tag = tag.copyWith(id: Utils.generateId());
      tag = tag.copyWith(name: widget.initialInput);
    } else {
      tag = widget.tag!;
    }

    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Text(
        widget.tag != null
            ? LocaleStrings.common.tagModify
            : LocaleStrings.common.tagNew,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: LocaleStrings.common.tagTextboxHint,
            border: const UnderlineInputBorder(),
          ),
          autofocus: true,
          initialValue: tag.name,
          onFieldSubmitted:
              tag.name.trim().isNotEmpty ? (text) => _onSubmit(text) : null,
          maxLength: 30,
          onChanged: (text) => setState(() => tag = tag.copyWith(name: text)),
        ),
      ),
      actions: [
        if (widget.tag != null)
          TextButton(
            onPressed: () => widget.onDelete?.call(tag),
            child: Text(LocaleStrings.common.delete),
          ),
        TextButton(
          onPressed:
              tag.name.trim().isNotEmpty ? () => _onSubmit(tag.name) : null,
          child: Text(LocaleStrings.common.save),
        ),
      ],
    );
  }

  void _onSubmit(String text) {
    widget.onSave?.call(
      tag.copyWith(name: text.trim()),
    );
  }
}
