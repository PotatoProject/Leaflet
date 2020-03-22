import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/database/bloc/bloc_provider.dart';
import 'package:potato_notes/database/bloc/notes_bloc.dart';
import 'package:potato_notes/database/model/note.dart';
import 'package:spicy_components/spicy_components.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  NotesBloc _notesBloc;

  @override
  void initState() {
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Note>>(
        stream: _notesBloc.notes,
        builder: (context, snapshot) {
          if((snapshot.data?.length ?? 0) != 0) {
            return StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return Text(snapshot.data[index].content);
              },
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemCount: snapshot.data.length,
            );
          } else return Text("bruh");
        },
      ),
      bottomNavigationBar: SpicyBottomBar(
        leftItems: [
          IconButton(
            icon: Icon(Icons.menu),
            padding: EdgeInsets.all(0),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(OMIcons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}