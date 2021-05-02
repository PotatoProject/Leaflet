import 'dart:io';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/backup_delegate.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/migration_task.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:universal_platform/universal_platform.dart';

class RestoreNotesPage extends StatefulWidget {
  const RestoreNotesPage({Key? key}) : super(key: key);

  @override
  _RestoreNotesPageState createState() => _RestoreNotesPageState();
}

class _RestoreNotesPageState extends State<RestoreNotesPage> {
  Map<String, MetadataExtractionResult>? backups;
  String? selectedBackup;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    final Directory dir = Directory(await BackupDelegate.getOutputDir());
    final Map<String, MetadataExtractionResult> backupsTemp = {};
    await for (final FileSystemEntity entity in dir.list()) {
      if (entity is File && p.extension(entity.path) == ".backup") {
        final MetadataExtractionResult? metadata =
            await BackupDelegate.extractMetadataFromFile(entity.path);
        if (metadata != null) {
          final String key =
              "${metadata.metadata.name}${metadata.metadata.createdAt}";
          backupsTemp[key] = metadata;
        }
      }
    }
    backups = backupsTemp;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (backups != null) {
      if (backups!.isNotEmpty) {
        content = ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final MetadataExtractionResult metadata =
                backups!.values.toList()[index];
            final String key = backups!.keys.toList()[index];
            final String formattedDate = DateFormat('dd MMM yyyy HH:mm')
                .format(metadata.metadata.createdAt);
            final bool fromFile = key.startsWith("file-");
            String cleanName =
                metadata.metadata.name!.replaceAll(".backup", "");
            if (fromFile) cleanName += " (From file)";
            return ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(cleanName),
              subtitle: Text(
                  "Note count: ${metadata.metadata.noteCount}, Tag count: ${metadata.metadata.tags.length}\nCreated on $formattedDate"),
              isThreeLine: true,
              trailing: selectedBackup == key ? const Icon(Icons.check) : null,
              selected: selectedBackup == key,
              onTap: () => setState(() => selectedBackup = key),
            );
          },
          itemCount: backups!.length,
          shrinkWrap: true,
        );
      } else {
        content = const Text(
            "There are no backups available. Try opening a file instead.");
      }
    } else {
      content = const SizedBox(
        height: 72,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return DialogSheetBase(
      title: Row(
        children: [
          const Text("Select backup to restore"),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.note_add_outlined),
            onPressed: () async {
              final String? file = await Utils.pickFile(
                allowedExtensions: [".backup"],
                initialDirectory: await BackupDelegate.getOutputDir(),
              );

              if (file != null && p.extension(file) == ".backup") {
                final MetadataExtractionResult? metadataResult =
                    await BackupDelegate.extractMetadataFromFile(file);

                if (metadataResult != null) {
                  final NoteBackupMetadata metadata = metadataResult.metadata;
                  final String backupKey =
                      "file-${metadata.name}${metadata.createdAt}";
                  backups![backupKey] = metadataResult;
                  selectedBackup = backupKey;
                  setState(() {});
                } else {
                  _unableToRestore(RestoreResultStatus.wrongFormat);
                }
              }
            },
            padding: EdgeInsets.zero,
            tooltip: "Open file",
            splashRadius: 24,
          ),
        ],
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: selectedBackup != null
              ? () async {
                  final String? password =
                      await Utils.showBackupPasswordPrompt(context: context);
                  if (password == null) return;

                  Utils.showLoadingOverlay(context);
                  final RestoreResult result = await backupDelegate.restoreNote(
                      backups![selectedBackup]!, password);
                  Utils.hideLoadingOverlay(context);

                  if (result.status == RestoreResultStatus.success) {
                    context.pop();
                    Utils.showSecondaryRoute(
                      context,
                      _NoteSelectionPage(
                        notes: result.notes,
                        tags: result.tags,
                      ),
                    );
                  } else {
                    _unableToRestore(result.status);
                  }
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
      contentPadding: backups?.isNotEmpty ?? false
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _unableToRestore(RestoreResultStatus status) {
    Utils.showAlertDialog(
      context: context,
      title: const Text("Unable to restore backup"),
      content: Text(
        Utils.getMessageFromRestoreStatus(status),
      ),
    );
  }
}

class ImportNotesPage extends StatefulWidget {
  const ImportNotesPage({Key? key}) : super(key: key);

  @override
  _ImportNotesPageState createState() => _ImportNotesPageState();
}

class _ImportNotesPageState extends State<ImportNotesPage> {
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
    return DialogSheetBase(
      title: const Text("Select import origin"),
      content: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.file_present_outlined),
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
      actions: [
        if (notes != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check,
                color: context.theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                "Notes loaded successfully",
                style: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        const Spacer(),
        TextButton(
          onPressed: notes != null
              ? () {
                  context.pop();
                  Utils.showSecondaryRoute(
                    context,
                    _NoteSelectionPage(notes: notes!),
                  );
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
      contentPadding: EdgeInsets.zero,
    );
  }

  String _getErrorText() {
    if (!UniversalPlatform.isAndroid) {
      return "Only Android supports loading from previous version";
    }

    if (canUseOldDbFile) return "There was no database found from old version";

    return "";
  }
}

class _NoteSelectionPage extends StatefulWidget {
  final List<Note> notes;
  final List<Tag> tags;

  const _NoteSelectionPage({
    Key? key,
    required this.notes,
    this.tags = const [],
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
      appBar: AppBar(
        title: const Text("Select notes to import"),
      ),
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
                overrideTags: widget.tags,
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
                  left: 2,
                  right: 8,
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
                  activeColor: context.theme.colorScheme.secondary,
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
                      if (replaceExistingNotes) {
                        helper.deleteAllNotes();
                        tagHelper.deleteAllTags();
                      }

                      for (final String id in selectedNotes) {
                        final Note note =
                            widget.notes.firstWhere((n) => n.id == id);
                        for (final String tagId in note.tags) {
                          final Tag? tag = widget.tags
                              .firstWhereOrNull((t) => t.id == tagId);
                          if (tag != null) await tagHelper.saveTag(tag);
                        }
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
