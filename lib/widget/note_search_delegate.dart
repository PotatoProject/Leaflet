import 'package:animated_vector/animated_vector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/search_page.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/query_filters.dart';

class NoteSearchDelegate extends CustomSearchDelegate {
  final SearchQuery searchQuery = SearchQuery();

  NoteSearchDelegate();

  @override
  Widget? buildLeading(BuildContext context) {
    if (!DeviceInfo.isMobile) return const Icon(Icons.search);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) => IconButton(
        icon: _AnimatedIconTwoVectors(
          start: AnimatedVectors.searchToClose,
          end: AnimatedVectors.closeToSearch,
          duration: const Duration(milliseconds: 350),
          swap: isKeyboardVisible,
        ),
        onPressed: isKeyboardVisible ? () => Utils.popKeyboard() : null,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        padding: EdgeInsets.zero,
        onPressed: () => Utils.showModalBottomSheet(
          context: context,
          builder: (context) => QueryFilters(
            query: searchQuery,
            filterChangedCallback: () => setState!(() {}),
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: helper.noteStream(ReturnMode.local),
      initialData: const [],
      builder: (context, snapshot) {
        final IllustrationPalette palette =
            context.leafletTheme.illustrationPalette;
        final Widget illustration = query.isEmpty
            ? Utils.quickIllustration(
                context,
                Illustration.typeToSearch(
                  palette: palette,
                  height: 72,
                ),
                LocaleStrings.search.typeToSearch,
              )
            : Utils.quickIllustration(
                context,
                Illustration.nothingFound(
                  palette: palette,
                  height: 72,
                ),
                LocaleStrings.search.nothingFound,
              );
        final List<Note> results =
            searchQuery.filterNotes(query, snapshot.data!);

        results.sort((a, b) => b.creationDate.compareTo(a.creationDate));

        return NoteListWidget(
          itemBuilder: (context, index) => NoteView(
            note: results[index],
            onTap: () => openNote(context, results[index]),
          ),
          gridView: prefs.useGrid,
          noteCount: results.length,
          customIllustration: illustration,
        );
      },
    );
  }

  Future<void> openNote(BuildContext context, Note note) async {
    final bool status = await Utils.showNoteLockDialog(
      context: context,
      showLock: note.lockNote,
      showBiometrics: note.usesBiometrics,
    );

    if (status) {
      await Utils.showSecondaryRoute(
        context,
        NotePage(
          note: note,
        ),
      );
      Utils.handleNotePagePop(note);
    }
  }
}

class _AnimatedIconTwoVectors extends StatefulWidget {
  final bool swap;
  final AnimatedVectorData start;
  final AnimatedVectorData end;
  final Duration duration;

  const _AnimatedIconTwoVectors({
    this.swap = false,
    required this.start,
    required this.end,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  _AnimatedIconTwoVectorsState createState() => _AnimatedIconTwoVectorsState();
}

class _AnimatedIconTwoVectorsState extends State<_AnimatedIconTwoVectors>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimatedVectorData currentVector;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    currentVector = widget.start;
  }

  @override
  void didUpdateWidget(covariant _AnimatedIconTwoVectors old) {
    super.didUpdateWidget(old);

    if (widget.swap != old.swap) {
      _updateController(widget.swap);
    }
  }

  Future<void> _updateController(bool status) async {
    _controller.duration = widget.duration;
    if (_controller.isAnimating) {
      _controller.stop();
      if (status) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    } else {
      if (status) {
        await _controller.forward();
        currentVector = widget.end;
        _controller.value = 0;
      } else {
        await _controller.forward();
        currentVector = widget.start;
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedVector(
          vector: DirectAnimatedVectorData(currentVector),
          progress: _controller,
          applyColor: true,
        );
      },
    );
  }
}
