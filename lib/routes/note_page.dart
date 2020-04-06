import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/note_colors.dart';
import 'package:potato_notes/routes/note_page_image_gallery.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:potato_notes/widget/note_toolbar.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_editor/rich_text_editor.dart';
import 'package:spicy_components/spicy_components.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final int numOfImages;

  NotePage({
    this.note,
    this.numOfImages,
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

  List<TextEditingController> listContentControllers = [];
  List<FocusNode> listContentNodes = [];
  bool needsFocus = false;

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
          listContent: ListContent([]),
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

    buildListContentElements();

    super.initState();
  }

  void generateId() async {
    Note lastNote = await helper.getLastNote();
    note = note.copyWith(id: lastNote.id + 1);
  }

  @override
  void dispose() {
    listContentNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (helper == null) helper = Provider.of<NoteHelper>(context);
    final appInfo = Provider.of<AppInfoProvider>(context);

    if (note.color != 0) {
      appInfo.barManager.darkNavBarColor =
          Color(NoteColors.colorList(context)[note.color]["hex"]);
      appInfo.barManager.lightNavBarColor =
          Color(NoteColors.colorList(context)[note.color]["hex"]);
      appInfo.barManager.updateColors();
    }

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: note.color != 0
            ? Color(NoteColors.colorList(context)[note.color]["hex"])
            : null,
        cardColor: note.color != 0
            ? Color(NoteColors.colorList(context)[note.color]["hex"])
            : null,
        accentColor:
            note.color != 0 ? Theme.of(context).textTheme.title.color : null,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor:
              note.color != 0 ? Theme.of(context).textTheme.title.color : null,
        ),
        toggleableActiveColor: note.color != 0 ? Theme.of(context).textTheme.title.color : null,
      ),
      child: Scaffold(
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
                      note.images.images.length > widget.numOfImages * 2
                          ? widget.numOfImages * 2
                          : note.images.images.length),
                  numOfImages: widget.numOfImages,
                  showPlusImages: true,
                  numPlusImages: note.images.images.length < widget.numOfImages * 2
                      ? 0
                      : note.images.images.length - widget.numOfImages * 2,
                  onImageTap: (index) async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotePageImageGallery(
                            note: note,
                            currentImage: index,
                          ),
                        ));

                    if (note.color != 0) {
                      appInfo.barManager.darkNavBarColor = Color(
                          NoteColors.colorList(context)[note.color]["hex"]);
                      appInfo.barManager.lightNavBarColor = Color(
                          NoteColors.colorList(context)[note.color]["hex"]);
                      appInfo.barManager.updateColors();
                    }
                  }),
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
            Visibility(
              visible: note.list,
              child: Column(
                children: <Widget>[
                  ...List.generate(note.listContent.content.length, (index) {
                    ListItem currentItem = note.listContent.content[index];

                    if (needsFocus &&
                        index == note.listContent.content.length - 1) {
                      needsFocus = false;
                      FocusScope.of(context).requestFocus(FocusNode());
                      FocusScope.of(context)
                          .requestFocus(listContentNodes.last);
                    }

                    return Dismissible(
                      key: Key(currentItem.id.toString()),
                      onDismissed: (_) {
                        note.listContent.content.removeAt(index);
                        listContentControllers.removeAt(index);
                        listContentNodes.removeAt(index);
                      },
                      background: Container(
                        color: Colors.red[400],
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      child: ListTile(
                        leading: Checkbox(
                          value: currentItem.status,
                          onChanged: (value) {
                            note.listContent.content[index].status = value;
                          },
                          checkColor: note.color != 0
                              ? Color(NoteColors.colorList(context)[note.color]["hex"])
                              : null,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        title: TextField(
                          controller: listContentControllers[index],
                          decoration:
                              InputDecoration.collapsed(hintText: "Input"),
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                          onChanged: (text) =>
                              note.listContent.content[index].text = text,
                          focusNode: listContentNodes[index],
                        ),
                      ),
                    );
                  }),
                  AnimatedOpacity(
                    opacity: note.listContent.content.isNotEmpty
                        ? note.listContent.content.last.text != "" ? 1 : 0
                        : 1,
                    duration: note.listContent.content.isNotEmpty
                        ? note.listContent.content.last.text != ""
                            ? Duration(milliseconds: 300)
                            : Duration(milliseconds: 0)
                        : Duration(milliseconds: 0),
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text(
                        "Add item",
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 28),
                      onTap: note.listContent.content.isNotEmpty ?
                          note.listContent.content.last.text != ""
                              ? () => addListContentItem()
                              : null
                          : () => addListContentItem(),
                    ),
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
                  rightActions: [
                    IconButton(
                      icon: Icon(OMIcons.colorLens),
                      padding: EdgeInsets.all(0),
                      onPressed: () => SpicyUtils.showBottomSheet(
                        context: context,
                        backgroundColor: Theme.of(context).cardColor,
                        children: [
                          NoteColorSelector(
                            selectedColor: note.color,
                            onColorSelect: (color) {
                              note = note.copyWith(color: color);

                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      padding: EdgeInsets.all(0),
                      onPressed: showAddElementsDialog,
                    ),
                  ],
                ),
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

                      note.listContent.content
                          .removeWhere((item) => item.text.trim() == "");

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
      ),
    );
  }

  void addListContentItem() {
    List<ListItem> sortedList = note.listContent.content;
    sortedList.sort((a, b) => a.id.compareTo(b.id));

    int id = sortedList.isNotEmpty ? sortedList.last.id + 1 : 1;

    note.listContent.content.add(ListItem(
      id,
      "",
      false,
    ));

    listContentControllers.add(TextEditingController());

    FocusNode node = FocusNode();
    listContentNodes.add(node);

    needsFocus = true;
  }

  void showAddElementsDialog() {
    SpicyUtils.showBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      children: [
        ListTile(
          leading:
              Icon(note.list ? Icons.check_circle : Icons.check_circle_outline),
          title: Text("Toggle list"),
          onTap: () {
            note = note.copyWith(list: !note.list);

            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(OMIcons.photo),
          title: Text("Image from gallery"),
          onTap: () async {
            File image =
                await ImagePicker.pickImage(source: ImageSource.gallery);

            if (image != null) {
              note.images.images.add(image.uri);
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: Icon(OMIcons.camera),
          title: Text("Take a photo"),
          onTap: () async {
            File image =
                await ImagePicker.pickImage(source: ImageSource.camera);

            if (image != null) {
              note.images.images.add(image.uri);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  void buildListContentElements() {
    listContentControllers.clear();
    listContentNodes.clear();
    for (int i = 0; i < note.listContent.content.length; i++) {
      listContentControllers
          .add(TextEditingController(text: note.listContent.content[i].text));

      FocusNode node = FocusNode();
      listContentNodes.add(node);
    }
  }
}
