import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/data.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';
import 'package:potato_notes/widget/note_view_checkbox.dart';
import 'package:potato_notes/widget/separated_list.dart';

class ThemePickerPage extends StatefulWidget {
  final Brightness pickerMode;

  const ThemePickerPage({
    required this.pickerMode,
  });

  @override
  _ThemePickerPageState createState() => _ThemePickerPageState();
}

class _ThemePickerPageState extends State<ThemePickerPage> {
  @override
  Widget build(BuildContext context) {
    final String title;
    final AppTheme currentTheme;
    final List<AppTheme> themes = appInfo.availableThemes
        .where(
          (element) => element.data.colors.brightness == widget.pickerMode,
        )
        .toList();

    switch (widget.pickerMode) {
      case Brightness.dark:
        title = "Choose dark theme";
        currentTheme = appInfo.darkAppTheme;
        break;
      case Brightness.light:
      default:
        title = "Choose light theme";
        currentTheme = appInfo.lightAppTheme;
        break;
    }

    return DialogSheetBase(
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final AppTheme theme = themes[index];

            return _AppThemeCard(
              theme: theme,
              selected: theme == currentTheme,
              onTap: () {
                switch (widget.pickerMode) {
                  case Brightness.dark:
                    appInfo.loadDarkTheme(theme);
                    break;
                  case Brightness.light:
                  default:
                    appInfo.loadLightTheme(theme);
                    break;
                }

                setState(() {});
              },
              onDelete: () async {
                await appInfo.removeTheme(theme.data.id);
                setState(() {});
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: themes.length,
          shrinkWrap: true,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _AppThemeCard extends StatelessWidget {
  final AppTheme theme;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _AppThemeCard({
    required this.theme,
    this.selected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isImportedTheme = theme is ImportedTheme;

    return Theme(
      data: theme.data.materialTheme,
      child: Card(
        margin: EdgeInsets.zero,
        shape: context.leafletTheme.shapes.cardShape.copyWith(
          side: BorderSide(
            color: selected
                ? context.theme.colorScheme.secondary
                : context.theme.colorScheme.onBackground.withOpacity(0.14),
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: theme.data.colors.background,
        child: Stack(
          children: [
            Positioned.fill(
              child: Card(
                margin: const EdgeInsets.all(12),
                shape: theme.data.shapes.cardShape,
                color: theme.data.colors.surface,
                elevation: 6,
              ),
            ),
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: SeparatedList(
                  separator: const SizedBox(height: 8),
                  children: [
                    IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: theme.data.colors.onSurface,
                            overflow: TextOverflow.ellipsis,
                          ),
                          child: Row(
                            children: [
                              NoteViewCheckbox(
                                value: selected,
                                onChanged: (_) {},
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      theme.data.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      isImportedTheme
                                          ? "By ${theme.data.author}"
                                          : "Built-in",
                                      style: TextStyle(
                                        color: theme.data.colors.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.radio_button_on,
                                color: theme.data.colors.secondary,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.radio_button_off,
                                color: theme.data.colors.onSurface,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.error_outline,
                                color: theme.data.colors.error,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isImportedTheme)
                      OverflowBar(
                        alignment: MainAxisAlignment.end,
                        spacing: 8,
                        children: [
                          Tooltip(
                            message:
                                selected ? "Can't delete the active theme" : "",
                            child: TextButton(
                              onPressed: !selected ? onDelete : null,
                              child: Text(
                                strings.common.delete.toUpperCase(),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
