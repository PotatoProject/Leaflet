import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/migration_task.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  List<Note>? loadedNotes;

  @override
  Widget build(BuildContext context) {
    final Widget page = loadedNotes == null
        ? _FileSelectionPage(
            onNextTapped: (notes) => setState(() => loadedNotes = notes),
          )
        : _NoteSelectionPage(
            notes: loadedNotes!,
          );

    return Scaffold(
      appBar: AppBar(),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        child: page,
      ),
    );
  }
}

typedef LoadedNotesCallback = void Function(List<Note> result);

class _FileSelectionPage extends StatefulWidget {
  final LoadedNotesCallback? onNextTapped;

  const _FileSelectionPage({
    Key? key,
    this.onNextTapped,
  }) : super(key: key);

  @override
  _FileSelectionPageState createState() => _FileSelectionPageState();
}

class _FileSelectionPageState extends State<_FileSelectionPage> {
  bool canUseOldDbFile = false;
  List<Note>? notes;

  @override
  void initState() {
    super.initState();
    _checkIfCanMigrateFromOldDbFile();
  }

  Future<void> _checkIfCanMigrateFromOldDbFile() async {
    final String file = await MigrationTask.v1DatabasePath;

    canUseOldDbFile =
        !DeviceInfo.isDesktop && await MigrationTask.isMigrationAvailable(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Text("To begin migration select a database file to open."),
          ListTile(
            leading: const Icon(MdiIcons.fileRestoreOutline),
            title: const Text("Open PotatoNotes backup file"),
            onTap: () async {
              final String? pickedFilePath = await Utils.pickFile(
                allowedExtensions: ["db"],
              );

              if (pickedFilePath != null &&
                  p.extension(pickedFilePath) == ".db") {
                final bool canMigrate =
                    await MigrationTask.isMigrationAvailable(pickedFilePath);

                if (canMigrate) {
                  notes = await MigrationTask.migrate(pickedFilePath);
                }

                setState(() {});
              }

              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(MdiIcons.databaseOutline),
            title: const Text("Open previous version database"),
            enabled: canUseOldDbFile,
            onTap: () async {
              final String file = await MigrationTask.v1DatabasePath;
              notes = await MigrationTask.migrate(file);

              setState(() {});
            },
            subtitle: !canUseOldDbFile
                ? Text(
                    _getErrorText(),
                    style: const TextStyle(color: Colors.red),
                  )
                : null,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (notes != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: context.theme.accentColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Notes loaded successfully",
                    style: TextStyle(
                      color: context.theme.accentColor,
                    ),
                  ),
                ],
              ),
            const Spacer(),
            TextButton(
              onPressed: notes != null
                  ? () {
                      widget.onNextTapped?.call(notes!);
                    }
                  : null,
              child: Text(
                LocaleStrings.setup.buttonNext.toUpperCase(),
                style: const TextStyle(
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
    if (DeviceInfo.isDesktop) {
      return "Desktop does not support loading from previous version";
    }

    if (canUseOldDbFile) return "There was no database found from old version";

    return "";
  }
}

class _NoteSelectionPage extends StatefulWidget {
  final List<Note> notes;

  const _NoteSelectionPage({
    Key? key,
    required this.notes,
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
                  if (value!) {
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: context.theme.textTheme.bodyText2!.color,
                ),
                padding: const EdgeInsets.only(
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
                  checkColor: context.theme.scaffoldBackgroundColor,
                  activeColor: context.theme.accentColor,
                ),
              ),
              label: Text(
                "Replace existing notes",
                style: TextStyle(
                  color: context.theme.textTheme.bodyText2!.color,
                ),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: selectedNotes.isNotEmpty
                  ? () async {
                      if (replaceExistingNotes) helper.deleteAllNotes();

                      for (final String id in selectedNotes) {
                        final Note note =
                            widget.notes.firstWhere((n) => n.id == id);
                        await helper.saveNote(note);
                      }

                      context.pop();
                    }
                  : null,
              icon: const Icon(Icons.check),
              label: Text(
                LocaleStrings.setup.buttonFinish.toUpperCase(),
                style: const TextStyle(
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
