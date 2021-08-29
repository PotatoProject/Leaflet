import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
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
    final List<Tag> filteredTags = [];

    if (query.isEmpty) {
      filteredTags.addAll(prefs.tags);
    } else {
      filteredTags.addAll(
        prefs.tags
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
              checkColor: context.theme.scaffoldBackgroundColor,
              activeColor: context.theme.colorScheme.secondary,
              onChanged: (value) =>
                  _onChangeValue(value!, filteredTags[index].id),
            ),
            title: Text(filteredTags[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              padding: EdgeInsets.zero,
              splashRadius: 24,
              onPressed: () => Utils.showModalBottomSheet(
                context: context,
                builder: (context) => TagEditor(
                  initialInput: query,
                  tag: filteredTags[index],
                  onSave: (tag) {
                    context.pop();
                    tagHelper.saveTag(tag.markChanged());

                    onChanged?.call();
                  },
                  onDelete: (tag) {
                    context.pop();
                    tagHelper.deleteTag(tag.markChanged());

                    setState!(() {
                      tags.remove(filteredTags[index].id);
                    });

                    onChanged?.call();
                  },
                ),
              ),
            ),
            onTap: () => _onChangeValue(
              !tags.contains(filteredTags[index].id),
              filteredTags[index].id,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text(
            query.isNotEmpty
                ? LocaleStrings.search.tagCreateHint(query)
                : LocaleStrings.search.tagCreateEmptyHint,
          ),
          onTap: () async {
            final bool? result = await Utils.showModalBottomSheet<bool>(
              context: context,
              builder: (context) => TagEditor(
                initialInput: query,
                onSave: (tag) {
                  context.pop(true);
                  tagHelper.saveTag(tag.markChanged());
                },
              ),
            );
            if (result ?? false) {
              query = "";
              setState!(() {});
            }
          },
        ),
      ],
    );
  }

  void _onChangeValue(bool value, String id) {
    setState!(() {
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
  final VoidCallback? onTap;

  const _TapIsolatedListTile({
    required this.leading,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final double _height = 56 + theme.visualDensity.baseSizeAdjustment.dy;

    return SizedBox.fromSize(
      size: Size.fromHeight(_height),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    leading,
                    const SizedBox(width: 28),
                    AnimatedDefaultTextStyle(
                      style: theme.textTheme.subtitle1!,
                      duration: kThemeChangeDuration,
                      child: title,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            indent: 8,
            endIndent: 8,
          ),
          const SizedBox(width: 8),
          trailing,
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
