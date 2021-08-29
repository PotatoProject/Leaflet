import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/data.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_present_outlined),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: deviceInfo.uiSizeFactor,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: EdgeInsetsDirectional.fromSTEB(
          8 + context.viewPaddingDirectional.start,
          8 + 56 + context.padding.top,
          8 + context.viewPaddingDirectional.end,
          8 + context.viewInsets.bottom,
        ),
        itemBuilder: (context, index) {
          final AppTheme theme = appInfo.availableThemes[index];

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
          );
        },
        itemCount: appInfo.availableThemes.length,
      ),
    );
  }
}

class _AppThemeCard extends StatelessWidget {
  final AppTheme theme;
  final bool selected;
  final VoidCallback? onTap;

  const _AppThemeCard({
    required this.theme,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
          Card(
            margin: const EdgeInsets.all(12),
            shape: theme.data.shapes.cardShape,
            color: theme.data.colors.surface,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: theme.data.colors.onSurface,
                  overflow: TextOverflow.ellipsis,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.data.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "By ${theme.data.author}",
                      style: TextStyle(
                        color: theme.data.colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.check_box,
                          color: theme.data.colors.secondary,
                        ),
                        Icon(
                          Icons.check_box_outline_blank,
                          color: theme.data.colors.onSurface,
                        ),
                        Icon(
                          Icons.error_outline,
                          color: theme.data.colors.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selected)
            PositionedDirectional(
              top: 16,
              end: 16,
              child: Icon(
                Icons.check_circle,
                color: context.theme.colorScheme.secondary,
              ),
            ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    );
  }
}
