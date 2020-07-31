import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/tag_model.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/tag_editor.dart';

class TagSearchDelegate extends CustomSearchDelegate {
  final Note note;

  TagSearchDelegate(this.note);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildResults(BuildContext context) {
    List<TagModel> filteredTags;

    if (query.isEmpty) {
      filteredTags = prefs.tags;
    } else {
      filteredTags = prefs.tags
          .where(
            (tag) => tag.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    return StatefulBuilder(
      builder: (context, setState) => ListView(
        children: [
          ...List.generate(
            filteredTags.length,
            (index) => CheckboxListTile(
              secondary: Icon(
                MdiIcons.tagOutline,
                color: filteredTags[index].color != 0
                    ? Color(
                        NoteColors.colorList[filteredTags[index].color].color)
                    : Theme.of(context).accentColor,
              ),
              title: Text(filteredTags[index].name),
              value: note.tags.tagIds.contains(filteredTags[index].id),
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).accentColor,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    note.tags.tagIds.add(filteredTags[index].id);
                  } else {
                    note.tags.tagIds.remove(filteredTags[index].id);
                  }
                });

                helper.saveNote(note);
              },
            ),
          ),
          Visibility(
            visible: query.isNotEmpty,
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text(LocaleStrings.searchPage.tagCreateHint(query)),
              onTap: () => Utils.showNotesModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => TagEditor(
                  initialInput: query,
                  onSave: (tag) {
                    Navigator.pop(context);
                    prefs.tags = prefs.tags..add(tag);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
