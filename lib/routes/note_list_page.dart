import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/global_key_registry.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
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

class NoteListPage extends StatefulWidget {
  final ReturnMode noteKind;
  final SelectionOptions selectionOptions;

  const NoteListPage({
    Key? key,
    required this.noteKind,
    required this.selectionOptions,
  }) : super(key: key);

  @override
  NoteListPageState createState() => NoteListPageState();
}

class NoteListPageState extends State<NoteListPage> {
  bool _selecting = false;
  final List<Note> _selectionList = [];

  SelectionOptions get selectionOptions => widget.selectionOptions;

  bool get selecting => _selecting;
  set selecting(bool value) {
    _selecting = value;
    context.basePage!.setBottomBarEnabled(!value);
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  List<Note> get selectionList => _selectionList;

  void addSelectedNote(Note note) {
    _selectionList.add(note);
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  void removeSelectedNoteWhere(bool Function(Note) test) {
    _selectionList.removeWhere(test);
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  void closeSelection() {
    selecting = false;
    _selectionList.clear();
    setState(() {});
  }

  bool _backButtonSelectionClosingInterceptor(
    bool stopDefaultEvent,
    RouteInfo info,
  ) {
    if (selecting) {
      closeSelection();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_backButtonSelectionClosingInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_backButtonSelectionClosingInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionState(
      state: this,
      child: DependentScaffold(
        appBar: FakeAppbar(
          child: SelectionState(
            state: this,
            child: selecting
                ? const SelectionBar()
                : DefaultAppBar(
                    extraActions: appBarButtons,
                    title: Text(Utils.getNameFromMode(widget.noteKind)),
                  ),
          ),
        ),
        useAppBarAsSecondary: selecting,
        secondaryAppBar: widget.noteKind == ReturnMode.normal && !selecting
            ? NewNoteBar()
            : null,
        body: StreamBuilder<List<Note>>(
          stream: helper.noteStream(widget.noteKind),
          initialData: const [],
          builder: (context, snapshot) {
            return NoteListWidget(
              itemBuilder: (_, index) =>
                  _buildNoteList(context, snapshot.data!, index),
              noteCount: snapshot.data!.length,
              noteKind: widget.noteKind,
            );
          },
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton:
            widget.noteKind == ReturnMode.normal && !selecting ? fab : null,
      ),
    );
  }

  Widget get fab {
    return MenuFab(
      backgroundColor: context.theme.accentColor,
      foregroundColor: context.theme.colorScheme.onPrimary,
      fabShape: const CircleBorder(),
      menuShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      mainEntry: MenuFabEntry(
        icon: const Icon(Icons.edit_outlined),
        label: LocaleStrings.common.newNote,
        onTap: () => Utils.newNote(context),
      ),
      entries: [
        MenuFabEntry(
          icon: const Icon(Icons.check_box_outlined),
          label: LocaleStrings.common.newList,
          onTap: () => Utils.newList(context),
        ),
        MenuFabEntry(
          icon: const Icon(Icons.image_outlined),
          label: LocaleStrings.common.newImage,
          onTap: () => Utils.newImage(context, ImageSource.gallery),
        ),
        MenuFabEntry(
          icon: const Icon(Icons.brush_outlined),
          label: LocaleStrings.common.newDrawing,
          onTap: () => Utils.newDrawing(context),
        ),
      ],
    );
  }

  List<Widget> get appBarButtons => [
        Visibility(
          visible: widget.noteKind == ReturnMode.archive ||
              widget.noteKind == ReturnMode.trash,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.settings_backup_restore),
                onPressed: () async {
                  final List<Note> notes =
                      await helper.listNotes(widget.noteKind);
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
                          .notesRestored(_selectionList.length),
                      archive: widget.noteKind == ReturnMode.archive,
                    );
                  }
                },
              );
            },
          ),
        ),
      ];

  Widget _buildNoteList(BuildContext context, List<Note> notes, int index) {
    final _state = context.selectionState;
    final Note note = notes[index];

    return NoteView(
      key: GlobalKeyRegistry.get(note.id),
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
        context.basePage!.setBottomBarEnabled(!_state.selecting);
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

class SelectionState extends InheritedWidget {
  @protected
  final NoteListPageState state;

  const SelectionState({
    required this.state,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant SelectionState old) {
    return state != old.state;
  }

  static NoteListPageState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SelectionState>()!.state;
  }
}
