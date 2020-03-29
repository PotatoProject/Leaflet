import 'package:flutter/material.dart';
import 'package:potato_notes/database/model/note.dart';
import 'package:potato_notes/widget/note_toolbar.dart';
import 'package:rich_text_editor/rich_text_editor.dart';
import 'package:spicy_components/spicy_components.dart';

class NotePage extends StatefulWidget {
  final Note note;

  NotePage({
    this.note,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Note note;

  bool keyboardVisible = false;

  TextEditingController titleController;
  SpannableTextEditingController contentController;

  @override
  void initState() {
    note = widget.note ?? Note();
    titleController = TextEditingController(text: note.title ?? "");
    titleController.addListener(() {
      note.title = titleController.text;
    });

    contentController =
        SpannableTextEditingController(text: note.content ?? "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 16),
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Title",
              hintStyle: TextStyle(
                color: Theme.of(context).textTheme.title.color.withOpacity(0.5),
              ),
            ),
            scrollPadding: EdgeInsets.all(0),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.title.color.withOpacity(0.7),
            ),
          ),
          TextField(
            controller: contentController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Content",
              hintStyle: TextStyle(
                color: Theme.of(context).textTheme.title.color.withOpacity(0.3),
              ),
              isDense: true,
            ),
            keyboardType: TextInputType.multiline,
            scrollPadding: EdgeInsets.all(0),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.title.color.withOpacity(0.5),
            ),
            maxLines: null,
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).cardColor,
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom > 56
                    ? MediaQuery.of(context).viewInsets.bottom - 56
                    : MediaQuery.of(context).viewInsets.bottom,
              ),
              child: NoteToolbar(
                controller: contentController,
              ),
            ),
            Divider(
              height: 1,
            ),
            SpicyBottomBar(
              leftItems: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  padding: EdgeInsets.all(0),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }
}
