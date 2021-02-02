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
import 'package:potato_notes/internal/sync/image/image_helper.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/draw_page.dart';
import 'package:potato_notes/routes/note_page_image_gallery.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/mouse_listener_mixin.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:potato_notes/widget/note_view_images.dart';
import 'package:potato_notes/widget/tag_chip.dart';
import 'package:potato_notes/widget/tag_search_delegate.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final bool focusTitle;
  final bool openWithList;
  final bool openWithDrawing;

  NotePage({
    this.note,
    this.focusTitle = false,
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

  List<TextEditingController> listContentControllers = [];
  List<FocusNode> listContentNodes = [];
  bool needsFocus = false;

  @override
  void initState() {
    note = Note(
      id: widget.note?.id ?? Utils.generateId(),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.openWithList && !widget.openWithDrawing) {
        if (widget.focusTitle) {
          FocusScope.of(context).requestFocus(titleFocusNode);
        }
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

  Future<void> handleImageAdd(String path) async {
    SavedImage savedImage = await ImageHelper.copyToCache(File(path));
    setState(() => note.images.add(savedImage));
    imageQueue.addUpload(savedImage, note.id);
    await helper.saveNote(note.markChanged());
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
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: note.color != 0
              ? Theme.of(context).textTheme.caption.color
              : Theme.of(context).accentColor,
          selectionColor: note.color != 0
              ? Theme.of(context).textTheme.caption.color.withOpacity(0.3)
              : Theme.of(context).accentColor,
          selectionHandleColor: Theme.of(context).textTheme.caption.color,
        ),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
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
                          width:
                              min(640, MediaQuery.of(context).size.width - 32),
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
          body: Row(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 56,
                    bottom: 16,
                  ),
                  children: [
                    if (note.images.isNotEmpty && !deviceInfo.isLandscape)
                      imagesWidget,
                    if (note.tags.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8),
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
                                shrink: !(Platform.isAndroid || Platform.isIOS),
                              );
                            },
                          ),
                        ),
                      ),
                    _NotePageTextFormField(
                      hintText: LocaleStrings.notePage.titleHint,
                      controller: titleController,
                      focusNode: titleFocusNode,
                      onChanged: (text) {
                        note = note.copyWith(title: text);
                        notifyNoteChanged();
                      },
                      onSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(contentFocusNode),
                    ),
                    _NotePageTextFormField(
                      contentField: true,
                      hintText: LocaleStrings.notePage.contentHint,
                      controller: contentController,
                      focusNode: contentFocusNode,
                      onChanged: (text) {
                        note = note.copyWith(
                          content: text,
                        );

                        notifyNoteChanged();
                      },
                    ),
                    if (note.list)
                      ...List.generate(note.listContent.length, (index) {
                        ListItem currentItem = note.listContent[index];

                        if (needsFocus &&
                            index == note.listContent.length - 1) {
                          needsFocus = false;
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => FocusScope.of(context)
                                .requestFocus(listContentNodes.last),
                          );
                        }

                        return _NoteListEntryItem(
                          item: currentItem,
                          controller: listContentControllers[index],
                          focusNode: listContentNodes[index],
                          onDismissed: (_) => setState(() {
                            note.listContent.removeAt(index);
                            listContentControllers.removeAt(index);
                            listContentNodes.removeAt(index);
                            notifyNoteChanged();
                          }),
                          onTextChanged: (text) {
                            setState(() => note.listContent[index].text = text);
                            notifyNoteChanged();
                          },
                          onSubmitted: (_) {
                            if (index == note.listContent.length - 1) {
                              if (note.listContent.last.text != "") {
                                addListContentItem();
                              } else {
                                FocusScope.of(context)
                                    .requestFocus(listContentNodes[index]);
                              }
                            } else {
                              FocusScope.of(context)
                                  .requestFocus(listContentNodes[index + 1]);
                            }
                          },
                          onCheckChanged: (value) {
                            setState(
                                () => note.listContent[index].status = value);
                            notifyNoteChanged();
                          },
                          checkColor: note.color != 0
                              ? Color(NoteColors.colorList[note.color]
                                  .dynamicColor(context))
                              : Theme.of(context).scaffoldBackgroundColor,
                        );
                      }),
                    if (note.list)
                      AnimatedOpacity(
                        opacity: note.listContent.isNotEmpty &&
                                note.listContent.last.text.isNotEmpty
                            ? 1
                            : 0,
                        duration: note.listContent.isNotEmpty &&
                                note.listContent.last.text.isNotEmpty
                            ? Duration(milliseconds: 300)
                            : Duration(milliseconds: 0),
                        child: ListTile(
                          leading: Icon(Icons.add),
                          title: Text(
                            LocaleStrings.notePage.addEntryHint,
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          onTap: note.listContent.isNotEmpty &&
                                  note.listContent.last.text.isNotEmpty
                              ? () => addListContentItem()
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
              if (note.images.isNotEmpty && deviceInfo.isLandscape)
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 56,
                  ),
                  width: 360,
                  child: imagesWidget,
                ),
            ],
          ),
          bottomNavigationBar: !deviceInfo.isLandscape
              ? Material(
                  color: Theme.of(context).cardColor,
                  elevation: 8,
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom +
                          MediaQuery.of(context).padding.bottom,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: getToolbarButtons(),
                    ),
                  ),
                )
              : null,
        );
      }),
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
                await handleImageAdd(image.path);
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
    setState(() => note = note.copyWith(list: !note.list));
    notifyNoteChanged();

    if (note.listContent.isEmpty && note.list) {
      addListContentItem();
    }
  }

  void addDrawing() async {
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

class _NoteListEntryItem extends StatefulWidget {
  final ListItem item;
  final TextEditingController controller;
  final FocusNode focusNode;
  final DismissDirectionCallback onDismissed;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<bool> onCheckChanged;
  final Color checkColor;

  _NoteListEntryItem({
    Key key,
    @required this.item,
    this.controller,
    this.focusNode,
    this.onDismissed,
    this.onTextChanged,
    this.onSubmitted,
    this.onCheckChanged,
    this.checkColor,
  }) : super(key: key);

  @override
  _NoteListEntryItemState createState() => _NoteListEntryItemState();
}

class _NoteListEntryItemState extends State<_NoteListEntryItem>
    with SingleTickerProviderStateMixin, MouseListenerMixin {
  bool showDeleteButton = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.item.id),
      onDismissed: widget.onDismissed,
      background: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.red[400]
            : Colors.red[600],
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      direction: isMouseConnected
          ? DismissDirection.none
          : DismissDirection.endToStart,
      child: MouseRegion(
        onEnter: (_) => setState(() => showDeleteButton = true),
        onExit: (_) => setState(() => showDeleteButton = false),
        child: ListTile(
          leading: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: NoteViewCheckbox(
              value: widget.item.status,
              onChanged: widget.onCheckChanged,
              checkColor: widget.checkColor ??
                  Theme.of(context).scaffoldBackgroundColor,
              width: 18,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          title: TextField(
            controller: widget.controller,
            decoration: InputDecoration.collapsed(
              hintText: LocaleStrings.notePage.listItemHint,
            ),
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color.withOpacity(
                    widget.item.status ? 0.3 : 0.7,
                  ),
              decoration:
                  widget.item.status ? TextDecoration.lineThrough : null,
            ),
            onChanged: widget.onTextChanged,
            onSubmitted: widget.onSubmitted,
            focusNode: widget.focusNode,
          ),
          trailing: AnimatedOpacity(
            opacity: showDeleteButton ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed:
                  showDeleteButton ? () => widget.onDismissed(null) : null,
              padding: EdgeInsets.zero,
              splashRadius: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotePageTextFormField extends StatelessWidget {
  final bool contentField;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  _NotePageTextFormField({
    this.contentField = false,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context)
                .textTheme
                .caption
                .color
                .withOpacity(contentField ? 0.3 : 0.5),
          ),
          isDense: contentField,
        ),
        textCapitalization: TextCapitalization.sentences,
        scrollPadding: EdgeInsets.zero,
        style: TextStyle(
          fontSize: contentField ? 16 : 18,
          fontWeight: contentField ? FontWeight.normal : FontWeight.w500,
          color: Theme.of(context)
              .textTheme
              .caption
              .color
              .withOpacity(contentField ? 0.5 : 0.7),
        ),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        maxLines: contentField ? null : 1,
      ),
    );
  }
}
