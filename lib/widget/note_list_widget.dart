import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/illustrations.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NoteListWidget extends StatelessWidget {
  final TransitionBuilder builder;
  final IndexedWidgetBuilder itemBuilder;
  final int noteCount;
  final ReturnMode noteKind;
  final ScrollController scrollController;
  final Widget customIllustration;
  final int gridColumns;

  const NoteListWidget({
    Key key,
    this.builder,
    @required this.itemBuilder,
    this.noteCount,
    this.noteKind,
    this.scrollController,
    this.customIllustration,
    this.gridColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = EdgeInsets.fromLTRB(
      4 + MediaQuery.of(context).viewPadding.left,
      4 + MediaQuery.of(context).padding.top,
      4 + MediaQuery.of(context).viewPadding.right,
      4 + 80.0 + MediaQuery.of(context).viewInsets.bottom,
    );
    Widget child;

    final ScrollController _scrollController =
        scrollController ?? ScrollController();

    if (noteCount > 0) {
      if (prefs.useGrid) {
        child = WaterfallFlow.builder(
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns ?? deviceInfo.uiSizeFactor,
          ),
          itemBuilder: itemBuilder,
          itemCount: noteCount,
          padding: padding,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      } else {
        child = ListView.builder(
          itemBuilder: itemBuilder,
          itemCount: noteCount,
          padding: padding,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    } else {
      child = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: constraints.maxHeight,
              child: customIllustration ??
                  Illustrations.quickIllustration(
                    context,
                    getInfoOnCurrentMode.key,
                    getInfoOnCurrentMode.value,
                  ),
            ),
          );
        },
      );
    }

    return builder?.call(context, child) ?? child;
  }

  MapEntry<Widget, String> get getInfoOnCurrentMode {
    switch (noteKind) {
      case ReturnMode.ARCHIVE:
        return MapEntry(
          appInfo.emptyArchiveIllustration,
          LocaleStrings.mainPage.emptyStateArchive,
        );
      case ReturnMode.TRASH:
        return MapEntry(
          appInfo.emptyTrashIllustration,
          LocaleStrings.mainPage.emptyStateTrash,
        );
      case ReturnMode.FAVOURITES:
        return MapEntry(
          appInfo.noFavouritesIllustration,
          LocaleStrings.mainPage.emptyStateFavourites,
        );
      case ReturnMode.TAG:
        return MapEntry(
          appInfo.noNotesIllustration,
          LocaleStrings.mainPage.emptyStateTag,
        );
      case ReturnMode.ALL:
      case ReturnMode.NORMAL:
      default:
        return MapEntry(
          appInfo.noNotesIllustration,
          LocaleStrings.mainPage.emptyStateHome,
        );
    }
  }
}
