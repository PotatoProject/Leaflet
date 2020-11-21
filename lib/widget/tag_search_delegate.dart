import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/tag_editor.dart';

class TagSearchDelegate extends CustomSearchDelegate {
  final List<String> tags;
  final VoidCallback? onChanged;

  TagSearchDelegate(
    this.tags, {
    this.onChanged,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Tag> filteredTags;

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
                Icons.label_outlined,
                color: filteredTags[index].color != 0
                    ? Color(
                        NoteColors.colorList[filteredTags[index].color].color)
                    : Theme.of(context).accentColor,
              ),
              title: Text(filteredTags[index].name),
              value: tags.contains(filteredTags[index].id),
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).accentColor,
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    tags.add(filteredTags[index].id);
                  } else {
                    tags.remove(filteredTags[index].id);
                  }
                });

                onChanged?.call();
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
                    tagHelper.saveTag(tag.markChanged());
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
