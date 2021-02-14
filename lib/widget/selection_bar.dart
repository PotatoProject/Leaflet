import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/note_list_page.dart';
import 'package:potato_notes/widget/popup_menu_item_with_icon.dart';

class SelectionBar extends StatelessWidget implements PreferredSizeWidget {
  SelectionBar();

  @override
  Size get preferredSize {
    return Size.fromHeight(56.0);
  }

  @override
  Widget build(BuildContext context) {
    final state = SelectionState.of(context);
    final List<Note> selectionList = state.selectionList;
    final SelectionOptions selectionOptions = state.selectionOptions;
    final List<SelectionOptionEntry> everyOption =
        selectionOptions.options(context, selectionList);
    final List<SelectionOptionEntry> options = everyOption
        .where((e) => !e.oneNoteOnly && !e.showOnlyOnRightClickMenu)
        .toList();
    final List<SelectionOptionEntry> oneNoteOptions = everyOption
        .where((e) => e.oneNoteOnly && !e.showOnlyOnRightClickMenu)
        .toList();

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        padding: EdgeInsets.all(0),
        onPressed: state.closeSelection,
        tooltip: LocaleStrings.mainPage.selectionBarClose,
      ),
      title: Text(
        selectionList.length.toString(),
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        ...options
            .map(
              (e) => IconButton(
                icon: Icon(e.icon),
                tooltip: e.title,
                onPressed: () {
                  selectionOptions.onSelected(context, selectionList, e.value);
                },
              ),
            )
            .toList(),
        if ((oneNoteOptions?.isNotEmpty ?? false) && selectionList.length == 1)
          PopupMenuButton(
            itemBuilder: (context) => oneNoteOptions
                .map<PopupMenuEntry>(
                  (e) => PopupMenuItemWithIcon(
                    icon: Icon(e.icon),
                    child: Text(e.title),
                    value: e.value,
                  ),
                )
                .toList(),
            onSelected: (value) => selectionOptions.onSelected(
              context,
              [selectionList.first],
              value,
            ),
          ),
      ],
    );
  }
}

typedef SelectionOptionsCallback = List<SelectionOptionEntry> Function(
    BuildContext context, List<Note> notes);

typedef SelectionOneNoteOptionsCallback = List<SelectionOptionEntry> Function(
    BuildContext context, Note note);

typedef SelectedCallback = Future<void> Function(
    BuildContext context, List<Note> notes, String value);

@immutable
class SelectionOptions {
  /// Options to build for the selection bar
  final SelectionOptionsCallback options;

  /// This callback gets called once the user selects an option
  final SelectedCallback onSelected;

  const SelectionOptions({
    @required this.options,
    this.onSelected,
  }) : assert(options != null);
}

@immutable
class SelectionOptionEntry {
  final String title;
  final IconData icon;
  final String value;
  final bool oneNoteOnly;
  final bool showOnlyOnRightClickMenu;

  const SelectionOptionEntry({
    @required this.title,
    @required this.icon,
    @required this.value,
    this.oneNoteOnly = false,
    this.showOnlyOnRightClickMenu = false,
  });
}
