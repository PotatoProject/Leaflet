import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:potato_notes/data/dao/folder_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/theme/colors.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NoteListWidget extends StatelessWidget {
  final TransitionBuilder? builder;
  final IndexedWidgetBuilder itemBuilder;
  final int noteCount;
  final bool gridView;
  final Folder? folder;
  final bool primary;
  final ScrollController? scrollController;
  final Widget? customIllustration;
  final int? gridColumns;

  const NoteListWidget({
    Key? key,
    this.builder,
    required this.itemBuilder,
    required this.noteCount,
    this.gridView = false,
    this.folder,
    this.primary = false,
    this.scrollController,
    this.customIllustration,
    this.gridColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsDirectional padding = EdgeInsetsDirectional.fromSTEB(
      Constants.cardPadding + context.viewPaddingDirectional.start,
      Constants.cardPadding + context.padding.top,
      Constants.cardPadding + context.viewPaddingDirectional.end,
      Constants.cardPadding + 80.0 + context.viewInsets.bottom,
    );
    Widget child;

    final ScrollController _scrollController =
        scrollController ?? ScrollController();

    if (noteCount > 0) {
      if (gridView) {
        child = WaterfallFlow.builder(
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns ?? deviceInfo.uiSizeFactor,
          ),
          itemBuilder: itemBuilder,
          itemCount: noteCount,
          padding: padding,
          primary: primary,
          controller: !primary ? _scrollController : null,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      } else {
        child = ListView.builder(
          itemBuilder: itemBuilder,
          itemCount: noteCount,
          padding: padding,
          primary: primary,
          controller: !primary ? _scrollController : null,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    } else {
      child = LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.only(
              bottom: context.viewInsets.bottom,
            ),
            height: constraints.maxHeight,
            child: customIllustration ??
                Utils.quickIllustration(
                  context,
                  getInfoOnCurrentMode(context.leafletTheme.illustrationPalette)
                      .key,
                  getInfoOnCurrentMode(context.leafletTheme.illustrationPalette)
                      .value,
                ),
          );
        },
      );
    }

    return builder?.call(context, child) ?? child;
  }

  MapEntry<Widget, String> getInfoOnCurrentMode(IllustrationPalette palette) {
    switch (folder?.id ?? BuiltInFolders.all.id) {
      case 'trash':
        return MapEntry(
          Illustration.trash(palette: palette, height: 128),
          LocaleStrings.mainPage.emptyStateTrash,
        );
      case 'normal':
      case 'all':
        return MapEntry(
          Illustration.noNotes(palette: palette, height: 128),
          LocaleStrings.mainPage.emptyStateHome,
        );
      default:
        return MapEntry(
          Illustration.archive(palette: palette, height: 128),
          LocaleStrings.mainPage.emptyStateArchive,
        );
    }
  }
}

class NoteSliverListWidget extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int noteCount;
  final bool gridView;
  final Folder? folder;
  final Widget? customIllustration;
  final int? gridColumns;

  const NoteSliverListWidget({
    required this.itemBuilder,
    required this.noteCount,
    this.gridView = false,
    this.folder,
    this.customIllustration,
    this.gridColumns,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsDirectional padding = EdgeInsetsDirectional.fromSTEB(
      Constants.cardPadding + context.viewPaddingDirectional.start,
      Constants.cardPadding,
      Constants.cardPadding + context.viewPaddingDirectional.end,
      Constants.cardPadding + 80.0 + context.viewInsets.bottom,
    );
    Widget child;

    if (noteCount > 0) {
      if (gridView) {
        child = SliverMasonryGrid.count(
          crossAxisCount: gridColumns ?? deviceInfo.uiSizeFactor,
          itemBuilder: itemBuilder,
          childCount: noteCount,
        );
      } else {
        child = SliverList(
          delegate: SliverChildBuilderDelegate(
            itemBuilder,
            childCount: noteCount,
          ),
        );
      }

      child = SliverPadding(
        padding: padding,
        sliver: child,
      );
    } else {
      final MapEntry<Widget, String> info =
          getInfoOnCurrentMode(context.leafletTheme.illustrationPalette);
      child = SliverFillRemaining(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.only(
                bottom: context.viewInsets.bottom,
              ),
              height: constraints.maxHeight,
              child: customIllustration ??
                  Utils.quickIllustration(context, info.key, info.value),
            );
          },
        ),
      );
    }

    return child;
  }

  MapEntry<Widget, String> getInfoOnCurrentMode(IllustrationPalette palette) {
    switch (folder?.id ?? BuiltInFolders.all.id) {
      case 'trash':
        return MapEntry(
          Illustration.trash(palette: palette, height: 128),
          LocaleStrings.mainPage.emptyStateTrash,
        );
      case 'normal':
      case 'all':
        return MapEntry(
          Illustration.noNotes(palette: palette, height: 128),
          LocaleStrings.mainPage.emptyStateHome,
        );
      default:
        return MapEntry(
          Illustration.archive(palette: palette, height: 128),
          LocaleStrings.mainPage.emptyStateArchive,
        );
    }
  }
}
