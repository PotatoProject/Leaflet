import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/image/image_service.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/draw_page.dart';
import 'package:potato_notes/routes/note_page_image_gallery.dart';
import 'package:potato_notes/routes/search_page.dart';
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

  TextEditingController titleController;
  FocusNode titleFocusNode = FocusNode();
  TextEditingController contentController;
  FocusNode contentFocusNode = FocusNode();

  //SpannableTextEditingController contentController;

  List<TextEditingController> listContentControllers = [];
  List<FocusNode> listContentNodes = [];
  bool needsFocus = false;

  @override
  void initState() {
    note = Note(
      id: widget.note?.id,
      title: widget.note?.title ?? "",
      content: widget.note?.content ?? "",
      styleJson: [],
      starred: widget.note?.starred ?? false,
      creationDate: widget.note?.creationDate ?? DateTime.now(),
      lastModifyDate: widget.note?.lastModifyDate ?? DateTime.now(),
      color: widget.note?.color ?? 0,
      images: widget.note?.images ?? [],
      list: widget.note?.list ?? false,
      listContent: widget.note?.listContent ?? [],
      reminders: widget.note?.reminders ?? [],
      tags: widget.note?.tags ?? [],
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.openWithList && !widget.openWithDrawing) {
        if (note.id == null) {
          FocusScope.of(context).requestFocus(titleFocusNode);
        }
        generateId();
      } else {
        if (widget.openWithList) toggleList();

        if (widget.openWithDrawing) addDrawing();
      }
    });

    buildListContentElements();

    super.initState();
  }

  void notifyNoteChanged() {
    helper.saveNote(note.markChanged());
  }

  void handleImageAdd(String path) async {
    SavedImage savedImage = await ImageService.prepareLocally(File(path));
    setState(() => note.images.add(savedImage));
    await helper.saveNote(note.markChanged());
    handleImageUpload();
  }

  void handleImageUpload() {
    ImageService.handleUpload(note);
  }

  void generateId() {
    if (note.id == null) note = note.copyWith(id: Utils.generateId());
  }

  @override
  void dispose() {
    listContentNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget imagesWidget = NoteViewImages(
      images: note.images,
      showPlusImages: true,
      numPlusImages: note.images.length < kMaxImageCount
          ? 0
          : note.images.length - kMaxImageCount,
      useSmallFont: false,
      onImageTap: (index) async {
        await Utils.showSecondaryRoute(
          context,
          NotePageImageGallery(
            note: note,
            currentImage: index,
          ),
        );

        setState(() {});
      },
    );

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
        appBar: AppBar(
          actions: <Widget>[
            ...getToolbarButtons(!deviceInfo.isLandscape),
            IconButton(
              icon: Icon(Icons.remove_red_eye_outlined),
              padding: EdgeInsets.all(0),
              tooltip: LocaleStrings.notePage.privacyTitle,
              onPressed: showPrivacyOptionSheet,
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                      note.starred ? Icons.favorite : Icons.favorite_border),
                  padding: EdgeInsets.all(0),
                  tooltip: note.starred
                      ? LocaleStrings.mainPage.selectionBarRemoveFavourites
                      : LocaleStrings.mainPage.selectionBarAddFavourites,
                  onPressed: () {
                    setState(
                        () => note = note.copyWith(starred: !note.starred));
                    notifyNoteChanged();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          note.starred
                              ? LocaleStrings.notePage.addedFavourites
                              : LocaleStrings.notePage.removedFavourites,
                        ),
                        width: min(640, MediaQuery.of(context).size.width - 32),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
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
                    visible: note.images.isNotEmpty && !deviceInfo.isLandscape,
                    child: imagesWidget,
                  ),
                  Visibility(
                    visible: note.tags.isNotEmpty,
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
                          note.tags.length,
                          (index) {
                            Tag tag = prefs.tags.firstWhere(
                              (tag) => tag.id == note.tags[index],
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
                          focusNode: titleFocusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LocaleStrings.notePage.titleHint,
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
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(contentFocusNode),
                        ),
                        TextField(
                          controller: contentController,
                          focusNode: contentFocusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LocaleStrings.notePage.contentHint,
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
                        ...List.generate(note.listContent.length, (index) {
                          ListItem currentItem = note.listContent[index];

                          if (needsFocus &&
                              index == note.listContent.length - 1) {
                            needsFocus = false;
                            FocusScope.of(context)
                                .requestFocus(listContentNodes.last);
                          }

                          return Dismissible(
                            key: Key(currentItem.id.toString()),
                            onDismissed: (_) => setState(() {
                              note.listContent.removeAt(index);
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
                                  setState(() =>
                                      note.listContent[index].status = value);
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
                                  hintText: LocaleStrings.notePage.listItemHint,
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color
                                      .withOpacity(
                                        note.listContent[index].status
                                            ? 0.3
                                            : 0.7,
                                      ),
                                  decoration: note.listContent[index].status
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                onChanged: (text) {
                                  setState(() =>
                                      note.listContent[index].text = text);
                                  notifyNoteChanged();
                                },
                                onSubmitted: (_) {
                                  if (index == note.listContent.length - 1) {
                                    if (note.listContent.last.text != "") {
                                      addListContentItem();
                                    } else {
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
                          opacity: note.listContent.isNotEmpty
                              ? note.listContent.last.text != ""
                                  ? 1
                                  : 0
                              : 1,
                          duration: note.listContent.isNotEmpty
                              ? note.listContent.last.text != ""
                                  ? Duration(milliseconds: 300)
                                  : Duration(milliseconds: 0)
                              : Duration(milliseconds: 0),
                          child: ListTile(
                            leading: Icon(Icons.add),
                            title: Text(
                              LocaleStrings.notePage.addEntryHint,
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            onTap: note.listContent.isNotEmpty
                                ? note.listContent.last.text != ""
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
              visible: note.images.isNotEmpty && deviceInfo.isLandscape,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 56,
                ),
                width: 360,
                child: imagesWidget,
              ),
            ),
          ],
        ),
        bottomNavigationBar: deviceInfo.isLandscape
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
          icon: Icon(Icons.local_offer_outlined),
          padding: EdgeInsets.all(0),
          tooltip: LocaleStrings.notePage.toolbarTags,
          onPressed: () async {
            await Utils.showSecondaryRoute(
              context,
              SearchPage(
                delegate: TagSearchDelegate(
                  note.tags,
                  onChanged: () => helper.saveNote(note.markChanged()),
                ),
              ),
            );

            setState(() {});
          },
        ),
        IconButton(
          icon: Icon(Icons.color_lens_outlined),
          padding: EdgeInsets.all(0),
          tooltip: LocaleStrings.notePage.toolbarColor,
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
        IconButton(
          icon: Icon(Icons.add),
          padding: EdgeInsets.all(0),
          tooltip: LocaleStrings.notePage.toolbarAddItem,
          onPressed: showAddElementsSheet,
        )
      ];
    }
  }

  void addListContentItem() {
    List<ListItem> sortedList = note.listContent;
    sortedList.sort((a, b) => a.id.compareTo(b.id));

    int id = sortedList.isNotEmpty ? sortedList.last.id + 1 : 1;

    note.listContent.add(
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
              secondary: Icon(Icons.remove_red_eye_outlined),
              title: Text(LocaleStrings.notePage.privacyHideContent),
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
              secondary: Icon(Icons.lock_outlined),
              title: Text(LocaleStrings.notePage.privacyLockNote),
              subtitle: prefs.masterPass == ""
                  ? Text(
                      LocaleStrings.notePage.privacyLockNoteMissingPass,
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
                          confirm = await Utils.showBiometricPrompt();
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
                secondary: Icon(Icons.fingerprint_outlined),
                title: Text(LocaleStrings.notePage.privacyUseBiometrics),
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
            title: Text(LocaleStrings.notePage.toggleList),
            onTap: () {
              Navigator.pop(context);

              toggleList();
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_outlined),
            title: Text(LocaleStrings.notePage.imageGallery),
            onTap: () async {
              final image = await Utils.pickImage();

              if (image != null) {
                Navigator.pop(context);
                handleImageAdd(image.path);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_outlined),
            enabled: !DeviceInfo.isDesktop,
            title: Text(LocaleStrings.notePage.imageCamera),
            onTap: () async {
              PickedFile image =
                  await ImagePicker().getImage(source: ImageSource.camera);

              if (image != null) {
                Navigator.pop(context);
                handleImageAdd(image.path);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.brush_outlined),
            title: Text(LocaleStrings.notePage.drawing),
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
    generateId();
    setState(() => note = note.copyWith(list: !note.list));
    notifyNoteChanged();

    if (note.listContent.isEmpty && note.list) {
      addListContentItem();
    }
  }

  void addDrawing() async {
    generateId();
    await Utils.showSecondaryRoute(
      context,
      DrawPage(note: note),
      allowGestures: false,
    );

    setState(() {});
  }

  void buildListContentElements() {
    listContentControllers.clear();
    listContentNodes.clear();
    for (int i = 0; i < note.listContent.length; i++) {
      listContentControllers
          .add(TextEditingController(text: note.listContent[i].text));

      FocusNode node = FocusNode();
      listContentNodes.add(node);
    }
  }
}
