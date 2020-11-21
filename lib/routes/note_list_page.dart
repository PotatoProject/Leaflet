import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/sync_routine.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/default_app_bar.dart';
import 'package:potato_notes/widget/dependent_scaffold.dart';
import 'package:potato_notes/widget/fake_fab.dart';
import 'package:potato_notes/widget/new_note_bar.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:potato_notes/widget/tag_editor.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NoteListPage extends StatefulWidget {
  final ReturnMode noteKind;
  final int? tagIndex;

  NoteListPage({
    Key? key,
    required this.noteKind,
    this.tagIndex,
  }) : super(key: key);

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  ScrollController scrollController = ScrollController();
  bool _selecting = false;
  List<Note> selectionList = [];

  bool get selecting => _selecting;
  set selecting(bool value) {
    _selecting = value;
    BasePage.of(context)?.setBottomBarEnabled(!value);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.fromLTRB(
      4,
      4 + MediaQuery.of(context).padding.top,
      4,
      4 + 80.0,
    );

    PreferredSizeWidget appBar = (selecting
        ? SelectionBar(
            selectionList: selectionList,
            onCloseSelection: () => setState(() {
              selecting = false;
              selectionList.clear();
            }),
            currentMode: widget.noteKind,
          )
        : DefaultAppBar(
            extraActions: appBarButtons,
            title: Text(Utils.getNameFromMode(widget.noteKind)),
          )) as PreferredSizeWidget;

    return AnimationLimiter(
      child: DependentScaffold(
        appBar: appBar,
        useAppBarAsSecondary: selecting,
        secondaryAppBar: widget.noteKind == ReturnMode.NORMAL && !selecting
            ? NewNoteBar()
            : null,
        body: StreamBuilder<List<Note>>(
          stream: helper.noteStream(widget.noteKind),
          initialData: [],
          builder: (context, snapshot) {
            Widget child;
            List<Note> notes = widget.noteKind == ReturnMode.TAG
                ? snapshot.data!
                    .where(
                      (note) =>
                          note.tags.contains(prefs.tags[widget.tagIndex!].id) &&
                          !note.archived &&
                          !note.deleted,
                    )
                    .toList()
                : snapshot.data ?? [];

            if (notes.isNotEmpty) {
              if (prefs.useGrid) {
                child = WaterfallFlow.builder(
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: deviceInfo.uiSizeFactor,
                  ),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      columnCount: deviceInfo.uiSizeFactor,
                      position: index,
                      duration: const Duration(milliseconds: 350),
                      child: SlideAnimation(
                        verticalOffset: 128,
                        child: FadeInAnimation(
                          child: commonNote(notes[index]),
                        ),
                      ),
                    );
                  },
                  itemCount: notes.length,
                  controller: scrollController,
                  padding: padding,
                  physics: const AlwaysScrollableScrollPhysics(),
                );
              } else {
                child = ListView.builder(
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 350),
                      child: SlideAnimation(
                        verticalOffset: 128,
                        child: FadeInAnimation(
                          child: commonNote(notes[index]),
                        ),
                      ),
                    );
                  },
                  itemCount: notes.length,
                  controller: scrollController,
                  padding: padding,
                  physics: const AlwaysScrollableScrollPhysics(),
                );
              }
            } else {
              child = LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Illustrations.quickIllustration(
                        context,
                        getInfoOnCurrentMode.key,
                        getInfoOnCurrentMode.value,
                      ),
                    ),
                  );
                },
              );
            }

            return RefreshIndicator(
              child: child,
              onRefresh: sync,
              displacement: MediaQuery.of(context).padding.top + 40,
            );
          },
        ),
        floatingActionButton:
            widget.noteKind == ReturnMode.NORMAL && !selecting ? fab : null,
      ),
    );
  }

  Widget get fab {
    return FakeFab(
      heroTag: "fabMenu",
      shape: StadiumBorder(),
      onTap: () => Utils.newNote(context),
      child: Icon(Icons.edit_outlined),
    );
  }

  MapEntry<Widget, String> get getInfoOnCurrentMode {
    switch (widget.noteKind) {
      case ReturnMode.ARCHIVE:
        return MapEntry(
          appInfo.emptyArchiveIllustration ?? Container(),
          LocaleStrings.mainPage.emptyStateArchive,
        );
      case ReturnMode.TRASH:
        return MapEntry(
          appInfo.emptyTrashIllustration ?? Container(),
          LocaleStrings.mainPage.emptyStateTrash,
        );
      case ReturnMode.FAVOURITES:
        return MapEntry(
          appInfo.noFavouritesIllustration ?? Container(),
          LocaleStrings.mainPage.emptyStateFavourites,
        );
      case ReturnMode.TAG:
        return MapEntry(
          appInfo.noNotesIllustration ?? Container(),
          LocaleStrings.mainPage.emptyStateTag,
        );
      case ReturnMode.ALL:
      case ReturnMode.NORMAL:
      default:
        return MapEntry(
          appInfo.noNotesIllustration ?? Container(),
          LocaleStrings.mainPage.emptyStateHome,
        );
    }
  }

  Widget commonNote(Note note) {
    GlobalKey key = GlobalKeyRegistry.get(note.id);

    return NoteView(
      key: key,
      note: note,
      onTap: () async {
        if (selecting) {
          setState(() {
            if (selectionList.any((item) => item.id == note.id)) {
              selectionList.removeWhere((item) => item.id == note.id);
              if (selectionList.isEmpty) selecting = false;
            } else {
              selectionList.add(note);
            }
          });
        } else {
          bool status = false;
          if (note.lockNote && note.usesBiometrics) {
            bool bioAuth = await Utils.showBiometricPrompt();

            if (bioAuth)
              status = bioAuth;
            else
              status = await Utils.showPassChallengeSheet(context) ?? false;
          } else if (note.lockNote && !note.usesBiometrics) {
            status = await Utils.showPassChallengeSheet(context) ?? false;
          } else {
            status = true;
          }

          if (status) {
            Utils.showSecondaryRoute(
              context,
              NotePage(
                note: note,
              ),
            ).then((_) => Utils.handleNotePagePop(note));
          }
        }
      },
      onLongPress: () async {
        if (selecting) return;

        setState(() {
          selecting = true;
          selectionList.add(note);
        });
      },
      selectorOpen: selecting,
      selected: selectionList.any((item) => item.id == note.id),
    );
  }

  List<Widget> get appBarButtons => [
        Visibility(
          visible: widget.noteKind == ReturnMode.ARCHIVE ||
              widget.noteKind == ReturnMode.TRASH,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.settings_backup_restore),
                onPressed: () async {
                  List<Note> notes = await helper.listNotes(widget.noteKind);
                  bool? result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(LocaleStrings.common.areYouSure),
                      content: Text(
                        widget.noteKind == ReturnMode.ARCHIVE
                            ? LocaleStrings.mainPage.restorePromptArchive
                            : LocaleStrings.mainPage.restorePromptTrash,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(LocaleStrings.common.cancel),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(LocaleStrings.common.restore),
                        ),
                      ],
                    ),
                  );

                  if (result ?? false) {
                    await Utils.restoreNotes(
                      context: context,
                      notes: notes,
                      reason: LocaleStrings.mainPage
                          .notesRestored(selectionList.length),
                      archive: widget.noteKind == ReturnMode.ARCHIVE,
                    );
                  }
                },
              );
            },
          ),
        ),
        Visibility(
          visible: widget.noteKind == ReturnMode.TAG,
          child: IconButton(
            icon: Icon(Icons.label_off_outlined),
            onPressed: () async {
              bool result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(LocaleStrings.common.areYouSure),
                      content: Text(LocaleStrings.mainPage.tagDeletePrompt),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(LocaleStrings.common.cancel),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(LocaleStrings.common.delete),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (result) {
                List<Note> notes = await helper.listNotes(ReturnMode.ALL);
                for (Note note in notes) {
                  note.tags.remove(prefs.tags[widget.tagIndex!].id);
                  await helper.saveNote(note.markChanged());
                }
                tagHelper.deleteTag(prefs.tags[widget.tagIndex!]);
                Navigator.pop(context);
              }
            },
          ),
        ),
        Visibility(
          visible: widget.noteKind == ReturnMode.TAG,
          child: IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              Utils.showNotesModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => TagEditor(
                  tag: prefs.tags[widget.tagIndex!],
                  onSave: (tag) {
                    Navigator.pop(context);
                    tagHelper.saveTag(tag.markChanged());
                  },
                ),
              );
            },
          ),
        ),
      ];

  Future<void> sync() async {
    await SyncRoutine().syncNotes();
  }
}
