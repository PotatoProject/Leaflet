import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/localizations.dart';
import 'package:potato_notes/internal/methods.dart';
import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/internal/search_filters.dart';
import 'package:provider/provider.dart';

class SearchNotesRoute extends StatefulWidget {
  final List<Note> noteList;

  SearchNotesRoute({@required this.noteList});

  @override
  _SearchNotesState createState() => new _SearchNotesState(noteList);
}

class _SearchNotesState extends State<SearchNotesRoute> {
  List<Note> noteList;

  _SearchNotesState(List<Note> providedNoteList) {
    this.noteList = providedNoteList;
  }

  NoteHelper noteHelper = new NoteHelper();
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  static String searchTerms = "";

  TextEditingController searchController =
      TextEditingController(text: searchTerms);

  SearchFiltersProvider searchFilters;

  AppLocalizations locales;

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);
    locales = AppLocalizations.of(context);

    Brightness systemBarsIconBrightness =
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    changeSystemBarsColors(
        Theme.of(context).cardColor, systemBarsIconBrightness);

    double getAlphaFromTheme() {
      switch (appInfo.themeMode) {
        case 0:
          return 0.1;
        case 1:
          return 0.2;
        case 2:
          return 0.3;
        default:
          return 0;
      }
    }

    Color cardColor = Theme.of(context).textTheme.title.color;

    double cardBrightness = getAlphaFromTheme();

    Color borderColor =
        HSLColor.fromColor(cardColor).withAlpha(cardBrightness).toColor();

    List<Widget> widgets = noteSearchList(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: 70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => searchTerms = "");
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                          child: Container(
                        width: MediaQuery.of(context).size.width - 136,
                        child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: borderColor, width: 1.5),
                            ),
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 2),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        locales.searchNotesRoute_searchbar),
                                maxLines: 1,
                                onChanged: (text) {
                                  setState(() {
                                    searchTerms = text;
                                    widgets = noteSearchList(context);
                                  });
                                },
                              ),
                            )),
                      )),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () =>
                          showFiltersScrollableBottomSheet(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 70,
                left: 20,
                right: 20),
            child: searchTerms == ""
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.short_text,
                            size: 50.0,
                            color: HSLColor.fromColor(
                                    Theme.of(context).textTheme.title.color)
                                .withAlpha(0.4)
                                .toColor()),
                        Text(
                          locales.searchNotesRoute_noQuery,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: HSLColor.fromColor(
                                    Theme.of(context).textTheme.title.color)
                                .withAlpha(0.4)
                                .toColor(),
                          ),
                        ),
                      ],
                    ),
                  )
                : widgets.length == 0
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.search,
                                size: 50.0,
                                color: HSLColor.fromColor(
                                        Theme.of(context).textTheme.title.color)
                                    .withAlpha(0.4)
                                    .toColor()),
                            Text(
                              locales.searchNotesRoute_nothingFound,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: HSLColor.fromColor(
                                        Theme.of(context).textTheme.title.color)
                                    .withAlpha(0.4)
                                    .toColor(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: widgets,
                      ),
          ),
        ],
      ),
    );
  }

  List<Widget> noteSearchList(BuildContext context) {
    searchFilters = Provider.of<SearchFiltersProvider>(context);
    List<int> indexesList = List<int>();
    List<Widget> widgetList = List<Widget>();

    for (int i = 0; i < noteList.length; i++) {
      String noteTitle = searchFilters.caseSensitive
          ? noteList[i].title
          : noteList[i].title.toLowerCase();
      String noteContent = searchFilters.caseSensitive
          ? noteList[i].content
          : noteList[i].content.toLowerCase();
      String query =
          searchFilters.caseSensitive ? searchTerms : searchTerms.toLowerCase();
      String noteDate = DateFormat("dd MM yyyy")
          .format(DateTime.fromMillisecondsSinceEpoch(noteList[i].date));
      String filterDate = searchFilters.date == null
          ? null
          : DateFormat("dd MM yyyy")
              .format(DateTime.fromMillisecondsSinceEpoch(searchFilters.date));
      int noteColor = noteList[i].color;

      bool addToList = noteList[i].hideContent == 0 &&
          ((noteTitle.contains(query) || noteContent.contains(query)) &&
              (searchFilters.color == null
                  ? true
                  : noteColor == searchFilters.color)) &&
          (filterDate == null ? true : noteDate == filterDate);

      if (addToList) {
        indexesList.add(i);
      }
    }

    for (int i = 0; i < indexesList.length; i++) {
      widgetList.add(noteListItem(context, indexesList[i]));
    }

    return widgetList;
  }

  Widget noteListItem(BuildContext context, int index) {
    Color cardColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).dividerColor
        : Theme.of(context).scaffoldBackgroundColor;

    double cardBrightness =
        Theme.of(context).brightness == Brightness.dark ? 0.8 : 0.96;

    Color borderColor =
        HSLColor.fromColor(cardColor).withLightness(cardBrightness).toColor();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                    visible: noteList[index].title == "" ? false : true,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 94,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          noteList[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 99999,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 94,
                    child: Text(
                      noteList[index].content,
                      overflow: TextOverflow.ellipsis,
                      textWidthBasis: TextWidthBasis.parent,
                      maxLines: 99999,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void showFiltersScrollableBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      locales.searchNotesRoute_filters_title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 68),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SwitchListTile(
                        secondary: Icon(Icons.text_format),
                        title: Text(locales.searchNotesRoute_filters_case),
                        onChanged: (value) =>
                            searchFilters.caseSensitive = value,
                        value: searchFilters.caseSensitive,
                      ),
                      ListTile(
                        leading: Icon(Icons.color_lens),
                        title: Text(locales.searchNotesRoute_filters_color),
                        trailing: CircleColor(
                          elevation: 0,
                          circleSize: 24,
                          color: searchFilters.color == null
                              ? HSLColor.fromColor(
                                      Theme.of(context).textTheme.title.color)
                                  .withAlpha(0.4)
                                  .toColor()
                              : Color(searchFilters.color),
                        ),
                        onTap: () => showColorDialog(context),
                      ),
                      ListTile(
                        leading: Icon(Icons.date_range),
                        title: Text(locales.searchNotesRoute_filters_date),
                        trailing: searchFilters.date == null
                            ? null
                            : Text(DateFormat("dd MMMM yyyy").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    searchFilters.date))),
                        onTap: () async {
                          DateTime picker = await showDatePicker(
                            context: context,
                            initialDate: searchFilters.date == null
                                ? DateTime.now()
                                : DateTime.fromMillisecondsSinceEpoch(
                                    searchFilters.date),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2100),
                            builder: (context, widget) {
                              return widget;
                            },
                          );

                          if (picker != null) {
                            searchFilters.date = picker.millisecondsSinceEpoch;
                          } else {
                            searchFilters.date = null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showColorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          Color currentColor = searchFilters.color == null
              ? Colors.transparent
              : Color(searchFilters.color);
          List<ColorSwatch<dynamic>> colors = <ColorSwatch>[
            MaterialColor(0x00000000, {500: Colors.transparent}),
            MaterialColor(0xFFFFB182, {500: Color(0xFFFFB182)}),
            MaterialColor(0xFFFFF18E, {500: Color(0xFFFFF18E)}),
            MaterialColor(0xFFFFE8D1, {500: Color(0xFFFFE8D1)}),
            MaterialColor(0xFFD8D4F2, {500: Color(0xFFD8D4F2)}),
            MaterialColor(0xFFB9D6F2, {500: Color(0xFFB9D6F2)}),
            MaterialColor(0xFFFFB8D1, {500: Color(0xFFFFB8D1)}),
            MaterialColor(0xFFBCFFC3, {500: Color(0xFFBCFFC3)}),
          ];

          return AlertDialog(
            title: Text(locales.modifyNotesRoute_color_dialogTitle),
            content: MaterialColorPicker(
              colors: colors,
              allowShades: false,
              circleSize: 70.0,
              onMainColorChange: (color) {
                setState(() => currentColor = color);
              },
              selectedColor: currentColor,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  if (currentColor.toString() ==
                          "MaterialColor(primary value: Color(0x00000000))" ||
                      currentColor.toString() == "Color(0x00000000)") {
                    setState(() => searchFilters.color = null);
                  } else {
                    setState(() => searchFilters.color = currentColor.value);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
