import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/data/dao/folder_helper.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/file_system_helper.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';
import 'package:universal_platform/universal_platform.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final List<Note> notes = [];
  String name = "";
  String password = "";
  bool useMasterPass = false;
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    _initNotes();
  }

  Future<void> _initNotes() async {
    notes.addAll(await noteHelper.listNotes(BuiltInFolders.all));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Text(LocaleStrings.backupRestore.backupTitle),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.archive_outlined,
                  size: 64,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        obscureText: !showPass,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () =>
                                setState(() => showPass = !showPass),
                          ),
                          hintText: LocaleStrings.backupRestore.backupPassword,
                          hintStyle: TextStyle(
                            color: context.theme.hintColor
                                .withOpacity(useMasterPass ? 0.2 : 0.6),
                          ),
                        ),
                        style: TextStyle(
                          color: context.theme.textTheme.bodyText2!.color!
                              .withOpacity(useMasterPass ? 0.4 : 1.0),
                        ),
                        maxLength: 64,
                        onChanged: (value) {
                          password = value;
                          setState(() {});
                        },
                        enabled: !useMasterPass,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: LocaleStrings.backupRestore.backupName,
                        ),
                        maxLength: 64,
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: useMasterPass,
            title: Text(LocaleStrings.common.backupPasswordUseMasterPass),
            secondary: const Icon(Icons.vpn_key_outlined),
            onChanged: prefs.masterPass != ""
                ? (value) => setState(() => useMasterPass = value!)
                : null,
            subtitle: prefs.masterPass == ""
                ? Text(
                    LocaleStrings.notePage.privacyLockNoteMissingPass,
                    style: const TextStyle(color: Colors.red),
                  )
                : null,
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        Text(
          LocaleStrings.backupRestore.backupNumOfNotes(notes.length),
          style: TextStyle(
            color: context.theme.iconTheme.color,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: password.length >= 4 || useMasterPass ? _onSubmit : null,
          child: Text(LocaleStrings.common.create.toUpperCase()),
        ),
      ],
    );
  }

  Future<void> _onSubmit() async {
    final bool promptForPassword = notes.any((n) => n.lockNote);
    final bool promptForBiometrics = notes.any((n) => n.lockNote);
    bool status = true;
    if (promptForPassword) {
      status = await Utils.showNoteLockDialog(
        context: context,
        showLock: promptForPassword,
        showBiometrics: promptForBiometrics,
        description: useMasterPass
            ? null
            : LocaleStrings.backupRestore.backupProtectedNotesPrompt,
      );
    }
    if (status && mounted) {
      context.pop();
      Utils.showModalBottomSheet(
        context: context,
        builder: (context) => _BackupProgressPage(
          notes: notes,
          password:
              useMasterPass ? prefs.masterPass : Utils.hashedPass(password),
          name: name.trim() != "" ? name : null,
        ),
        enableDismiss: false,
      );
    }
  }
}

class _BackupProgressPage extends StatefulWidget {
  final List<Note> notes;
  final String password;
  final String? name;

  const _BackupProgressPage({
    required this.notes,
    required this.password,
    this.name,
  });

  @override
  _BackupProgressPageState createState() => _BackupProgressPageState();
}

class _BackupProgressPageState extends State<_BackupProgressPage> {
  int currentNote = 0;

  @override
  void initState() {
    super.initState();
    _startBackup();
  }

  Future<void> _startBackup() async {
    final String formattedDate =
        DateFormat("dd_MM_yyyy-HH_mm_ss").format(DateTime.now());
    final String _name = widget.name ?? formattedDate;
    final String name = "backup-$_name.backup";
    final String backup = await backupDelegate.createBackup(
      notes: widget.notes,
      password: widget.password,
      name: name,
      onProgress: (value) => setState(() => currentNote = value),
    );
    final SaveFileResult backupPath = await FileSystemHelper.saveFile(
      inputFile: backup,
      outputPath: appDirectories.backupDirectory.path,
      name: name,
    );

    if (backupPath.success &&
        backupPath.path != null &&
        (!UniversalPlatform.isLinux && !UniversalPlatform.isWindows)) {
      await File(backup).copy(backupPath.path!);
    }

    if (!mounted) return;
    context.pop();
    Utils.showModalBottomSheet(
      context: context,
      builder: (context) => _BackupCompletePage(
        backupFile: backupPath.path != null && !UniversalPlatform.isMacOS
            ? File(backupPath.path!)
            : null,
        cancelled: !backupPath.success,
      ),
      enableDismiss: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            LocaleStrings.backupRestore.backupCreating,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: Text(
            LocaleStrings.backupRestore.backupCreatingProgress(
              currentNote,
              widget.notes.length,
            ),
          ),
          trailing: const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}

class _BackupCompletePage extends StatelessWidget {
  final File? backupFile;
  final bool cancelled;

  const _BackupCompletePage({
    this.backupFile,
    this.cancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    final String title = !cancelled
        ? LocaleStrings.backupRestore.backupCompleteSuccess
        : LocaleStrings.backupRestore.backupCompleteFailure;
    final String description = !cancelled
        ? backupFile != null
            ? LocaleStrings.backupRestore.backupCompleteDescSuccess
            : LocaleStrings.backupRestore.backupCompleteDescSuccessNoFile
        : LocaleStrings.backupRestore.backupCompleteDescFailure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: description,
                ),
                if (backupFile != null)
                  TextSpan(
                    text: backupFile!.path,
                    style: TextStyle(
                      color: context.theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Utils.launchUrl("file://${backupFile!.parent.path}/");
                      },
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(LocaleStrings.common.close.toUpperCase()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
