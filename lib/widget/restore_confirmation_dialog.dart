import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/internal/backup_delegate.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class RestoreConfirmationDialog extends StatelessWidget {
  final NoteBackupMetadata metadata;

  const RestoreConfirmationDialog({
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: const Text("Confirm note restoration"),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 48,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Backup name: ${metadata.name}"),
                const SizedBox(height: 4),
                Text(
                  "Creation date: ${DateFormat("dd MMM yyyy HH:mm").format(metadata.createdAt)}",
                ),
                const SizedBox(height: 4),
                Text("App version: ${metadata.appVersion}"),
                if (metadata.noteCount > 1) const SizedBox(height: 4),
                if (metadata.noteCount > 1)
                  Text("Notes count: ${metadata.noteCount}"),
                const SizedBox(height: 4),
                Text("Tags count: ${metadata.tags.length}"),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
