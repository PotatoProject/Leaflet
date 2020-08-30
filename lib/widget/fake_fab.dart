import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/accented_icon.dart';

class FakeFab extends StatefulWidget {
  final Key key;
  final Object heroTag;
  final Widget child;
  final ShapeBorder shape;
  final void Function() onTap;

  FakeFab({
    this.key,
    this.heroTag = "defaultTag",
    this.child,
    this.shape,
    this.onTap,
  }) : super(key: key);

  @override
  _FakeFabState createState() => _FakeFabState();
}

class _FakeFabState extends State<FakeFab> {
  bool _hovered = false;
  bool _focused = false;
  bool _highlighted = false;
  double _elevation;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (_highlighted) {
      _elevation = 12;
    } else if (_hovered) {
      _elevation = 10;
    } else if (_focused) {
      _elevation = 8;
    } else {
      _elevation = 6;
    }

    return Hero(
      tag: widget.heroTag,
      child: Material(
        color: theme.accentColor,
        elevation: _elevation,
        clipBehavior: Clip.antiAlias,
        shape: widget.shape,
        child: GestureDetector(
          onSecondaryTap: onLongPress,
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: onLongPress,
            onHover: (value) => setState(() {
              _hovered = value;
            }),
            onFocusChange: (value) => setState(() {
              _focused = value;
            }),
            onHighlightChanged: (value) => setState(() {
              _highlighted = value;
            }),
            customBorder: widget.shape,
            child: Container(
              width: 56,
              height: 56,
              child: Theme(
                data: theme.copyWith(
                  iconTheme: theme.iconTheme.copyWith(
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLongPress() {
    Utils.showFabMenu(
      context,
      context.findRenderObject(),
      fabOptions,
    );
  }

  List<Widget> get fabOptions {
    return [
      ListTile(
        tileColor: Theme.of(context).accentColor,
        leading: Icon(
          OMIcons.edit,
          color: Theme.of(context).cardColor,
        ),
        title: Text(
          LocaleStrings.common.newNote,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).cardColor,
          ),
        ),
        onTap: () {
          Navigator.pop(context);

          Utils.newNote(context);
        },
      ),
      ListTile(
        leading: AccentedIcon(MdiIcons.checkboxMarkedOutline),
        title: Text(
          LocaleStrings.common.newList,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pop(context);

          Utils.newList(context);
        },
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.image),
        title: Text(
          LocaleStrings.common.newImage,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () =>
            Utils.newImage(context, ImageSource.gallery, shouldPop: true),
      ),
      ListTile(
        leading: AccentedIcon(OMIcons.brush),
        title: Text(
          LocaleStrings.common.newDrawing,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pop(context);

          Utils.newDrawing(context);
        },
      ),
    ];
  }
}
