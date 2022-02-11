import 'dart:async';

import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart' as db show Note, NoteImage;
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/unmodifiable_note.dart';
import 'package:potato_notes/widget/mouse_listener_mixin.dart';
import 'package:potato_notes/widget/note_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

class NotePageImageGallery extends StatefulWidget {
  final UnmodifiableNoteView note;
  final List<db.NoteImage> initialImages;
  final bool allowEditing;
  final ValueChanged<db.NoteImage>? onDraw;
  final ValueChanged<db.NoteImage>? onDelete;
  final int currentImage;

  const NotePageImageGallery({
    required this.note,
    required this.initialImages,
    this.allowEditing = true,
    this.onDraw,
    this.onDelete,
    required this.currentImage,
  });

  @override
  _NotePageImageGalleryState createState() => _NotePageImageGalleryState();
}

class _NotePageImageGalleryState extends State<NotePageImageGallery>
    with MouseListenerMixin {
  late final PageController pageController =
      PageController(initialPage: widget.currentImage);
  final TransformationController transformationController =
      TransformationController();
  late int currentPage = widget.currentImage;
  late final StreamSubscription<db.Note> stream;
  late List<db.NoteImage> images = widget.initialImages;

  @override
  void initState() {
    super.initState();
    stream = helper.watchNote(widget.note).listen(_updateImages);
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  Future<void> _updateImages(db.Note newNote) async {
    final List<db.NoteImage> newImages =
        await imageHelper.getImagesById(newNote.images);
    images = newImages;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.dismissibleRoute!.requestDisableGestures = currentScale > 1;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRect(
                child: Padding(
                  padding: EdgeInsets.only(top: context.padding.top),
                  child: InteractiveViewer(
                    transformationController: transformationController,
                    minScale: 1,
                    maxScale: 4,
                    onInteractionUpdate: (details) => setState(() {}),
                    clipBehavior: Clip.none,
                    child: NoteImage(
                      savedImage: images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
            controller: pageController,
            onPageChanged: (index) => setState(() => currentPage = index),
            physics:
                currentScale > 1 ? const NeverScrollableScrollPhysics() : null,
          ),
          Visibility(
            visible: isMouseConnected,
            child: Row(
              children: [
                _PageSwitchSideButton(
                  icon: const Icon(Icons.arrow_back),
                  onTap: _previousPage,
                  enabled: currentPage != 0,
                ),
                const Spacer(),
                _PageSwitchSideButton(
                  icon: const Icon(Icons.arrow_forward),
                  onTap: _nextPage,
                  enabled: currentPage != images.length - 1,
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          LocaleStrings.common.xOfY(
            currentPage + 1,
            widget.note.images.length,
          ),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          if (widget.allowEditing && widget.onDraw != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              padding: EdgeInsets.zero,
              tooltip: LocaleStrings.common.edit,
              onPressed: () async {
                widget.onDraw!.call(images[currentPage]);

                //setState(() {});
              },
            ),
          if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              padding: EdgeInsets.zero,
              tooltip: LocaleStrings.common.share,
              onPressed: () async {
                Share.shareFiles([images[currentPage].path]);
              },
            ),
          if (widget.allowEditing && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              padding: EdgeInsets.zero,
              tooltip: LocaleStrings.common.delete,
              onPressed: () async {
                //imageQueue.addDelete(widget.note.images[currentPage]);
                widget.onDelete!.call(images[currentPage]);
                context.pop();
              },
            ),
        ],
      ),
    );
  }

  Future<void> _nextPage() async {
    await pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: decelerateEasing,
    );
    setState(() {});
  }

  Future<void> _previousPage() async {
    await pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: decelerateEasing,
    );
    setState(() {});
  }

  double get currentScale {
    return transformationController.value.storage[0];
  }
}

class _PageSwitchSideButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _PageSwitchSideButton({
    required this.icon,
    this.onTap,
    this.enabled = true,
  });

  @override
  _PageSwitchSideButtonState createState() => _PageSwitchSideButtonState();
}

class _PageSwitchSideButtonState extends State<_PageSwitchSideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => _controller.forward(),
          onExit: (_) => _controller.reverse(),
          child: Container(
            height: constraints.maxHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FadeTransition(
              opacity: _controller,
              child: SizedBox.fromSize(
                size: const Size.square(48),
                child: AnimatedOpacity(
                  opacity: widget.enabled ? 1 : 0.5,
                  duration: const Duration(milliseconds: 150),
                  curve: decelerateEasing,
                  child: FloatingActionButton(
                    onPressed: widget.enabled ? widget.onTap : null,
                    heroTag: null,
                    child: widget.icon,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
