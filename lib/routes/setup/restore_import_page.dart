import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/backup_and_restore/restore_page.dart';
import 'package:potato_notes/widget/illustrations.dart';

class BackupRestorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(MdiIcons.zipBoxOutline),
        title: Text(LocaleStrings.setup.restoreImportTitle),
        textTheme: context.theme.textTheme,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.only(
          top: 16 + 56 + context.padding.top,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleStrings.setup.restoreImportDesc),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Align(
                  child: Illustration.backupRestore(
                    brightness: context.theme.brightness,
                    height: min(constraints.maxHeight, 260),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: context.padding.bottom),
        color: context.theme.appBarTheme.color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () async {
                await Utils.showModalBottomSheet(
                  context: context,
                  builder: (context) => const RestoreNotesPage(),
                );
              },
              label: Text(
                LocaleStrings.setup.restoreImportRestoreBtn.toUpperCase(),
              ),
              icon: const Icon(Icons.restart_alt_rounded),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () async {
                await Utils.showModalBottomSheet(
                  context: context,
                  builder: (context) => const ImportNotesPage(),
                );
              },
              label: Text(
                LocaleStrings.setup.restoreImportImportBtn.toUpperCase(),
              ),
              icon: const Icon(Icons.file_present_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
