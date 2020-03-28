import 'dart:async';

import 'package:potato_notes/database/bloc/bloc_provider.dart';
import 'package:potato_notes/database/model/note.dart';
import 'package:potato_notes/database/note_helper.dart';

class NotesBloc implements BlocBase {
	final _notesController = StreamController<List<Note>>.broadcast();

	StreamSink<List<Note>> get _inNotes => _notesController.sink;

	Stream<List<Note>> get notes => _notesController.stream;

	final _saveNoteController = StreamController<Note>.broadcast();
	StreamSink<Note> get saveQueue => _saveNoteController.sink;

  final _deleteNoteController = StreamController<int>.broadcast();
	StreamSink<int> get deleteQueue => _deleteNoteController.sink;

	NotesBloc() {
		getNotes();

		_saveNoteController.stream.listen(_handleSaveNote);
		_deleteNoteController.stream.listen(_handleDeleteNote);
	}

	@override
	void dispose() {
		_notesController.close();
		_saveNoteController.close();
    _deleteNoteController.close();
	}

	void getNotes() async {
		List<Note> notes = await NoteHelper.db.listNotes();

		_inNotes.add(notes);
	}

	void _handleSaveNote(Note note) async {
		await NoteHelper.db.saveNote(note);

		getNotes();
	}

	void _handleDeleteNote(int id) async {
		await NoteHelper.db.deleteNote(id);

		getNotes();
	}
}