import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liblymph/database.dart';
import 'package:liblymph/database.dart';
import 'package:potato_notes/internal/constants.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/selection_state.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/routes/settings_page.dart';
import 'package:potato_notes/widget/folder_editor.dart';
import 'package:potato_notes/widget/illustrations.dart';
import 'package:potato_notes/widget/note_list_widget.dart';
import 'package:potato_notes/widget/note_view.dart';
import 'package:potato_notes/widget/separated_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController controller = ScrollController();
  Folder folder = BuiltInFolders.home;
  late SelectionState _selectionState;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _selectionState = SelectionState(
      options: Utils.getSelectionOptionsForMode(folder),
      folder: folder,
      onSelectionChanged: (value) {
        //context.basePage!.setNavigationEnabled(!value);
      },
    );
    _selectionState.selectingNotifier.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionStateWidget.withState(
        state: _selectionState,
        child: StreamBuilder<List<Note>>(
          stream: noteHelper.watchNotes(folder),
          initialData: const [],
          builder: (context, snapshot) {
            return NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  leading: const Center(
                    child: Illustration.leaflet(height: 28),
                  ),
                  titleSpacing: 0,
                  title: const Text(
                    "leaflet",
                    style:
                        TextStyle(fontFamily: Constants.leafletLogoFontFamily),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () => Utils.showSecondaryRoute(
                        context,
                        const SettingsPage(),
                      ),
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                  backgroundColor: context.theme.colorScheme.background,
                  elevation: 4,
                  floating: true,
                  pinned: true,
                  snap: true,
                  toolbarHeight: 64,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return ShaderMask(
                                  blendMode: BlendMode.dstATop,
                                  shaderCallback: (bounds) {
                                    final double startFraction =
                                        (controller.offset / 24.0)
                                            .clamp(0.0, 1.0);
                                    final double endFraction =
                                        ((controller.position.maxScrollExtent -
                                                    controller.offset) /
                                                24.0)
                                            .clamp(0.0, 1.0);
                                    return LinearGradient(
                                      colors: [
                                        if (controller.offset != 0)
                                          context.theme.colorScheme.background
                                              .withOpacity(0),
                                        if (controller.offset != 0)
                                          context.theme.colorScheme.background,
                                        context.theme.colorScheme.background,
                                        context.theme.colorScheme.background
                                            .withOpacity(0),
                                      ],
                                      stops: [
                                        if (controller.offset != 0) 0,
                                        if (controller.offset != 0)
                                          0.05 * startFraction,
                                        0.95 + (0.05 * (1 - endFraction)),
                                        1,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: child,
                                );
                              },
                              child: ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    PointerDeviceKind.mouse,
                                  },
                                ),
                                child: StreamBuilder<void>(
                                  stream: folderHelper.watchFolders(),
                                  builder: (context, snapshot) {
                                    return ListView.separated(
                                      controller: controller,
                                      itemBuilder: (context, index) =>
                                          _buildTag(
                                        context: context,
                                        title: prefs.folders[index].name,
                                        icon: Utils.getIconForFolder(
                                          prefs.folders[index],
                                        ),
                                        selected: prefs.folders[index].id ==
                                            folder.id,
                                        onTap: () => setState(
                                          () {
                                            folder = prefs.folders[index];
                                          },
                                        ),
                                        onLongPress: () =>
                                            Utils.showModalBottomSheet(
                                          context: context,
                                          builder: (context) => FolderEditor(
                                            folder: prefs.folders[index],
                                            onSave: (folder) async {
                                              context.pop();
                                              await folderHelper
                                                  .saveFolder(folder);
                                            },
                                            onDelete: (folder) async {
                                              context.pop();
                                              await folderHelper
                                                  .deleteFolder(folder);
                                            },
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        bottom: 8,
                                        top: 8,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) {
                                        if (index == 0) {
                                          return Row(
                                            children: [
                                              const SizedBox(width: 8),
                                              Center(
                                                child: Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: ShapeDecoration(
                                                    shape: const CircleBorder(),
                                                    color: context.theme
                                                        .colorScheme.outline
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                          );
                                        } else {
                                          return const SizedBox(width: 8);
                                        }
                                      },
                                      itemCount: prefs.folders.length,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: Material(
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: context.theme.colorScheme.outline
                                        .withOpacity(0.14),
                                    width: 2,
                                    style: context.theme.useMaterial3
                                        ? BorderStyle.none
                                        : BorderStyle.solid,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => Utils.showModalBottomSheet(
                                    context: context,
                                    builder: (context) => FolderEditor(
                                      onSave: (folder) async {
                                        context.pop();
                                        await folderHelper.saveFolder(folder);
                                      },
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: PageTransitionSwitcher(
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    fillColor: context.theme.colorScheme.background,
                    child: PageStorage(bucket: _bucket, child: child),
                  );
                },
                child: NoteListWidget(
                  key: ValueKey(folder.id),
                  itemBuilder: (context, index) {
                    final Note note = snapshot.data![index];
                    final SelectionState _state = context.selectionState;

                    return NoteView(
                      note: note,
                      onTap: () => _onNoteTap(context, note),
                      onLongPress: () => _onNoteLongPress(context, note),
                      selectorOpen: _state.selecting,
                      selected: _state.selectionList
                          .any((item) => item.id == note.id),
                      onCheckboxChanged: (value) {
                        if (!value!) {
                          _state.removeSelectedNoteWhere(
                            (item) => item.id == note.id,
                          );
                          if (_state.selectionList.isEmpty) {
                            _state.selecting = false;
                          }
                        } else {
                          _state.selecting = true;
                          _state.addSelectedNote(note);
                        }
                        /* context.basePage!
                              .setNavigationEnabled(!_state.selecting); */
                      },
                      allowSelection: true,
                    );
                  },
                  gridView: prefs.useGrid,
                  noteCount: snapshot.data!.length,
                  folder: folder,
                ),
              ),
              //primary: true,
              //physics: const AlwaysScrollableScrollPhysics(),
            );
          },
        ),
      ),
      floatingActionButton: !folder.readOnly
          ? FloatingActionButton(
              child: const Icon(Icons.edit_outlined),
              onPressed: () => Utils.newNote(context, folder),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: context.theme.colorScheme.surface,
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SeparatedList(
              axis: Axis.horizontal,
              separator: const SizedBox(width: 16),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!folder.readOnly)
                  IconButton(
                    icon: const Icon(Icons.check_box_outlined),
                    padding: EdgeInsets.zero,
                    onPressed: () => Utils.newList(context, folder),
                  ),
                if (!folder.readOnly)
                  IconButton(
                    icon: const Icon(Icons.image_outlined),
                    padding: EdgeInsets.zero,
                    onPressed: () =>
                        Utils.newImage(context, folder, ImageSource.gallery),
                  ),
                if (!folder.readOnly)
                  IconButton(
                    icon: const Icon(Icons.brush_outlined),
                    padding: EdgeInsets.zero,
                    onPressed: () => Utils.newDrawing(context, folder),
                  ),
                if (!folder.readOnly)
                  IconButton(
                    icon: const Icon(Icons.note_add_outlined),
                    padding: EdgeInsets.zero,
                    onPressed: () => Utils.importNotes(context),
                  ),
                if (folder.readOnly) const Spacer(),
                if (folder.readOnly) const Text("Read only"),
                if (folder.readOnly) const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    final _state = context.selectionState;

    if (_state.selecting) {
      if (_state.selectionList.any((item) => item.id == note.id)) {
        _state.removeSelectedNoteWhere((item) => item.id == note.id);
        if (_state.selectionList.isEmpty) _state.selecting = false;
      } else {
        _state.addSelectedNote(note);
      }
    } else {
      final bool status = await Utils.showNoteLockDialog(
        context: context,
        showLock: note.lockNote,
        showBiometrics: note.usesBiometrics,
      );

      if (status) {
        await Utils.showSecondaryRoute(
          context,
          NotePage(note: note),
        );
        Utils.handleNotePagePop(note);
      }
    }
  }

  void _onNoteLongPress(BuildContext context, Note note) {
    final _state = context.selectionState;

    if (_state.selecting) return;

    _state.selecting = true;
    _state.addSelectedNote(note);
  }

  Widget _buildTag({
    required BuildContext context,
    required String title,
    required IconData icon,
    bool selected = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Material(
      shape: StadiumBorder(
        side: BorderSide(
          color: context.theme.colorScheme.outline.withOpacity(0.14),
          width: 2,
          style: !selected && !context.theme.useMaterial3
              ? BorderStyle.solid
              : BorderStyle.none,
        ),
      ),
      color: selected
          ? context.theme.colorScheme.secondary
          : context.theme.useMaterial3
              ? context.theme.colorScheme.surface
              : Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 10,
            top: 8,
            bottom: 8,
            end: 10,
          ),
          child: SeparatedList(
            axis: Axis.horizontal,
            separator: const SizedBox(width: 4),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected
                    ? context.theme.colorScheme.onPrimary
                    : context.theme.colorScheme.onSurface,
                size: 16,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? context.theme.colorScheme.onPrimary
                      : context.theme.colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
