// import 'package:flutter/material.dart';
// import '../models/note_model.dart';
// import '../services/note_service.dart';
// import '../widgets/note_item.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final NoteService _noteService = NoteService();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   void _addNote() {
//     final title = _titleController.text;
//     final content = _contentController.text;

//     if (title.isEmpty || content.isEmpty) return;

//     final note = Note(
//       title: title,
//       content: content,
//       createdAt: DateTime.now(),
//     );

//     _noteService.addNote(note);

//     _titleController.clear();
//     _contentController.clear();

//     setState(() {}); // untuk memperbarui tampilan
//   }

//   @override
//   Widget build(BuildContext context) {
//     final notes = _noteService.getAllNotes();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Catatan Harian')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(labelText: 'Judul'),
//                 ),
//                 TextField(
//                   controller: _contentController,
//                   decoration: const InputDecoration(labelText: 'Isi'),
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: _addNote,
//                   child: const Text('Simpan Catatan'),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: notes.length,
//               itemBuilder: (_, index) {
//                 final note = notes[index];
//                 return NoteItem(
//                   note: note,
//                   onDelete: () {
//                     _noteService.deleteNote(index);
//                     setState(() {}); // refresh tampilan setelah delete
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
