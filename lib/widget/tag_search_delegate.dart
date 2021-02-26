import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:potato_notes/widget/tag_editor.dart';

class TagSearchDelegate extends CustomSearchDelegate {
  final List<String> tags;
  final VoidCallback onChanged;

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
    final List<Tag> filteredTags = [];

    if (query.isEmpty) {
      filteredTags.addAll(prefs.tags as List<Tag>);
    } else {
      filteredTags.addAll(
        (prefs.tags as List<Tag>)
            .where(
              (tag) => tag.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }

    return ListView(
      children: [
        ...List.generate(
          filteredTags.length,
          (index) => _TapIsolatedListTile(
            leading: NoteViewCheckbox(
              value: tags.contains(filteredTags[index].id),
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).accentColor,
              onChanged: (value) =>
                  _onChangeValue(value, filteredTags[index].id),
              width: 18,
            ),
            title: Text(filteredTags[index].name),
            trailing: IconButton(
              icon: Icon(Icons.edit_outlined),
              padding: EdgeInsets.zero,
              splashRadius: 24,
              onPressed: () => Utils.showNotesModalBottomSheet(
                context: context,
                builder: (context) => TagEditor(
                  initialInput: query,
                  tag: filteredTags[index],
                  onSave: (tag) {
                    Navigator.pop(context);
                    tagHelper.saveTag(tag.markChanged());

                    onChanged?.call();
                  },
                  onDelete: (tag) {
                    Navigator.pop(context);
                    tagHelper.deleteTag(tag.markChanged());

                    setState(() {
                      tags.remove(filteredTags[index].id);
                    });

                    onChanged?.call();
                  },
                ),
              ),
            ),
            onTap: () => _onChangeValue(
                !tags.contains(filteredTags[index].id), filteredTags[index].id),
          ),
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text(LocaleStrings.search.tagCreateHint(query)),
          onTap: () async {
            await Utils.showNotesModalBottomSheet(
              context: context,
              builder: (context) => TagEditor(
                initialInput: query,
                onSave: (tag) {
                  Navigator.pop(context);
                  tagHelper.saveTag(tag.markChanged());
                },
              ),
            );
            query = "";
            setState(() {});
          },
        ),
      ],
    );
  }

  void _onChangeValue(bool value, String id) {
    setState(() {
      if (value) {
        tags.add(id);
      } else {
        tags.remove(id);
      }
    });

    onChanged?.call();
  }
}

class _TapIsolatedListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget trailing;
  final VoidCallback onTap;

  _TapIsolatedListTile({
    @required this.leading,
    @required this.title,
    @required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double _height = 56 + theme.visualDensity.baseSizeAdjustment.dy;

    return SizedBox.fromSize(
      size: Size.fromHeight(_height),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    leading,
                    SizedBox(width: 28),
                    AnimatedDefaultTextStyle(
                      style: theme.textTheme.subtitle1,
                      duration: kThemeChangeDuration,
                      child: title ?? const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            indent: 8,
            endIndent: 8,
          ),
          SizedBox(width: 8),
          trailing,
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
