import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/data/model/tag_list.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/tag_model.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/draw_page.dart';
import 'package:potato_notes/routes/note_page_image_gallery.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:potato_notes/widget/note_toolbar.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:potato_notes/widget/tag_chip.dart';
import 'package:potato_notes/widget/tag_search_delegate.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final bool openWithList;
  final bool openWithDrawing;

  NotePage({
    this.note,
    this.openWithList = false,
    this.openWithDrawing = false,
  }) : assert((openWithList && !openWithDrawing) ||
            (!openWithList && openWithDrawing) ||
            (!openWithList && !openWithDrawing));

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Note note;
  bool firstTimeRunning = true;

  TextEditingController titleController;
  TextEditingController contentController;
  //SpannableTextEditingController contentController;

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
      styleJson: ContentStyle([]),
      starred: widget.note?.starred ?? false,
      creationDate: widget.note?.creationDate ?? DateTime.now(),
      lastModifyDate: widget.note?.lastModifyDate ?? DateTime.now(),
      color: widget.note?.color ?? 0,
      images: widget.note?.images ?? ImageList({}),
      list: widget.note?.list ?? false,
      listContent: widget.note?.listContent ?? ListContent([]),
      reminders: widget.note?.reminders ?? ReminderList([]),
      tags: widget.note?.tags ?? TagList([]),
      hideContent: widget.note?.hideContent ?? false,
      lockNote: widget.note?.lockNote ?? false,
      usesBiometrics: widget.note?.usesBiometrics ?? false,
      deleted: widget.note?.deleted ?? false,
      archived: widget.note?.archived ?? false,
      synced: widget.note?.synced ?? false,
    );

    titleController = TextEditingController(text: note.title);
    contentController = TextEditingController(text: note.content);

    /*String parsedStyleJson =
        utf8.decode(gzip.decode(note.styleJson?.data ?? []));
    contentController = SpannableTextEditingController(
      text: note.content,
      styleList: note.styleJson != null
          ? SpannableList.fromJson(parsedStyleJson)
          : null,
    );*/

    buildListContentElements();

    super.initState();
  }

  void notifyNoteChanged() {
    helper.saveNote(note);
  }

  Future<void> generateId() async {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstTimeRunning) {
      firstTimeRunning = false;

      if (!widget.openWithList && !widget.openWithDrawing) generateId();

      if (widget.openWithList) toggleList();

      if (widget.openWithDrawing)
        WidgetsBinding.instance.addPostFrameCallback((_) => addDrawing());
    }

    final Widget imagesWidget = NoteViewImages(
      images: note.images.uris.sublist(
          0,
          note.images.data.length > kMaxImageCount
              ? kMaxImageCount
              : note.images.data.length),
      showPlusImages: true,
      numPlusImages: note.images.data.length < kMaxImageCount
          ? 0
          : note.images.data.length - kMaxImageCount,
      useSmallFont: false,
      onImageTap: (index) async {
        await Utils.showSecondaryRoute(
          context,
          NotePageImageGallery(
            note: note,
            currentImage: index,
          ),
          sidePadding: kTertiaryRoutePadding,
          allowGestures: false,
        );

        setState(() {});
      },
    );

    bool smallLandscapeUi =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: note.color != 0
            ? Color(NoteColors.colorList[note.color].dynamicColor(context))
            : null,
        cardColor: note.color != 0
            ? Color(NoteColors.colorList[note.color].dynamicColor(context))
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
                  ? Color(NoteColors.colorList[note.color]
                          .dynamicColor(context))
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
          actions: <Widget>[
            ...getToolbarButtons(!smallLandscapeUi),
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
                notifyNoteChanged();
                scaffoldKey.currentState.removeCurrentSnackBar();
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      note.starred
                          ? "Note added to favourites"
                          : "Note removed from favourites",
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Row(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 56,
                  bottom: 16,
                ),
                children: [
                  Visibility(
                    visible: note.images.data.isNotEmpty &&
                        MediaQuery.of(context).orientation ==
                            Orientation.portrait,
                    child: imagesWidget,
                  ),
                  Visibility(
                    visible: note.tags.tagIds.isNotEmpty,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          note.tags.tagIds.length,
                          (index) {
                            TagModel tag = prefs.tags.firstWhere(
                              (tag) => tag.id == note.tags.tagIds[index],
                            );

                            return TagChip(
                              title: tag.name,
                              color: tag.color,
                              shrink: false,
                            );
                          },
                        ),
                      ),
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
                          onChanged: (text) {
                            note = note.copyWith(title: text);
                            notifyNoteChanged();
                          },
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
                          onChanged: (text) {
                            //List<int> styleJson = gzip.encode(utf8.encode(
                            //    SpannableList(contentController.styleList.list)
                            //        .toJson()));

                            note = note.copyWith(
                              content: text,
                              //styleJson: ContentStyle(styleJson),
                            );

                            notifyNoteChanged();
                          },
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: note.list,
                    child: Column(
                      children: <Widget>[
                        ...List.generate(note.listContent.content.length,
                            (index) {
                          ListItem currentItem =
                              note.listContent.content[index];

                          if (needsFocus &&
                              index == note.listContent.content.length - 1) {
                            needsFocus = false;
                            FocusScope.of(context)
                                .requestFocus(listContentNodes.last);
                          }

                          return Dismissible(
                            key: Key(currentItem.id.toString()),
                            onDismissed: (_) => setState(() {
                              note.listContent.content.removeAt(index);
                              listContentControllers.removeAt(index);
                              listContentNodes.removeAt(index);
                              notifyNoteChanged();
                            }),
                            background: Container(
                              color: Colors.red[400],
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete_outline,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            child: ListTile(
                              leading: Checkbox(
                                value: currentItem.status,
                                onChanged: (value) {
                                  setState(() => note.listContent.content[index]
                                      .status = value);
                                  notifyNoteChanged();
                                },
                                checkColor: note.color != 0
                                    ? Color(NoteColors.colorList[note.color]
                                        .dynamicColor(context))
                                    : Theme.of(context).scaffoldBackgroundColor,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              title: TextField(
                                controller: listContentControllers[index],
                                decoration: InputDecoration.collapsed(
                                    hintText: "Input"),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color
                                      .withOpacity(
                                        note.listContent.content[index].status
                                            ? 0.3
                                            : 0.7,
                                      ),
                                  decoration:
                                      note.listContent.content[index].status
                                          ? TextDecoration.lineThrough
                                          : null,
                                ),
                                onChanged: (text) {
                                  setState(() => note
                                      .listContent.content[index].text = text);
                                  notifyNoteChanged();
                                },
                                onSubmitted: (_) {
                                  if (index ==
                                      note.listContent.content.length - 1) {
                                    if (note.listContent.content.last.text !=
                                        "")
                                      addListContentItem();
                                    else {
                                      FocusScope.of(context).requestFocus(
                                          listContentNodes[index]);
                                    }
                                  } else {
                                    FocusScope.of(context).requestFocus(
                                        listContentNodes[index + 1]);
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
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 28),
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
            ),
            Visibility(
              visible: note.images.data.isNotEmpty &&
                  MediaQuery.of(context).orientation == Orientation.landscape,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 56,
                ),
                width: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top + 56),
                child: imagesWidget,
              ),
            ),
          ],
        ),
        bottomNavigationBar: smallLandscapeUi
            ? null
            : Material(
                color: Theme.of(context).cardColor,
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: NoteToolbar(
                    //controller: contentController,
                    /*onButtonTap: () {
                        List<int> styleJson = gzip.encode(utf8.encode(
                            SpannableList(contentController.styleList.list).toJson()));

                        note = note.copyWith(
                          styleJson: ContentStyle(styleJson),
                        );
                        notifyNoteChanged();
                      },*/
                    rightActions: getToolbarButtons(),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> getToolbarButtons([bool returnNothing = false]) {
    if (returnNothing) {
      return [];
    } else {
      return [
        IconButton(
          icon: Icon(MdiIcons.tagMultipleOutline),
          padding: EdgeInsets.all(0),
          onPressed: () async {
            await Utils.showSecondaryRoute(
              context,
              SearchPage(
                delegate: TagSearchDelegate(note),
              ),
              sidePadding: kTertiaryRoutePadding,
            );

            setState(() {});
          },
        ),
        IconButton(
          icon: Icon(OMIcons.colorLens),
          padding: EdgeInsets.all(0),
          onPressed: () => Utils.showNotesModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).cardColor,
            isScrollControlled: true,
            builder: (context) => NoteColorSelector(
              selectedColor: note.color,
              onColorSelect: (color) {
                setState(() => note = note.copyWith(color: color));
                notifyNoteChanged();

                Navigator.pop(context);
              },
            ),
          ),
        ),
        (!kIsWeb)
            ? IconButton(
                icon: Icon(Icons.add),
                padding: EdgeInsets.all(0),
                onPressed: showAddElementsSheet,
              )
            : IconButton(
                icon: Icon(note.list
                    ? Icons.check_circle
                    : Icons.check_circle_outline),
                padding: EdgeInsets.all(0),
                onPressed: toggleList,
              ),
      ];
    }
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
    notifyNoteChanged();

    setState(() => listContentControllers.add(TextEditingController()));

    FocusNode node = FocusNode();
    listContentNodes.add(node);

    needsFocus = true;
  }

  void showPrivacyOptionSheet() {
    Utils.showNotesModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: note.hideContent,
              onChanged: (value) {
                setState(
                    () => note = note.copyWith(hideContent: !note.hideContent));
                notifyNoteChanged();
              },
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

                      if (confirm) {
                        setState(() =>
                            note = note.copyWith(lockNote: !note.lockNote));
                        notifyNoteChanged();
                      }
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
              visible: deviceInfo.canCheckBiometrics ?? false,
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

                        if (confirm) {
                          setState(() =>
                              note = note.copyWith(usesBiometrics: value));
                          notifyNoteChanged();
                        }
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
    Utils.showNotesModalBottomSheet(
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
              Navigator.pop(context);

              toggleList();
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
                notifyNoteChanged();
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
                notifyNoteChanged();
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(OMIcons.brush),
            title: Text("Add drawing"),
            onTap: () {
              Navigator.pop(context);

              addDrawing();
            },
          ),
        ],
      ),
    );
  }

  void toggleList() async {
    await generateId();
    setState(() => note = note.copyWith(list: !note.list));
    notifyNoteChanged();

    if (note.listContent.content.isEmpty) {
      addListContentItem();
    }
  }

  void addDrawing() async {
    await generateId();
    await Utils.showSecondaryRoute(
      context,
      DrawPage(note: note),
      sidePadding: kTertiaryRoutePadding,
      allowGestures: false,
    );

    setState(() {});
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
