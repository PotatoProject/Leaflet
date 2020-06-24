import 'dart:convert';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loggy/loggy.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/note_colors.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/routes/draw_page.dart';
import 'package:potato_notes/routes/note_page_image_gallery.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:potato_notes/widget/note_toolbar.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final int numOfImages;

  NotePage({
    this.note,
    this.numOfImages = 2,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Note note;
  NoteHelper helper;
  AppInfoProvider appInfo;
  Preferences prefs;

  bool keyboardVisible = false;

  TextEditingController titleController;
  SpannableTextEditingController contentController;

  List<TextEditingController> listContentControllers = [];
  List<FocusNode> listContentNodes = [];
  bool needsFocus = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    note = Note(
      id: widget.note?.id,
      title: widget.note?.title ?? "",
      content: widget.note?.content ?? "",
      styleJson: widget.note?.styleJson,
      starred: widget.note?.starred ?? false,
      creationDate: widget.note?.creationDate ?? DateTime.now(),
      lastModifyDate: widget.note?.lastModifyDate ?? DateTime.now(),
      color: widget.note?.color ?? 0,
      images: widget.note?.images ?? ImageList({}),
      list: widget.note?.list ?? false,
      listContent: widget.note?.listContent ?? ListContent([]),
      reminders: widget.note?.reminders ?? ReminderList([]),
      hideContent: widget.note?.hideContent ?? false,
      lockNote: widget.note?.lockNote ?? false,
      usesBiometrics: widget.note?.usesBiometrics ?? false,
      deleted: widget.note?.deleted ?? false,
      archived: widget.note?.archived ?? false,
      synced: widget.note?.synced ?? false,
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
    BackButtonInterceptor.add(saveAndPop);

    super.initState();
  }

  void generateId() async {
    Note lastNote;
    List<Note> notes = await helper.listNotes(ReturnMode.ALL);
    notes.sort((a, b) => a.id.compareTo(b.id));

    if (notes.isNotEmpty) {
      lastNote = notes.last;
    }

    if (note.id == null) note = note.copyWith(id: (lastNote?.id ?? 0) + 1);
  }

  @override
  void dispose() {
    listContentNodes.forEach((node) => node.dispose());
    BackButtonInterceptor.remove(saveAndPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (helper == null) {
      helper = locator<NoteHelper>();

      generateId();
    }

    if (prefs == null) prefs = Provider.of<Preferences>(context);
    if (appInfo == null) appInfo = Provider.of<AppInfoProvider>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: note.color != 0
            ? Color(NoteColors.colorList(context)[note.color]["hex"])
            : null,
        cardColor: note.color != 0
            ? Color(NoteColors.colorList(context)[note.color]["hex"])
            : null,
        accentColor:
            note.color != 0 ? Theme.of(context).textTheme.caption.color : null,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: note.color != 0
              ? Theme.of(context).textTheme.caption.color
              : null,
        ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: note.color != 0
                  ? Color(NoteColors.colorList(context)[note.color]["hex"])
                      .withOpacity(0.9)
                  : null,
            ),
        toggleableActiveColor: note.color != 0
            ? Theme.of(context).textTheme.caption.color
            : Theme.of(context).accentColor,
      ),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            padding: EdgeInsets.all(0),
            onPressed: () => saveAndPop(null),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(OMIcons.removeRedEye),
              padding: EdgeInsets.all(0),
              onPressed: showPrivacyOptionSheet,
            ),
            IconButton(
              icon: Icon(note.starred
                  ? CommunityMaterialIcons.heart
                  : CommunityMaterialIcons.heart_outline),
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() => note = note.copyWith(starred: !note.starred));
                scaffoldKey.currentState.removeCurrentSnackBar();
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      note.starred
                          ? "Note added to favourites"
                          : "Note remove from favourites",
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 56,
            bottom: 16,
          ),
          children: [
            Visibility(
              visible: note.images.data.isNotEmpty,
              child: NoteViewImages(
                  images: note.images.uris.sublist(
                      0,
                      note.images.data.length > widget.numOfImages * 2
                          ? widget.numOfImages * 2
                          : note.images.data.length),
                  numOfImages: widget.numOfImages,
                  showPlusImages: true,
                  numPlusImages:
                      note.images.data.length < widget.numOfImages * 2
                          ? 0
                          : note.images.data.length - widget.numOfImages * 2,
                  onImageTap: (index) async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotePageImageGallery(
                            note: note,
                            currentImage: index,
                          ),
                        ));
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
                            .caption
                            .color
                            .withOpacity(0.5),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    scrollPadding: EdgeInsets.all(0),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .textTheme
                          .caption
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
                            .caption
                            .color
                            .withOpacity(0.3),
                      ),
                      isDense: true,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    scrollPadding: EdgeInsets.all(0),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .textTheme
                          .caption
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
                      onDismissed: (_) => setState(() {
                        note.listContent.content.removeAt(index);
                        listContentControllers.removeAt(index);
                        listContentNodes.removeAt(index);
                      }),
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
                          onChanged: (value) => setState(() =>
                              note.listContent.content[index].status = value),
                          checkColor: note.color != 0
                              ? Color(NoteColors.colorList(context)[note.color]
                                  ["hex"])
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        title: TextField(
                          controller: listContentControllers[index],
                          decoration:
                              InputDecoration.collapsed(hintText: "Input"),
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                          onChanged: (text) =>
                              note.listContent.content[index].text = text,
                          onSubmitted: (_) {
                            if (index == note.listContent.content.length - 1) {
                              if (note.listContent.content.last.text != "")
                                addListContentItem();
                              else {
                                FocusScope.of(context)
                                    .requestFocus(listContentNodes[index]);
                              }
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              FocusScope.of(context)
                                  .requestFocus(listContentNodes[index + 1]);
                            }
                          },
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
                      onTap: note.listContent.content.isNotEmpty
                          ? note.listContent.content.last.text != ""
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
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: NoteToolbar(
              controller: contentController,
              rightActions: [
                IconButton(
                  icon: Icon(OMIcons.colorLens),
                  padding: EdgeInsets.all(0),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).cardColor,
                    isScrollControlled: true,
                    builder: (context) => NoteColorSelector(
                      selectedColor: note.color,
                      onColorSelect: (color) {
                        setState(() => note = note.copyWith(color: color));

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  padding: EdgeInsets.all(0),
                  onPressed: showAddElementsSheet,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool saveAndPop(_) {
    void _internal() async {
      if (contentController.text.trim() != "") {
        List<SpannableStyle> trimmedList;

        int startIndex =
            contentController.text.indexOf(contentController.text.trim());
        Loggy.d(message: note);
        int endIndex = contentController.text.trim().length + startIndex;
        trimmedList =
            contentController.styleList.list.sublist(startIndex, endIndex);

        List<int> styleJson =
            gzip.encode(utf8.encode(SpannableList(trimmedList).toJson()));

        note = note.copyWith(
          title: note.title.trim(),
          styleJson: ContentStyle(styleJson),
          content: contentController.text.trim(),
          list: note.listContent.content.isEmpty ? false : note.list,
        );

        note.listContent.content.removeWhere((item) => item.text.trim() == "");

        helper.saveNote(note);
      }
    }

    _internal();
    if (_ == null) Navigator.pop(context);

    return false;
  }

  void addListContentItem() {
    List<ListItem> sortedList = note.listContent.content;
    sortedList.sort((a, b) => a.id.compareTo(b.id));

    int id = sortedList.isNotEmpty ? sortedList.last.id + 1 : 1;

    note.listContent.content.add(
      ListItem(
        id,
        "",
        false,
      ),
    );

    setState(() => listContentControllers.add(TextEditingController()));

    FocusNode node = FocusNode();
    listContentNodes.add(node);

    needsFocus = true;
  }

  void showPrivacyOptionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: note.hideContent,
              onChanged: (value) => setState(
                  () => note = note.copyWith(hideContent: !note.hideContent)),
              activeColor: Theme.of(context).accentColor,
              secondary: Icon(OMIcons.removeRedEye),
              title: Text("Hide content on main page"),
            ),
            SwitchListTile(
              value: note.lockNote,
              onChanged: prefs.masterPass != ""
                  ? (value) async {
                      bool confirm =
                          await Utils.showPassChallengeSheet(context) ?? false;

                      if (confirm)
                        setState(() =>
                            note = note.copyWith(lockNote: !note.lockNote));
                    }
                  : null,
              activeColor: Theme.of(context).accentColor,
              secondary: Icon(OMIcons.lock),
              title: Text("Lock note"),
              subtitle: prefs.masterPass == ""
                  ? Text(
                      "You must set a master pass from settings",
                      style: TextStyle(color: Colors.red),
                    )
                  : null,
            ),
            Visibility(
              visible: appInfo.canCheckBiometrics,
              child: SwitchListTile(
                value: note.usesBiometrics,
                onChanged: note.lockNote
                    ? (value) async {
                        bool confirm;

                        try {
                          confirm = await LocalAuthentication()
                              .authenticateWithBiometrics(
                            localizedReason: "",
                            androidAuthStrings: AndroidAuthMessages(
                                fingerprintHint: "Confirm fingerprint"),
                          );
                        } on PlatformException {
                          confirm = false;
                        }

                        if (confirm)
                          setState(() =>
                              note = note.copyWith(usesBiometrics: value));
                      }
                    : null,
                activeColor: Theme.of(context).accentColor,
                secondary: Icon(OMIcons.fingerprint),
                title: Text("Use biometrics to unlock"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddElementsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
                note.list ? Icons.check_circle : Icons.check_circle_outline),
            title: Text("Toggle list"),
            onTap: () {
              setState(() => note = note.copyWith(list: !note.list));

              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.photo),
            title: Text("Image from gallery"),
            onTap: () async {
              PickedFile image =
                  await ImagePicker().getImage(source: ImageSource.gallery);

              if (image != null) {
                setState(
                    () => note.images.data[image.path] = File(image.path).uri);
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(OMIcons.camera),
            title: Text("Take a photo"),
            onTap: () async {
              PickedFile image =
                  await ImagePicker().getImage(source: ImageSource.camera);

              if (image != null) {
                setState(
                    () => note.images.data[image.path] = File(image.path).uri);
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(OMIcons.brush),
            title: Text("Add drawing"),
            onTap: () async {
              Uri drawing = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DrawPage(note: note),
              ));

              if (drawing != null) {
                setState(() =>
                    note.images.data[drawing.path] = File(drawing.path).uri);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
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
