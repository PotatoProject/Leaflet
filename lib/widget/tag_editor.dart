import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';

class TagEditor extends StatefulWidget {
  final Tag tag;
  final String initialInput;
  final ValueChanged<Tag> onSave;
  final ValueChanged<Tag> onDelete;

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
    id: null,
    name: null,
    lastModifyDate: null,
  );
  TextEditingController controller;

  @override
  void initState() {
    if (widget.tag == null) {
      tag = tag.copyWith(id: Utils.generateId());
      tag = tag.copyWith(name: widget.initialInput);
    } else {
      tag = widget.tag;
    }

    controller = TextEditingController();
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
            padding: const EdgeInsets.all(24),
            child: Text(
              widget.tag != null
                  ? LocaleStrings.common.tagModify
                  : LocaleStrings.common.tagNew,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: LocaleStrings.common.tagTextboxHint,
                border: const UnderlineInputBorder(),
              ),
              initialValue: tag.name,
              maxLength: 30,
              onChanged: (text) =>
                  setState(() => tag = tag.copyWith(name: text)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.tag != null)
                  TextButton(
                    onPressed: () => widget.onDelete?.call(tag),
                    child: Text(LocaleStrings.common.delete),
                  ),
                TextButton(
                  onPressed: tag.name.trim().isNotEmpty
                      ? () => widget.onSave?.call(
                            tag.copyWith(name: tag.name.trim()),
                          )
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
