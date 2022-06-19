import 'package:flutter/material.dart';
import 'package:liblymph/database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';
import 'package:potato_notes/widget/separated_list.dart';

class FolderEditor extends StatefulWidget {
  final Folder? folder;
  final String initialInput;
  final ValueChanged<Folder>? onSave;
  final ValueChanged<Folder>? onDelete;

  const FolderEditor({
    this.folder,
    this.initialInput = "",
    this.onSave,
    this.onDelete,
  });

  @override
  _FolderEditorState createState() => _FolderEditorState();
}

class _FolderEditorState extends State<FolderEditor> {
  Folder folder = Folder(
    id: "",
    name: "",
    color: 0,
    icon: 0,
    readOnly: false,
    lastChanged: DateTime.now(),
  );
  late TextEditingController controller;

  @override
  void initState() {
    if (widget.folder == null) {
      folder = folder.copyWith(id: Utils.generateId());
      folder = folder.copyWith(name: widget.initialInput);
    } else {
      folder = widget.folder!;
    }

    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.folder != null ? "Edit folder" : "New folder",
            ),
          ),
          IconButton(
            onPressed: () async {
              final int? newIcon = await Utils.showModalBottomSheet<int>(
                context: context,
                builder: (context) => _FolderIconPicker(
                  initialIcon: folder.icon,
                ),
              );

              if (newIcon != null) {
                folder = folder.copyWith(icon: newIcon);
                setState(() {});
              }
            },
            icon: Icon(Utils.getIconForFolder(folder)),
            padding: EdgeInsets.zero,
            tooltip: "Pick an icon",
            splashRadius: 24,
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SeparatedList(
          separator: const SizedBox(height: 8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: LocaleStrings.common.tagTextboxHint,
                  border: const UnderlineInputBorder(),
                ),
                autofocus: true,
                initialValue: folder.name,
                onFieldSubmitted: folder.name.trim().isNotEmpty
                    ? (text) => _onSubmit(text)
                    : null,
                maxLength: 30,
                onChanged: (text) => setState(
                  () => folder = folder.copyWith(name: text),
                ),
              ),
            ),
            CheckboxListTile(
              secondary: const Icon(MdiIcons.fileEyeOutline),
              title: const Text("Read only"),
              subtitle: const Text(
                "Notes inside this folder won't be allowed to be edited",
              ),
              value: folder.readOnly,
              onChanged: (value) => setState(
                () => folder = folder.copyWith(readOnly: value),
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        if (widget.folder != null)
          TextButton(
            onPressed: () => widget.onDelete?.call(folder),
            child: Text(LocaleStrings.common.delete),
          ),
        TextButton(
          onPressed: folder.name.trim().isNotEmpty
              ? () => _onSubmit(folder.name)
              : null,
          child: Text(LocaleStrings.common.save),
        ),
      ],
    );
  }

  void _onSubmit(String text) {
    widget.onSave?.call(
      folder.copyWith(name: text.trim()),
    );
  }
}

class _FolderIconPicker extends StatefulWidget {
  final int initialIcon;

  const _FolderIconPicker({
    required this.initialIcon,
    Key? key,
  }) : super(key: key);

  @override
  State<_FolderIconPicker> createState() => _FolderIconPickerState();
}

class _FolderIconPickerState extends State<_FolderIconPicker> {
  late int icon = widget.initialIcon;

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      //title: const Text("Pick an icon"),
      content: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 64,
        ),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() => icon = index);
          },
          child: Center(
            child: Icon(
              Constants.folderDefaultIcons[index],
              size: 32,
              color: index == icon ? context.theme.colorScheme.primary : null,
            ),
          ),
        ),
        itemCount: Constants.folderDefaultIcons.length,
        shrinkWrap: true,
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleStrings.common.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, icon),
          child: Text(LocaleStrings.common.confirm),
        ),
      ],
    );
  }
}
