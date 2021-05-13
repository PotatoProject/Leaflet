import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/internal/backup_delegate.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class RestoreConfirmationDialog extends StatelessWidget {
  final NoteBackupMetadata metadata;

  const RestoreConfirmationDialog({
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Text(LocaleStrings.common.restoreDialogTitle),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.description_outlined, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleStrings.common.restoreDialogBackupName(metadata.name),
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleStrings.common.restoreDialogCreationDate(
                    DateFormat("dd MMM yyyy HH:mm").format(metadata.createdAt),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleStrings.common
                      .restoreDialogAppVersion(metadata.appVersion),
                ),
                if (metadata.noteCount > 1) const SizedBox(height: 4),
                if (metadata.noteCount > 1)
                  Text(
                    LocaleStrings.common
                        .restoreDialogNoteCount(metadata.noteCount),
                  ),
                const SizedBox(height: 4),
                Text(
                  LocaleStrings.common
                      .restoreDialogTagCount(metadata.tags.length),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(LocaleStrings.common.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(LocaleStrings.common.confirm),
        ),
      ],
    );
  }
}
