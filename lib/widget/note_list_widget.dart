import 'package:flutter/material.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NoteListWidget extends StatelessWidget {
  final TransitionBuilder? builder;
  final IndexedWidgetBuilder itemBuilder;
  final int noteCount;
  final bool gridView;
  final ReturnMode? noteKind;
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
    this.noteKind,
    this.primary = false,
    this.scrollController,
    this.customIllustration,
    this.gridColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsDirectional padding = EdgeInsetsDirectional.fromSTEB(
      4 + context.viewPaddingDirectional.start,
      4 + context.padding.top,
      4 + context.viewPaddingDirectional.end,
      4 + 80.0 + context.viewInsets.bottom,
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
                  getInfoOnCurrentMode(context.theme.brightness).key,
                  getInfoOnCurrentMode(context.theme.brightness).value,
                ),
          );
        },
      );
    }

    return builder?.call(context, child) ?? child;
  }

  MapEntry<Widget, String> getInfoOnCurrentMode(Brightness themeBrightness) {
    switch (noteKind) {
      case ReturnMode.archive:
        return MapEntry(
          Illustration.archive(brightness: themeBrightness, height: 128),
          LocaleStrings.mainPage.emptyStateArchive,
        );
      case ReturnMode.trash:
        return MapEntry(
          Illustration.trash(brightness: themeBrightness, height: 128),
          LocaleStrings.mainPage.emptyStateTrash,
        );
      case ReturnMode.all:
      case ReturnMode.normal:
      default:
        return MapEntry(
          Illustration.noNotes(brightness: themeBrightness, height: 128),
          LocaleStrings.mainPage.emptyStateHome,
        );
    }
  }
}
