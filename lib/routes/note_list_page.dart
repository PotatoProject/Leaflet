import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/selection_state.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/default_app_bar.dart';
import 'package:potato_notes/widget/dependent_scaffold.dart';
import 'package:potato_notes/widget/fake_appbar.dart';
import 'package:potato_notes/widget/menu_fab.dart';
import 'package:potato_notes/widget/new_note_bar.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:universal_platform/universal_platform.dart';

class NoteListPage extends StatefulWidget {
  final Folder folder;
  final SelectionOptions selectionOptions;

  const NoteListPage({
    Key? key,
    required this.folder,
    required this.selectionOptions,
  }) : super(key: key);

  @override
  NoteListPageState createState() => NoteListPageState();
}

class NoteListPageState extends State<NoteListPage> {
  late SelectionState _selectionState;

  bool _backButtonSelectionClosingInterceptor(
    bool stopDefaultEvent,
    RouteInfo info,
  ) {
    if (_selectionState.selecting) {
      _selectionState.closeSelection();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _selectionState = SelectionState(
      options: widget.selectionOptions,
      folder: widget.folder,
      onSelectionChanged: (value) {
        //context.basePage!.setNavigationEnabled(!value);
      },
    );
    _selectionState.selectingNotifier.addListener(() => setState(() {}));
    BackButtonInterceptor.add(_backButtonSelectionClosingInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_backButtonSelectionClosingInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionStateWidget.withState(
      state: _selectionState,
      child: DependentScaffold(
        appBar: FakeAppbar(
          child: SelectionStateWidget.withState(
            state: _selectionState,
            child: _selectionState.selecting
                ? const SelectionBar()
                : const DefaultAppBar(/* extraActions: appBarButtons */),
          ),
        ),
        useAppBarAsSecondary: _selectionState.selecting,
        secondaryAppBar: !widget.folder.readOnly && !_selectionState.selecting
            ? NewNoteBar(folder: widget.folder)
            : null,
        body: StreamBuilder<List<Note>>(
          stream: noteHelper.watchNotes(widget.folder),
          initialData: const [],
          builder: (context, snapshot) {
            final List<Note> notes = snapshot.data ?? [];

            return NoteListWidget(
              itemBuilder: (_, index) => _buildNoteList(context, notes, index),
              gridView: prefs.useGrid,
              noteCount: notes.length,
              folder: widget.folder,
              primary: UniversalPlatform.isIOS,
            );
          },
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton:
            !widget.folder.readOnly && !_selectionState.selecting ? fab : null,
      ),
    );
  }

  Widget get fab {
    return MenuFab(
      backgroundColor: context.theme.colorScheme.secondary,
      foregroundColor: context.theme.colorScheme.onPrimary,
      mainEntry: MenuFabEntry(
        icon: const Icon(Icons.edit_outlined),
        label: LocaleStrings.common.newNote,
        onTap: () => Utils.newNote(context, widget.folder),
      ),
      entries: [
        MenuFabEntry(
          icon: const Icon(Icons.note_add_outlined),
          label: LocaleStrings.common.importNote,
          onTap: () => Utils.importNotes(context),
        ),
        MenuFabEntry(
          icon: const Icon(Icons.check_box_outlined),
          label: LocaleStrings.common.newList,
          onTap: () => Utils.newList(context, widget.folder),
        ),
        MenuFabEntry(
          icon: const Icon(Icons.image_outlined),
          label: LocaleStrings.common.newImage,
          onTap: () =>
              Utils.newImage(context, widget.folder, ImageSource.gallery),
        ),
        MenuFabEntry(
          icon: const Icon(Icons.brush_outlined),
          label: LocaleStrings.common.newDrawing,
          onTap: () => Utils.newDrawing(context, widget.folder),
        ),
      ],
    );
  }

  /* List<Widget> get appBarButtons => [
        Visibility(
          visible: widget.noteKind == ReturnMode.archive ||
              widget.noteKind == ReturnMode.trash,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.settings_backup_restore),
                onPressed: () async {
                  final List<Note> notes =
                      await noteHelper.listNotes(widget.noteKind);
                  final bool? result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(LocaleStrings.common.areYouSure),
                      content: Text(
                        widget.noteKind == ReturnMode.archive
                            ? LocaleStrings.mainPage.restorePromptArchive
                            : LocaleStrings.mainPage.restorePromptTrash,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(LocaleStrings.common.cancel),
                        ),
                        TextButton(
                          onPressed: () => context.pop(true),
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
                          .notesRestored(_selectionState.selectionList.length),
                      archive: widget.noteKind == ReturnMode.archive,
                    );
                  }
                },
              );
            },
          ),
        ),
      ]; */

  Widget _buildNoteList(BuildContext context, List<Note> notes, int index) {
    final _state = context.selectionState;
    final Note note = notes[index];

    return NoteView(
      note: note,
      onTap: () => _onNoteTap(context, note),
      onLongPress: () => _onNoteLongPress(context, note),
      selectorOpen: _state.selecting,
      selected: _state.selectionList.any((item) => item.id == note.id),
      onCheckboxChanged: (value) {
        if (!value!) {
          _state.removeSelectedNoteWhere((item) => item.id == note.id);
          if (_state.selectionList.isEmpty) _state.selecting = false;
        } else {
          _state.selecting = true;
          _state.addSelectedNote(note);
        }
        //context.basePage!.setNavigationEnabled(!_state.selecting);
      },
      allowSelection: true,
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    final _state = context.selectionState;

    if (_state.selecting) {
      if (_state.selectionList.any((item) => item.id == note.id)) {
        _state.removeSelectedNoteWhere((item) => item.id == note.id);
        if (_state.selectionList.isEmpty) _state.selecting = false;
      } else {
        _state.addSelectedNote(note);
      }
    } else {
      final bool status = await Utils.showNoteLockDialog(
        context: context,
        showLock: note.lockNote,
        showBiometrics: note.usesBiometrics,
      );

      if (status) {
        await Utils.showSecondaryRoute(
          context,
          NotePage(
            note: note,
          ),
        );
        Utils.handleNotePagePop(note);
      }
    }
  }

  void _onNoteLongPress(BuildContext context, Note note) {
    final _state = context.selectionState;

    if (_state.selecting) return;

    _state.selecting = true;
    _state.addSelectedNote(note);
  }
}
