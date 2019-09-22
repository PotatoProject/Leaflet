import 'package:flutter/material.dart';

import 'package:potato_notes/internal/note_helper.dart';
import 'package:potato_notes/routes/modify_notes_route.dart';

class SecurityNoteRoute extends StatefulWidget {
  Note note = Note();

  SecurityNoteRoute(Note note) {
    this.note = note;
  }

  @override createState() => _SecurityNoteRouteState();
}

class _SecurityNoteRouteState extends State<SecurityNoteRoute> {
  String text = "";
  bool error = false;

  @override
  void initState() {
    super.initState();
    text = "";
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> portraitContent = <Widget>[
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70),
        height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + 70),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Icon(
                  Icons.lock,
                  size: 120,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.note.pin != null ?
                      "A PIN is requested to open the note" :
                      "A password is requested to open the note",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  error ?
                      widget.note.pin != null ?
                          "Wrong pin" :
                          "Wrong password" :
                      "",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Visibility(
                visible: widget.note.pin != null,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildPinViewer(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            pinButton("1", true),
                            pinButton("2", true),
                            pinButton("3", true),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            pinButton("4", true),
                            pinButton("5", true),
                            pinButton("6", true),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            pinButton("7", true),
                            pinButton("8", true),
                            pinButton("9", true),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            pinEmptyButton(true),
                            pinButton("0", true),
                            eraseButton(true),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.note.password != null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    obscureText: true,
                    onSubmitted: (text) async {
                      if(text != widget.note.password.toString()) {
                        setState(() {
                          text = "";
                          error = true;
                        });
                      } else {
                        error = false;
                        var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(widget.note)));

                        if(result == null || result != null) Navigator.pop(context);
                      }
                    },
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    ];

    List<Widget> landscapeContent = <Widget>[
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70),
        height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + 70),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + 70),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.lock,
                        size: 120,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.note.pin != null ?
                            "A PIN is requested to open the note" :
                            "A password is requested to open the note",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        error ?
                            widget.note.pin != null ?
                                "Wrong pin" :
                                "Wrong password" :
                            "",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + 70),
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: widget.note.pin != null,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: buildPinViewer(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  pinButton("1", false),
                                  pinButton("2", false),
                                  pinButton("3", false),
                                  pinButton("4", false),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  pinButton("5", false),
                                  pinButton("6", false),
                                  pinButton("7", false),
                                  pinButton("8", false),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  pinEmptyButton(false),
                                  pinButton("9", false),
                                  pinButton("0", false),
                                  eraseButton(false),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.note.password != null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          obscureText: true,
                          onSubmitted: (text) async {
                            if(text != widget.note.password.toString()) {
                              setState(() {
                                text = "";
                                error = true;
                              });
                            } else {
                              error = false;
                              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(widget.note)));

                              if(result == null || result != null) Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: MediaQuery.of(context).orientation == Orientation.landscape ? landscapeContent : portraitContent,
      ),
    );
  }

  List<Widget> buildPinViewer() {
    List<Widget> widgets = [];

    for(int i = 0; i < widget.note.pin.toString().length; i++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: i >= text.length ? Colors.transparent : Theme.of(context).textTheme.title.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).textTheme.title.color,
                width: 1.5
              )
            ),
          ),
        )
      );
    }

    return widgets;
  }
  
  Widget pinButton(String char, bool portrait) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: portrait ? 16 : 6, horizontal: portrait ? 20 : 8),
      child: IconButton(
        iconSize: portrait ? 60 : 50,
        icon: Text(
          char,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500
          ),
        ),
        onPressed: () async {
          error = false;
          setState(() => text += char);
          if(text.length == widget.note.pin.toString().length) {
            if(text != widget.note.pin.toString()) {
              setState(() {
                text = "";
                error = true;
              });
            } else {
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyNotesRoute(widget.note)));

              if(result == null || result != null) Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  Widget eraseButton(bool portrait) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: portrait ? 16 : 6, horizontal: portrait ? 20 : 10),
      child: IconButton(
        iconSize: portrait ? 60 : 50,
        icon: Icon(
          Icons.keyboard_backspace,
          size: 30,
        ),
        onPressed: () async {
          if(text.length > 0) {
            setState(() => text = text.substring(0, text.length - 1));
          }
        },
      ),
    );
  }

  Widget pinEmptyButton(bool portrait) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: portrait ? 16 : 6, horizontal: portrait ? 20 : 10),
      child: IconButton(
        iconSize: portrait ? 60 : 50,
        icon: Text(
          "",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500
          ),
        ),
        onPressed: null,
      ),
    );
  }
}