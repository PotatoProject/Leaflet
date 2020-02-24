import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/ui/note_color_selector.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class NoteView extends StatelessWidget {
  final Note note;
  final Function() onTap;
  final Function() onDoubleTap;
  final Function() onLongTap;

  NoteView({
    @required this.note,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    final locales = AppLocalizations.of(context);

    double getAlphaFromTheme() {
      if (Theme.of(context).brightness == Brightness.light) {
        return 0.1;
      } else {
        return 0.2;
      }
    }

    Color cardColor = Theme.of(context).textTheme.headline6.color;

    double cardBrightness = getAlphaFromTheme();

    Color borderColor =
        HSLColor.fromColor(cardColor).withAlpha(cardBrightness).toColor();

    Color noteColor = Color(NoteColors.colorList[note.color ?? 0]["hex"]);

    Color getTextColorFromNoteColor(bool isContent) {
      double noteColorBrightness = noteColor.computeLuminance();
      Color contentWhite =
          HSLColor.fromColor(Colors.white).withAlpha(0.7).toColor();
      Color contentBlack =
          HSLColor.fromColor(Colors.black).withAlpha(0.7).toColor();

      if (noteColorBrightness > 0.5) {
        return isContent ? contentBlack : Colors.black;
      } else {
        return isContent ? contentWhite : Colors.white;
      }
    }

    Color getBorderColor() {
      if (note.isSelected) {
        if (noteColor != null) {
          return Theme.of(context).textTheme.headline6.color;
        } else {
          return Theme.of(context).accentColor;
        }
      } else if (noteColor != null) {
        return Colors.transparent;
      } else {
        if (Theme.of(context).brightness == Brightness.light) {
          return borderColor;
        } else {
          if (appInfo.followSystemTheme) {
            if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
              return Colors.transparent;
            } else {
              return borderColor;
            }
          } else {
            if (appInfo.themeMode != 0) {
              return Colors.transparent;
            } else {
              return borderColor;
            }
          }
        }
      }
    }

    return Hero(
      createRectTween: (Rect begin, Rect end) {
        return MaterialRectArcTween(begin: begin, end: end);
      },
      tag: "note" + appInfo.notes.indexOf(note).toString(),
      child: Card(
        elevation: 1.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: getBorderColor(), width: 2),
        ),
        color: (note.color ?? 0) == 0
            ? Theme.of(context).scaffoldBackgroundColor
            : noteColor,
        child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: note.imagePath != null,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: note.imagePath == null
                          ? Container()
                          : Center(
                              child: CachedNetworkImage(
                                imageUrl: note.imagePath,
                                fit: BoxFit.fill,
                                fadeInDuration: Duration(milliseconds: 0),
                                fadeOutDuration: Duration(milliseconds: 0),
                                placeholder: (context, url) {
                                  return ControlledAnimation(
                                    playback: Playback.MIRROR,
                                    tween: Tween<double>(begin: 0.2, end: 1),
                                    duration: Duration(milliseconds: 400),
                                    builder: (context, animation) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 40),
                                        child: Opacity(
                                          opacity: animation,
                                          child: Icon(
                                            Icons.image,
                                            size: 56,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )),
                ),
                Visibility(
                  visible: note.hideContent == 1 || note.reminders != null,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 14, 20,
                        note.hideContent == 1 && note.title == "" ? 14 : 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: note.reminders != null,
                          child: Center(
                            child: Icon(
                              Icons.alarm,
                              size: 12,
                              color: (note.color ?? 0) == 0
                                  ? Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color
                                      .withAlpha(140)
                                  : getTextColorFromNoteColor(false),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: note.hideContent == 1,
                          child: Center(
                            child: Icon(
                              note.pin != null || note.password != null
                                  ? Icons.lock
                                  : Icons.remove_red_eye,
                              size: 12,
                              color: (note.color ?? 0) == 0
                                  ? Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color
                                      .withAlpha(140)
                                  : getTextColorFromNoteColor(false),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (note.hideContent == 1 &&
                                  note.reminders == null) ||
                              (note.hideContent == 0 && note.reminders != null),
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            width: appInfo.isGridView
                                ? MediaQuery.of(context).size.width / 2 - 80
                                : MediaQuery.of(context).size.width - 100,
                            child: (note.hideContent == 1 &&
                                    note.reminders == null)
                                ? Text(
                                    locales
                                        .notesMainPageRoute_note_hiddenContent,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: (note.color ?? 0) == 0
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color
                                              .withAlpha(140)
                                          : getTextColorFromNoteColor(false),
                                    ),
                                  )
                                : (note.hideContent == 0 &&
                                        note.reminders != null)
                                    ? Text(
                                        locales
                                            .notesMainPageRoute_note_remindersSet,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (note.color ?? 0) == 0
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .color
                                                  .withAlpha(140)
                                              : getTextColorFromNoteColor(
                                                  false),
                                        ),
                                      )
                                    : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: appInfo.devShowIdLabels,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Text(
                      "Note id: " + note.id.toString(),
                      style: TextStyle(
                        color: (note.color ?? 0) == 0
                            ? null
                            : getTextColorFromNoteColor(false),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: note.title != "",
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    width: appInfo.isGridView
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        note.title ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyle(
                          color: (note.color ?? 0) == 0
                              ? Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .color
                                  .withAlpha(220)
                              : getTextColorFromNoteColor(false),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: note.hideContent == 0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        20, note.title == "" ? 14 : 0, 20, 14),
                    width: appInfo.isGridView
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    child: note.isList == 1
                        ? Column(
                            children: generateListWidgets(context),
                          )
                        : Text(
                            note.content ?? "",
                            overflow: TextOverflow.ellipsis,
                            textWidthBasis: TextWidthBasis.parent,
                            maxLines: 11,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: (note.color ?? 0) == 0
                                  ? Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color
                                      .withAlpha(180)
                                  : getTextColorFromNoteColor(true),
                            ),
                          ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> generateListWidgets(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    List<Widget> widgets = List<Widget>();
    List<ListPair> checkedList = List<ListPair>();
    List<ListPair> uncheckedList = List<ListPair>();

    Color noteColor = Color(NoteColors.colorList[note.color ?? 0]["hex"]);

    Color getTextColorFromNoteColor(bool isContent) {
      double noteColorBrightness = noteColor.computeLuminance();
      Color contentWhite =
          HSLColor.fromColor(Colors.white).withAlpha(0.7).toColor();
      Color contentBlack =
          HSLColor.fromColor(Colors.black).withAlpha(0.7).toColor();

      if (noteColorBrightness > 0.5) {
        return isContent ? contentBlack : Colors.black;
      } else {
        return isContent ? contentWhite : Colors.white;
      }
    }

    List<String> rawList = note.listParseString.split("\'..\'");

    for (int i = 0; i < rawList.length; i++) {
      List<dynamic> rawStrings = rawList[i].split("\',,\'");

      int checkValue = rawStrings[0] == "" ? 0 : int.parse(rawStrings[0]);

      if (checkValue == 1) {
        try {
          checkedList
              .add(ListPair(checkValue: checkValue, title: rawStrings[1]));
        } on RangeError {}
      } else {
        try {
          uncheckedList
              .add(ListPair(checkValue: checkValue, title: rawStrings[1]));
        } on RangeError {}
      }
    }

    for (int i = 0; i < uncheckedList.length; i++) {
      widgets.add(Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.check_box_outline_blank,
              size: 14,
              color: (note.color ?? 0) == 0
                  ? Theme.of(context).iconTheme.color
                  : getTextColorFromNoteColor(true)),
          Container(
            padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
            width: appInfo.isGridView
                ? MediaQuery.of(context).size.width / 2 - 88
                : MediaQuery.of(context).size.width - 108,
            child: Text(
              uncheckedList[i].title,
              semanticsLabel: uncheckedList[i].title + ": unchecked",
              overflow: TextOverflow.ellipsis,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                  color: (note.color ?? 0) == 0
                      ? Theme.of(context).textTheme.headline6.color
                      : getTextColorFromNoteColor(true)),
            ),
          )
        ],
      ));
    }

    for (int i = 0; i < checkedList.length; i++) {
      widgets.add(Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.check_box,
              size: 14,
              color: (note.color ?? 0) == 0
                  ? Theme.of(context).iconTheme.color
                  : getTextColorFromNoteColor(true)),
          Container(
            padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
            width: appInfo.isGridView
                ? MediaQuery.of(context).size.width / 2 - 88
                : MediaQuery.of(context).size.width - 108,
            child: Text(
              checkedList[i].title,
              semanticsLabel: checkedList[i].title + ": checked",
              overflow: TextOverflow.ellipsis,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                color: (note.color ?? 0) == 0
                    ? Theme.of(context).textTheme.headline6.color
                    : getTextColorFromNoteColor(true),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          )
        ],
      ));
    }

    return widgets;
  }
}
