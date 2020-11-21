import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:loggy/loggy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/colors.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/draw_object.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/image/image_service.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/drawing_board.dart';
import 'package:potato_notes/widget/drawing_gesture_detector.dart';
import 'package:potato_notes/widget/drawing_toolbar.dart';
import 'package:potato_notes/widget/fake_appbar.dart';
import 'package:potato_notes/widget/web_drawing_exporter.dart/shared.dart';

class DrawPage extends StatefulWidget {
  final Note note;
  final SavedImage? savedImage;

  DrawPage({
    required this.note,
    this.savedImage,
  });

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> with TickerProviderStateMixin {
  BuildContext? _globalContext;
  List<DrawObject> _objects = [];
  List<DrawObject> _backupObjects = [];
  int? _currentIndex;
  int? _actionQueueIndex = 0;
  bool _saved = true;
  Offset? _mousePosition = Offset.zero;
  DrawingToolbarController _toolbarController = DrawingToolbarController();

  late AnimationController _appbarAc;
  late AnimationController _toolbarAc;

  List<DrawingTool> _tools = [
    DrawingTool(
      icon: Icons.brush_outlined,
      title: LocaleStrings.drawPage.toolsBrush,
      toolType: DrawTool.PEN,
      color: Colors.black,
      size: ToolSize.FOUR,
    ),
    DrawingTool(
      icon: MdiIcons.marker,
      title: LocaleStrings.drawPage.toolsMarker,
      toolType: DrawTool.MARKER,
      color: Color(NoteColors.yellow.color),
      size: ToolSize.TWELVE,
    ),
    DrawingTool(
      icon: MdiIcons.eraserVariant,
      title: LocaleStrings.drawPage.toolsEraser,
      toolType: DrawTool.ERASER,
      size: ToolSize.THIRTYTWO,
      allowColor: false,
    ),
  ];
  int _toolIndex = 0;

  String? _filePath;

  final GlobalKey _drawingKey = GlobalKey();
  final GlobalKey _appbarKey = GlobalKey();
  final GlobalKey _toolbarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(exitPrompt);
    _appbarAc = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _toolbarAc = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(exitPrompt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _globalContext ??= context;

    final _curvedAppbarAc = CurvedAnimation(
      parent: _appbarAc,
      curve: decelerateEasing,
    );
    final _curvedToolbarAc = CurvedAnimation(
      parent: _toolbarAc,
      curve: decelerateEasing,
    );

    return Scaffold(
      appBar: FakeAppbar(
        child: AnimatedBuilder(
          animation: _appbarAc,
          builder: (context, _) {
            return FadeTransition(
              opacity: ReverseAnimation(_curvedAppbarAc),
              key: _appbarKey,
              child: AppBar(
                leading: BackButton(
                  onPressed: () => exitPrompt(true),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.save_outlined),
                    padding: EdgeInsets.all(0),
                    tooltip: LocaleStrings.common.save,
                    onPressed: !_saved ? _saveImage : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: MouseRegion(
          onExit: (event) => setState(() => _mousePosition = null),
          onHover: (event) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset offset = box.localToGlobal(Offset.zero);
            _mousePosition = event.position.translate(-offset.dx, -offset.dy);
            setState(() {});
          },
          child: CustomPaint(
            foregroundPainter: _CursorPainter(
              offset: _mousePosition,
              brushWidth: _tools[_toolIndex].size,
            ),
            child: DrawingGestureDetector(
              onUpdate: _normalModePanUpdate,
              onEnd: _normalModePanEnd,
              child: DrawingBoard(
                repaintKey: _drawingKey,
                objects: _objects,
                uri: widget.savedImage?.uri,
                color: Colors.grey[50],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _toolbarAc,
        builder: (context, _) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: ReverseAnimation(_curvedToolbarAc),
              key: _toolbarKey,
              child: DrawingToolbar(
                controller: _toolbarController,
                tools: _tools,
                toolIndex: _toolIndex,
                onIndexChanged: (value) => setState(() => _toolIndex = value),
                onUndo: _objects.isNotEmpty
                    ? () => setState(() {
                          _objects.removeLast();
                          _actionQueueIndex = _objects.length - 1;
                          _saved = false;
                        })
                    : null,
                onRedo: _actionQueueIndex! < _backupObjects.length - 1
                    ? () => setState(() {
                          _actionQueueIndex = _objects.length;
                          _objects.add(_backupObjects[_actionQueueIndex!]);
                          _saved = false;
                        })
                    : null,
                clearCanvas: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(LocaleStrings.common.areYouSure),
                      content:
                          Text("This operation can't be undone. Continue?"),
                      actions: [
                        TextButton(
                          child: Text(LocaleStrings.common.cancel),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text(LocaleStrings.common.confirm),
                          onPressed: () {
                            _objects.clear();
                            _backupObjects.clear();
                            _actionQueueIndex = 0;
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      /*bottomNavigationBar: Material(
        elevation: 12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizeTransition(
              sizeFactor: controller,
              axis: Axis.vertical,
              axisAlignment: 1,
              child: Material(
                color: Theme.of(context).cardColor,
                child: SizedBox(
                  height: 48,
                  child: showReason == MenuShowReason.RADIUS_PICKER
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(width: 16),
                            Text(strokeWidth.toInt().toString()),
                            Expanded(
                              child: Slider(
                                value: strokeWidth,
                                min: 4,
                                max: 50,
                                onChanged: (value) =>
                                    setState(() => strokeWidth = value),
                                activeColor: Theme.of(context).accentColor,
                                inactiveColor: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availableColors.length,
                          itemBuilder: (context, index) {
                            Color currentColor = index == 0
                                ? Colors.black
                                : Color(availableColors[index].color);

                            String tooltip = index == 0
                                ? LocaleStrings.drawPage.colorBlack
                                : availableColors[index].label;

                            return IconButton(
                              visualDensity: VisualDensity.standard,
                              icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: currentColor,
                                ),
                                width: 32,
                                height: 32,
                                child: currentColor == selectedColor
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ),
                              tooltip: tooltip,
                              onPressed: () {
                                setState(() => selectedColor = currentColor);
                                controller.animateBack(0);
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
            SpicyBottomBar(
              height: 48,
              elevation: 0,
              leftItems: <Widget>[
                IconButton(
                  icon: Icon(Icons.brush_outlined),
                  color: currentTool == DrawTool.PEN
                      ? Theme.of(context).accentColor
                      : null,
                  padding: EdgeInsets.all(0),
                  tooltip: LocaleStrings.drawPage.toolsBrush,
                  onPressed: () => setState(() => currentTool = DrawTool.PEN),
                ),
                IconButton(
                  icon: Icon(MdiIcons.eraserVariant),
                  color: currentTool == DrawTool.ERASER
                      ? Theme.of(context).accentColor
                      : null,
                  padding: EdgeInsets.all(0),
                  tooltip: LocaleStrings.drawPage.toolsEraser,
                  onPressed: () =>
                      setState(() => currentTool = DrawTool.ERASER),
                ),
                IconButton(
                  icon: Icon(MdiIcons.marker),
                  color: currentTool == DrawTool.MARKER
                      ? Theme.of(context).accentColor
                      : null,
                  padding: EdgeInsets.all(0),
                  tooltip: LocaleStrings.drawPage.toolsMarker,
                  onPressed: () =>
                      setState(() => currentTool = DrawTool.MARKER),
                ),
              ],
              rightItems: <Widget>[
                IconButton(
                  icon: Icon(Icons.color_lens_outlined),
                  padding: EdgeInsets.all(0),
                  tooltip: LocaleStrings.drawPage.toolsColorPicker,
                  onPressed: () async {
                    if (showReason == MenuShowReason.COLOR_PICKER &&
                        controller.value > 0) {
                      await controller.animateBack(0);
                    } else {
                      await controller.animateBack(0);
                      setState(() => showReason = MenuShowReason.COLOR_PICKER);
                      await controller.animateTo(1);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(MdiIcons.radiusOutline),
                  padding: EdgeInsets.all(0),
                  tooltip: LocaleStrings.drawPage.toolsRadiusPicker,
                  onPressed: () async {
                    if (showReason == MenuShowReason.RADIUS_PICKER &&
                        controller.value > 0) {
                      await controller.animateBack(0);
                    } else {
                      await controller.animateBack(0);
                      setState(() => showReason = MenuShowReason.RADIUS_PICKER);
                      await controller.animateTo(1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),*/
    );
  }

  void _normalModePanStart(DragUpdateDetails details) {
    setState(() => _saved = false);
    _toolbarController.closePanel();
    DrawObject object;

    switch (_tools[_toolIndex].toolType) {
      case DrawTool.MARKER:
        object = DrawObject(
          Paint()
            ..strokeCap = StrokeCap.square
            ..isAntiAlias = true
            ..color = _tools[_toolIndex].color.withOpacity(0.5)
            ..strokeWidth = _tools[_toolIndex].size
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
          [],
        );
        break;
      case DrawTool.ERASER:
        object = DrawObject(
          Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = Colors.transparent
            ..blendMode = BlendMode.clear
            ..strokeWidth = _tools[_toolIndex].size
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
          [],
        );
        break;
      case DrawTool.PEN:
      default:
        object = DrawObject(
          Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = _tools[_toolIndex].color
            ..strokeWidth = _tools[_toolIndex].size
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
          [],
        );
        break;
    }

    _objects.add(object);
    //_ac.forward();

    _currentIndex = _objects.length - 1;
    _actionQueueIndex = _currentIndex;

    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localOffset = box.globalToLocal(details.localPosition);
    Offset topLeft = box.localToGlobal(Offset.zero);

    Offset point = Offset(
      localOffset.dx,
      localOffset.dy,
    );
    _mousePosition = details.globalPosition.translate(-topLeft.dx, -topLeft.dy);

    setState(() => _objects[_currentIndex!].points.add(point));
  }

  void _normalModePanUpdate(DragUpdateDetails details) {
    final RenderBox appbarBox =
        _appbarKey.currentContext!.findRenderObject()! as RenderBox;
    Rect appbarRect =
        (appbarBox.localToGlobal(Offset.zero) & appbarBox.size).inflate(8);

    final RenderBox toolbarBox =
        _toolbarKey.currentContext!.findRenderObject()! as RenderBox;
    Rect toolbarRect =
        (toolbarBox.localToGlobal(Offset.zero) & toolbarBox.size).inflate(8);

    if (_currentIndex == null) {
      _normalModePanStart(details);
      return;
    }

    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localOffset = box.globalToLocal(details.localPosition);
    Offset topLeft = box.localToGlobal(Offset.zero);

    appbarRect = appbarRect.shift(topLeft * -1);
    toolbarRect = toolbarRect.shift(topLeft * -1);
    _mousePosition = details.globalPosition.translate(-topLeft.dx, -topLeft.dy);

    Offset point = Offset(
      localOffset.dx,
      localOffset.dy,
    );

    if (!_appbarAc.isAnimating) {
      if (appbarRect.contains(point))
        _appbarAc.forward();
      else
        _appbarAc.reverse();
    }

    if (!_toolbarAc.isAnimating) {
      if (toolbarRect.contains(point))
        _toolbarAc.forward();
      else
        _toolbarAc.reverse();
    }

    setState(() => _objects[_currentIndex!].points.add(point));
  }

  void _normalModePanEnd(details) {
    _currentIndex = null;
    _backupObjects = List.from(_objects);
    _appbarAc.reverse();
    _toolbarAc.reverse();
    setState(() => _mousePosition = null);
  }

  bool exitPrompt(bool _) {
    Uri? uri = _filePath != null ? Uri.file(_filePath!) : null;

    void _internal() async {
      if (!_saved) {
        bool? exit = await showDialog(
          context: _globalContext!,
          builder: (context) => AlertDialog(
            title: Text(LocaleStrings.common.areYouSure),
            content: Text(LocaleStrings.drawPage.exitPrompt),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                textColor: Theme.of(context).accentColor,
                child: Text(LocaleStrings.common.cancel),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, true),
                textColor: Theme.of(context).accentColor,
                child: Text(LocaleStrings.common.exit),
              ),
            ],
          ),
        );

        if (exit != null) {
          Navigator.pop(_globalContext!, uri);
        }
      } else {
        Navigator.pop(_globalContext!, uri);
      }
    }

    _internal();

    return true;
  }

  void _saveImage() async {
    late String drawing;
    final box =
        _drawingKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    if (kIsWeb) {
      drawing = await WebDrawingExporter.export(
        widget.savedImage?.uri,
        _objects,
        box.size,
      );
    } else {
      ui.Image image = await box.toImage();
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      DateTime now = DateTime.now();
      String timestamp = DateFormat(
        "HH_mm_ss-MM_dd_yyyy",
        context.locale.toLanguageTag(),
      ).format(now);

      final drawingsDirectory = DeviceInfo.isDesktopOrWeb
          ? await getApplicationSupportDirectory()
          : await getApplicationDocumentsDirectory();

      print(drawingsDirectory);

      drawing = "${drawingsDirectory.path}/drawing-$timestamp.png";
      if (_filePath == null) {
        _filePath = drawing;
      } else {
        drawing = _filePath!;
      }

      File imgFile = File(drawing);
      await imgFile.writeAsBytes(pngBytes, flush: true);
      Loggy.d(message: drawing);

      SavedImage savedImage = await ImageService.prepareLocally(imgFile);
      if (widget.savedImage != null) {
        widget.note.images.removeWhere(
            (savedImage) => savedImage.id == widget.savedImage!.id);
        savedImage.id = widget.savedImage!.id;
      }
      widget.note.images.add(savedImage);
    }
    helper.saveNote(widget.note.markChanged());

    setState(() => _saved = true);
  }
}

enum MenuShowReason {
  COLOR_PICKER,
  RADIUS_PICKER,
}

class _CursorPainter extends CustomPainter {
  final Offset? offset;
  final double brushWidth;

  _CursorPainter({
    required this.offset,
    required this.brushWidth,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (offset == null) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawCircle(offset!, brushWidth / 2, paint);
  }

  @override
  bool shouldRepaint(_CursorPainter old) {
    return this.offset != old.offset || this.brushWidth != old.brushWidth;
  }
}
