import 'package:flutter/material.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/tag_model.dart';
import 'package:potato_notes/internal/utils.dart';

class TagEditor extends StatefulWidget {
  final TagModel tag;
  final String initialInput;
  final void Function(TagModel) onSave;

  TagEditor({
    this.tag,
    this.initialInput = "",
    this.onSave,
  });

  @override
  _NewTagState createState() => _NewTagState();
}

class _NewTagState extends State<TagEditor> {
  TagModel tag = TagModel(
    color: 0,
  );
  TextEditingController controller;

  @override
  void initState() {
    if (widget.tag == null) {
      tag.id = Utils.generateId();
      tag.name = widget.initialInput;
    } else
      tag = widget.tag;

    controller = TextEditingController();
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
              widget.tag != null
                  ? LocaleStrings.common.tagModify
                  : LocaleStrings.common.tagNew,
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
                labelText: LocaleStrings.common.tagTextboxHint,
                border: UnderlineInputBorder(),
              ),
              initialValue: tag.name,
              maxLength: 30,
              onChanged: (text) => setState(() => tag.name = text),
            ),
          ),
          Container(
            height: 66,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: NoteColors.colorList.length,
              itemBuilder: (context, index) {
                return IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: index == 0
                              ? Theme.of(context).iconTheme.color
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        color: index != 0
                            ? Color(NoteColors.colorList[index].color)
                            : Colors.transparent),
                    width: 32,
                    height: 32,
                    child: tag.color == index
                        ? Icon(
                            Icons.check,
                            color: index != 0
                                ? Theme.of(context).colorScheme.surface
                                : null,
                          )
                        : Container(),
                  ),
                  tooltip: NoteColors.colorList[index].label,
                  onPressed: () {
                    setState(() => tag.color = index);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: tag.name.trim().isNotEmpty
                      ? () => widget.onSave(tag..name = tag.name.trim())
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
