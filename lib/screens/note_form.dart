import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final bool isEditing;

  const NoteForm({super.key, this.note, this.isEditing = false});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final NoteService _noteService = NoteService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Debug logging to check parameters
    print('NoteForm opened: isEditing=${widget.isEditing}, note=${widget.note}');
    // Initialize controllers with note data or empty strings
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    // Handle invalid edit mode
    if (widget.isEditing && widget.note == null) {
      print('Warning: Edit mode requested but note is null');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Catatan tidak ditemukan untuk diedit')),
        );
        Navigator.pop(context);
      });
    }
  }

  void saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text;
    final content = _contentController.text;

    if (widget.isEditing && widget.note != null) {
      final updatedNote = Note(
        title: title,
        content: content,
        createdAt: widget.note!.createdAt,
      );
      _noteService.updateNote(widget.note!, updatedNote);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil diperbarui')),
      );
    } else {
      final newNote = Note(
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );
      _noteService.addNote(newNote);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan')),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.isEditing && widget.note != null ? "Edit Catatan" : "Catatan Baru"),
        backgroundColor: Colors.deepPurple.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Judul Catatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.title, color: Colors.deepPurple),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: "Isi Catatan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.description, color: Colors.deepPurple),
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi catatan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: saveNote,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.deepPurple.withAlpha(76),
            elevation: 5,
          ),
          child: Text(
            widget.isEditing && widget.note != null ? "Perbarui Catatan" : "Simpan Catatan",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}