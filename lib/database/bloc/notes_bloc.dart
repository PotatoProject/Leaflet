import 'dart:async';

import 'package:potato_notes/database/bloc/bloc_provider.dart';
import 'package:potato_notes/database/model/note.dart';
import 'package:potato_notes/database/note_helper.dart';

class NotesBloc implements BlocBase {
	final _notesController = StreamController<List<Note>>.broadcast();

	StreamSink<List<Note>> get _inNotes => _notesController.sink;

	Stream<List<Note>> get notes => _notesController.stream;

	final _addNoteController = StreamController<Note>.broadcast();
	StreamSink<Note> get inAddNote => _addNoteController.sink;

	NotesBloc() {
		getNotes();

		_addNoteController.stream.listen(_handleAddNote);
	}

	@override
	void dispose() {
		_notesController.close();
		_addNoteController.close();
	}

	void getNotes() async {
		List<Note> notes = await NoteHelper.db.listNotes();

		_inNotes.add(notes);
	}

	void _handleAddNote(Note note) async {
		await NoteHelper.db.newNote(note);

		getNotes();
	}
}