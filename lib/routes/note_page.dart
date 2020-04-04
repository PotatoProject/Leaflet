import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/routes/note_page_image_gallery.dart';
import 'package:potato_notes/widget/note_toolbar.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:provider/provider.dart';
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
  NoteHelper helper;

  bool keyboardVisible = false;

  TextEditingController titleController;
  SpannableTextEditingController contentController;

  @override
  void initState() {
    note = widget.note ??
        Note(
          id: null,
          title: "",
          content: "",
          styleJson: null,
          starred: false,
          creationDate: DateTime.now(),
          lastModifyDate: DateTime.now(),
          color: 0,
          images: ImageList([]),
          list: false,
          listContent: ListContent({}),
          reminders: ReminderList([]),
          hideContent: false,
          pin: null,
          password: null,
          usesBiometrics: false,
          deleted: false,
          archived: false,
          synced: false,
        );

    titleController = TextEditingController(text: note.title);
    titleController.addListener(() {
      note = note.copyWith(title: titleController.text);
    });

    String parsedStyleJson =
        utf8.decode(gzip.decode(note.styleJson?.data ?? []));
    contentController = SpannableTextEditingController(
      text: note.content,
      styleList: note.styleJson != null
          ? SpannableList.fromJson(parsedStyleJson)
          : null,
    );

    super.initState();
  }

  void generateId() async {
    Note lastNote = await helper.getLastNote();
    note = note.copyWith(id: lastNote.id + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (helper == null) {
      helper = Provider.of<NoteHelper>(context);
    }
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 16,
        ),
        children: [
          Visibility(
            visible: note.images.images.isNotEmpty,
            child: NoteViewImages(
              images: note.images.images.sublist(
                  0,
                  note.images.images.length > 4
                      ? 4
                      : note.images.images.length),
              numOfImages: 2,
              showPlusImages: true,
              numPlusImages: note.images.images.length < 4
                  ? 0
                  : note.images.images.length - 4,
              onImageTap: (index) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotePageImageGallery(
                      note: note,
                      currentImage: index,
                    ),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .title
                          .color
                          .withOpacity(0.5),
                    ),
                  ),
                  scrollPadding: EdgeInsets.all(0),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .title
                        .color
                        .withOpacity(0.7),
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Content",
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .title
                          .color
                          .withOpacity(0.3),
                    ),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  scrollPadding: EdgeInsets.all(0),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .textTheme
                        .title
                        .color
                        .withOpacity(0.5),
                  ),
                  maxLines: null,
                ),
              ],
            ),
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
                  onPressed: () async {
                    List<int> styleJson = gzip.encode(
                        utf8.encode(contentController.styleList.toJson()));
                    Note lastNote;
                    List<Note> notes = await helper.listNotes();

                    if (notes.isNotEmpty) {
                      lastNote = notes.last;
                    }

                    note = note.copyWith(
                      id: note.id ?? (lastNote?.id ?? 0) + 1,
                      styleJson: ContentStyle(styleJson),
                      content: contentController.text,
                    );

                    helper.saveNote(note);
                    Navigator.pop(context);
                  },
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
