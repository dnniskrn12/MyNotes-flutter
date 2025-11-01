// note_service.dart - Penambahan fitur update dan pencarian
import 'package:hive/hive.dart';
import '../models/note_model.dart';

class NoteService {
  final Box<Note> _noteBox = Hive.box<Note>('notes');

  List<Note> getAllNotes() {
    return _noteBox.values.toList();
  }

  void addNote(Note note) {
    _noteBox.add(note);
  }

  void updateNote(Note oldNote, Note updatedNote) {
    final index = _noteBox.values.toList().indexOf(oldNote);
    if (index != -1) {
      _noteBox.putAt(index, updatedNote);
    }
  }

  void deleteNote(int index) {
    _noteBox.deleteAt(index);
  }
  
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return getAllNotes();
    
    return _noteBox.values.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
             note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  
  List<Note> sortNotesByDate({bool ascending = false}) {
    final notes = getAllNotes();
    notes.sort((a, b) => ascending 
      ? a.createdAt.compareTo(b.createdAt)
      : b.createdAt.compareTo(a.createdAt));
    return notes;
  }
}