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
import 'package:potato_notes/widget/note_images.dart';
import 'package:potato_notes/widget/tag_chip.dart';
import 'package:potato_notes/widget/tag_search_delegate.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final bool focusTitle;
  final bool openWithList;
  final bool openWithDrawing;

  const NotePage({
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
  static const double imageWidgetSize = 240.0;
  Note note;

  TextEditingController titleController;
  final FocusNode titleFocusNode = FocusNode();
  TextEditingController contentController;
  final FocusNode contentFocusNode = FocusNode();

  final List<TextEditingController> listContentControllers = [];
  final List<FocusNode> listContentNodes = [];
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
          context.focusScope.requestFocus(titleFocusNode);
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
    note = note.markChanged();
    helper.saveNote(note);
  }

  Future<void> handleImageAdd(String path) async {
    final SavedImage savedImage = await ImageHelper.copyToCache(File(path));
    setState(() => note.images.add(savedImage));
    imageQueue.addUpload(savedImage, note.id);
    note = note.markChanged();
    await helper.saveNote(note);
  }

  @override
  void dispose() {
    for (final FocusNode node in listContentNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showNewItemButton =
        note.listContent.isNotEmpty && note.listContent.last.text.isNotEmpty ||
            note.listContent.isEmpty;

    return Theme(
      data: context.theme.copyWith(
        scaffoldBackgroundColor: note.color != 0
            ? Color(NoteColors.colorList[note.color].dynamicColor(context))
            : null,
        cardColor: note.color != 0
            ? Color(NoteColors.colorList[note.color].dynamicColor(context))
            : null,
        accentColor:
            note.color != 0 ? context.theme.textTheme.caption.color : null,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor:
              note.color != 0 ? context.theme.textTheme.caption.color : null,
        ),
        appBarTheme: context.theme.appBarTheme.copyWith(
          color: note.color != 0
              ? Color(NoteColors.colorList[note.color].dynamicColor(context))
                  .withOpacity(0.9)
              : null,
        ),
        toggleableActiveColor: note.color != 0
            ? context.theme.textTheme.caption.color
            : context.theme.accentColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: note.color != 0
              ? context.theme.textTheme.caption.color
              : context.theme.accentColor,
          selectionColor: note.color != 0
              ? context.theme.textTheme.caption.color.withOpacity(0.3)
              : context.theme.accentColor.withOpacity(0.3),
          selectionHandleColor: note.color != 0
              ? context.theme.textTheme.caption.color
              : context.theme.accentColor,
        ),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                padding: const EdgeInsets.all(0),
                tooltip: LocaleStrings.notePage.privacyTitle,
                onPressed: showPrivacyOptionSheet,
              ),
              IconButton(
                icon:
                    Icon(note.starred ? Icons.favorite : Icons.favorite_border),
                padding: const EdgeInsets.all(0),
                tooltip: note.starred
                    ? LocaleStrings.mainPage.selectionBarRemoveFavourites
                    : LocaleStrings.mainPage.selectionBarAddFavourites,
                onPressed: () {
                  setState(() => note = note.copyWith(starred: !note.starred));
                  notifyNoteChanged();
                  context.scaffoldMessenger.removeCurrentSnackBar();
                  context.scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        note.starred
                            ? LocaleStrings.notePage.addedFavourites
                            : LocaleStrings.notePage.removedFavourites,
                      ),
                      width: min(640, context.mSize.width - 32),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ...getToolbarButtons(returnNothing: !deviceInfo.isLandscape),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Row(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    top: context.padding.top + 56,
                    bottom: 16,
                  ),
                  children: [
                    if (note.images.isNotEmpty && !deviceInfo.isLandscape)
                      SizedBox(
                        height: imageWidgetSize,
                        child: getImageWidget(Axis.horizontal),
                      ),
                    if (note.tags.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        width: context.mSize.width,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            note.tags.length,
                            (index) {
                              final Tag tag = prefs.tags.firstWhere(
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
                          context.focusScope.requestFocus(contentFocusNode),
                    ),
                    _NotePageTextFormField(
                      contentField: true,
                      hintText: LocaleStrings.notePage.contentHint,
                      controller: contentController,
                      focusNode: contentFocusNode,
                      onChanged: (text) {
                        note = note.copyWith(content: text);

                        notifyNoteChanged();
                      },
                    ),
                    if (note.list)
                      ...List.generate(note.listContent.length, (index) {
                        final ListItem currentItem = note.listContent[index];

                        if (needsFocus &&
                            index == note.listContent.length - 1) {
                          needsFocus = false;
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => context.focusScope
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
                          onEditingComplete: () {
                            if (index == note.listContent.length - 1) {
                              if (note.listContent.last.text != "") {
                                addListContentItem();
                              } else {
                                context.focusScope
                                    .requestFocus(listContentNodes[index]);
                              }
                            } else {
                              context.focusScope
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
                              : context.theme.scaffoldBackgroundColor,
                        );
                      }),
                    if (note.list)
                      AnimatedOpacity(
                        opacity: showNewItemButton ? 1 : 0,
                        duration: showNewItemButton
                            ? const Duration(milliseconds: 300)
                            : Duration.zero,
                        child: ListTile(
                          leading: const Icon(Icons.add),
                          title: Text(
                            LocaleStrings.notePage.addEntryHint,
                            style: TextStyle(
                              color: context.theme.iconTheme.color,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          onTap: showNewItemButton
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
                    top: context.padding.top + 56,
                  ),
                  width: imageWidgetSize,
                  child: getImageWidget(Axis.vertical),
                ),
            ],
          ),
          bottomNavigationBar: !deviceInfo.isLandscape
              ? Material(
                  color: context.theme.cardColor,
                  elevation: 8,
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.only(
                      bottom:
                          context.viewInsets.bottom + context.padding.bottom,
                    ),
                    padding: const EdgeInsets.all(8),
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

  Widget getImageWidget(Axis axis) {
    return NoteImages(
      images: note.images,
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
      layoutType: ImageLayoutType.strip,
      stripAxis: axis,
    );
  }

  List<Widget> getToolbarButtons({bool returnNothing = false}) {
    if (returnNothing) {
      return [];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.local_offer_outlined),
          padding: const EdgeInsets.all(0),
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
          icon: const Icon(Icons.color_lens_outlined),
          padding: const EdgeInsets.all(0),
          tooltip: LocaleStrings.notePage.toolbarColor,
          onPressed: () => Utils.showNotesModalBottomSheet(
            context: context,
            backgroundColor: context.theme.cardColor,
            builder: (context) => NoteColorSelector(
              selectedColor: note.color,
              onColorSelect: (color) {
                setState(() => note = note.copyWith(color: color));
                notifyNoteChanged();

                context.pop();
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          padding: const EdgeInsets.all(0),
          tooltip: LocaleStrings.notePage.toolbarAddItem,
          onPressed: () async {
            Utils.showNotesModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        note.list
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                      title: Text(LocaleStrings.notePage.toggleList),
                      onTap: () => handleAddItemTap(context, 'list'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_outlined),
                      title: Text(LocaleStrings.notePage.imageGallery),
                      onTap: () => handleAddItemTap(context, 'image'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_outlined),
                      enabled: !DeviceInfo.isDesktop,
                      title: Text(LocaleStrings.notePage.imageCamera),
                      onTap: () => handleAddItemTap(context, 'camera'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.brush_outlined),
                      title: Text(LocaleStrings.notePage.drawing),
                      onTap: () => handleAddItemTap(context, 'drawing'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ];
    }
  }

  Future<void> handleAddItemTap(BuildContext context, String value) async {
    switch (value) {
      case 'list':
        context.pop();
        toggleList();
        break;
      case 'image':
        final File image = await Utils.pickImage();

        if (image != null) {
          await handleImageAdd(image.path);
          context.pop();
        }
        break;
      case 'camera':
        final PickedFile image =
            await ImagePicker().getImage(source: ImageSource.camera);

        if (image != null) {
          handleImageAdd(image.path);
          context.pop();
        }
        break;
      case 'drawing':
        context.pop();
        addDrawing();
        break;
    }
  }

  void addListContentItem() {
    final List<ListItem> sortedList = note.listContent;
    sortedList.sort((a, b) => a.id.compareTo(b.id));

    final int id = sortedList.isNotEmpty ? sortedList.last.id + 1 : 1;

    note.listContent.add(
      ListItem(
        id: id,
        text: "",
        status: false,
      ),
    );
    notifyNoteChanged();

    setState(() => listContentControllers.add(TextEditingController()));

    final FocusNode node = FocusNode();
    listContentNodes.add(node);

    needsFocus = true;
  }

  void showPrivacyOptionSheet() {
    Utils.showNotesModalBottomSheet(
      context: context,
      backgroundColor: context.theme.bottomSheetTheme.backgroundColor,
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
              activeColor: context.theme.accentColor,
              secondary: const Icon(Icons.remove_red_eye_outlined),
              title: Text(LocaleStrings.notePage.privacyHideContent),
            ),
            SwitchListTile(
              value: note.lockNote,
              onChanged: prefs.masterPass != ""
                  ? (value) async {
                      final bool confirm =
                          await Utils.showPassChallengeSheet(context) ?? false;

                      if (confirm) {
                        setState(() =>
                            note = note.copyWith(lockNote: !note.lockNote));
                        notifyNoteChanged();
                      }
                    }
                  : null,
              activeColor: context.theme.accentColor,
              secondary: const Icon(Icons.lock_outlined),
              title: Text(LocaleStrings.notePage.privacyLockNote),
              subtitle: prefs.masterPass == ""
                  ? Text(
                      LocaleStrings.notePage.privacyLockNoteMissingPass,
                      style: const TextStyle(color: Colors.red),
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
                activeColor: context.theme.accentColor,
                secondary: const Icon(Icons.fingerprint_outlined),
                title: Text(LocaleStrings.notePage.privacyUseBiometrics),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> toggleList() async {
    setState(() => note = note.copyWith(list: !note.list));
    notifyNoteChanged();

    if (note.listContent.isEmpty && note.list) {
      addListContentItem();
    }
  }

  Future<void> addDrawing() async {
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

      final FocusNode node = FocusNode();
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
  final VoidCallback onEditingComplete;
  final ValueChanged<bool> onCheckChanged;
  final Color checkColor;

  const _NoteListEntryItem({
    Key key,
    @required this.item,
    this.controller,
    this.focusNode,
    this.onDismissed,
    this.onTextChanged,
    this.onEditingComplete,
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
        color: context.theme.brightness == Brightness.dark
            ? Colors.red[400]
            : Colors.red[600],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline,
          color: context.theme.scaffoldBackgroundColor,
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
              checkColor:
                  widget.checkColor ?? context.theme.scaffoldBackgroundColor,
              width: 18,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: TextField(
            controller: widget.controller,
            decoration: InputDecoration.collapsed(
              hintText: LocaleStrings.notePage.listItemHint,
            ),
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: context.theme.iconTheme.color.withOpacity(
                widget.item.status ? 0.3 : 0.7,
              ),
              decoration:
                  widget.item.status ? TextDecoration.lineThrough : null,
            ),
            onEditingComplete: widget.onEditingComplete,
            onChanged: widget.onTextChanged,
            focusNode: widget.focusNode,
            textInputAction: TextInputAction.next,
          ),
          trailing: AnimatedOpacity(
            opacity: showDeleteButton ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
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

  const _NotePageTextFormField({
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
      padding: EdgeInsets.only(
        left: 16 + context.viewPadding.left,
        right: 16 + context.viewPadding.right,
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: context.theme.textTheme.caption.color
                .withOpacity(contentField ? 0.3 : 0.5),
          ),
          isDense: contentField,
        ),
        textCapitalization: TextCapitalization.sentences,
        scrollPadding: EdgeInsets.zero,
        style: TextStyle(
          fontSize: contentField ? 16 : 18,
          fontWeight: contentField ? FontWeight.normal : FontWeight.w500,
          color: context.theme.textTheme.caption.color
              .withOpacity(contentField ? 0.5 : 0.7),
        ),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        maxLines: contentField ? null : 1,
      ),
    );
  }
}
