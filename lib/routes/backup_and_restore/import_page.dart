import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/migration_task.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  List<Note> loadedNotes;

  @override
  Widget build(BuildContext context) {
    final Widget page = loadedNotes == null
        ? _FileSelectionPage(
            onNextTapped: (notes) => setState(() => loadedNotes = notes),
          )
        : _NoteSelectionPage(
            notes: loadedNotes,
          );

    return Scaffold(
      appBar: AppBar(),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
            fillColor: Colors.transparent,
          );
        },
        child: page,
      ),
    );
  }
}

typedef void LoadedNotesCallback(List<Note> result);

class _FileSelectionPage extends StatefulWidget {
  final LoadedNotesCallback onNextTapped;

  _FileSelectionPage({
    Key key,
    this.onNextTapped,
  }) : super(key: key);

  @override
  _FileSelectionPageState createState() => _FileSelectionPageState();
}

class _FileSelectionPageState extends State<_FileSelectionPage> {
  bool canUseOldDbFile = false;
  List<Note> notes;

  @override
  void initState() {
    super.initState();
    _checkIfCanMigrateFromOldDbFile();
  }

  void _checkIfCanMigrateFromOldDbFile() async {
    final String file = await MigrationTask.v1DatabasePath;

    canUseOldDbFile =
        !DeviceInfo.isDesktop && await MigrationTask.isMigrationAvailable(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text("To begin migration select a database file to open."),
          ListTile(
            leading: Icon(MdiIcons.fileRestoreOutline),
            title: Text("Open PotatoNotes backup file"),
            onTap: () async {
              final dynamic asyncFile = DeviceInfo.isDesktop
                  ? await openFile(
                      acceptedTypeGroups: [
                        XTypeGroup(
                          label: "PotatoNotes database",
                          extensions: ["db"],
                        ),
                      ],
                    )
                  : await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );

              if (asyncFile == null) return;

              final dynamic file =
                  DeviceInfo.isDesktop ? asyncFile : asyncFile.files.first;

              if (file.path != null && p.extension(file.path) == ".db") {
                bool canMigrate =
                    await MigrationTask.isMigrationAvailable(file.path);

                if (canMigrate) {
                  notes = await MigrationTask.migrate(file.path);
                }

                setState(() {});
              }

              setState(() {});
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.databaseOutline),
            title: Text("Open previous version database"),
            enabled: canUseOldDbFile,
            onTap: () async {
              final String file = await MigrationTask.v1DatabasePath;
              notes = await MigrationTask.migrate(file);

              setState(() {});
            },
            subtitle: !canUseOldDbFile
                ? Text(
                    _getErrorText(),
                    style: TextStyle(color: Colors.red),
                  )
                : null,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (notes != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Notes loaded successfully",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            Spacer(),
            TextButton(
              onPressed: notes != null
                  ? () {
                      widget.onNextTapped?.call(notes);
                    }
                  : null,
              child: Text(
                LocaleStrings.setup.buttonNext.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorText() {
    if (DeviceInfo.isDesktop)
      return "Desktop does not support loading from previous version";

    if (canUseOldDbFile) return "There was no database found from old version";

    return "";
  }
}

class _NoteSelectionPage extends StatefulWidget {
  final List<Note> notes;

  _NoteSelectionPage({
    Key key,
    @required this.notes,
  }) : super(key: key);

  @override
  _NoteSelectionPageState createState() => _NoteSelectionPageState();
}

class _NoteSelectionPageState extends State<_NoteSelectionPage> {
  final List<String> selectedNotes = [];
  bool replaceExistingNotes = false;

  @override
  void initState() {
    super.initState();
    selectedNotes.addAll(
      List.generate(
        widget.notes.length,
        (index) => widget.notes[index].id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return NoteListWidget(
            itemBuilder: (context, index) {
              final Note note = widget.notes[index];

              return NoteView(
                note: note,
                selected: selectedNotes.contains(note.id),
                allowSelection: true,
                selectorOpen: true,
                onTap: () {
                  final bool value = selectedNotes.contains(note.id);

                  if (!value) {
                    selectedNotes.add(note.id);
                  } else {
                    selectedNotes.remove(note.id);
                  }
                  setState(() {});
                },
                onCheckboxChanged: (value) {
                  if (value) {
                    selectedNotes.add(note.id);
                  } else {
                    selectedNotes.remove(note.id);
                  }
                  setState(() {});
                },
              );
            },
            noteCount: widget.notes.length,
            gridColumns: deviceInfo.uiSizeFactor.clamp(0, 4),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                ),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 16,
                ),
              ),
              onPressed: () => setState(
                () => replaceExistingNotes = !replaceExistingNotes,
              ),
              icon: IgnorePointer(
                child: NoteViewCheckbox(
                  value: replaceExistingNotes,
                  onChanged: (value) {},
                  checkColor: Theme.of(context).scaffoldBackgroundColor,
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              label: Text(
                "Replace existing notes",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                ),
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: selectedNotes.isNotEmpty
                  ? () async {
                      if (replaceExistingNotes) helper.deleteAllNotes();

                      for (final String id in selectedNotes) {
                        final Note note =
                            widget.notes.firstWhere((n) => n.id == id);
                        await helper.saveNote(note);
                      }

                      Navigator.pop(context);
                    }
                  : null,
              icon: Icon(Icons.check),
              label: Text(
                LocaleStrings.setup.buttonFinish.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
