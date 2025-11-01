// notes_screen.dart - Peningkatan tampilan dan fitur
import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import 'note_form.dart'; // Import NoteForm

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  final NoteService _noteService = NoteService();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Note> _notes = [];
  bool _isSearching = false;
  String _sortOrder = 'newest';

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _searchController.addListener(_onSearchChanged);
  }

  void _loadNotes() {
    if (_sortOrder == 'newest') {
      _notes = _noteService.sortNotesByDate(ascending: false);
    } else if (_sortOrder == 'oldest') {
      _notes = _noteService.sortNotesByDate(ascending: true);
    } else {
      _notes = _noteService.getAllNotes();
    }
    setState(() {});
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _notes = _noteService.searchNotes(query);
      });
    } else {
      _loadNotes();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
        _loadNotes();
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Urutkan Berdasarkan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Terbaru'),
                  selected: _sortOrder == 'newest',
                  onTap: () {
                    setState(() => _sortOrder = 'newest');
                    _loadNotes();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Terlama'),
                  selected: _sortOrder == 'oldest',
                  onTap: () {
                    setState(() => _sortOrder = 'oldest');
                    _loadNotes();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title:
            _isSearching
                ? SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.horizontal,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari catatan...',
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                  ),
                )
                : const Text(
                  'My Notes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortOptions),
        ],
      ),
      body:
          _notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/image2.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada catatan',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan catatan baru dengan menekan tombol +',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  key: ValueKey<int>(_notes.length),
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (_, index) {
                      final note = _notes[index];
                      return NoteItem(
                        note: note,
                        onDelete: () {
                          _noteService.deleteNote(index);
                          setState(() {
                            _notes.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Catatan berhasil dihapus'),
                            ),
                          );
                        },
                        onEdit: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      NoteForm(note: note, isEditing: true),
                            ),
                          );
                          if (result == true) {
                            _loadNotes();
                          }
                        },
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: note,
                          );
                          if (result == true) {
                            _loadNotes();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
