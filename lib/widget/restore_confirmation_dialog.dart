import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/internal/backup_delegate.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class RestoreConfirmationDialog extends StatelessWidget {
  final NoteBackupMetadata metadata;

  const RestoreConfirmationDialog({
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Text(strings.common.restoreDialogTitle),
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
                  strings.common.restoreDialogBackupName(metadata.name),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.common.restoreDialogCreationDate(
                    DateFormat("dd MMM yyyy HH:mm").format(metadata.createdAt),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.common.restoreDialogAppVersion(metadata.appVersion),
                ),
                if (metadata.noteCount > 1) const SizedBox(height: 4),
                if (metadata.noteCount > 1)
                  Text(
                    strings.common.restoreDialogNoteCount(metadata.noteCount),
                  ),
                const SizedBox(height: 4),
                Text(
                  strings.common.restoreDialogTagCount(metadata.tags.length),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(strings.common.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(strings.common.confirm),
        ),
      ],
    );
  }
}
