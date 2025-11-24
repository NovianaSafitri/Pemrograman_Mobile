// lib/screens/note_list_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:ui'; // Diperlukan untuk ImageFilter (efek Glassmorphism)
import '../models/note.dart';

// Enum untuk Filter
enum FilterType { all, completed, pending }

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _allNotes = [];
  FilterType _currentFilter = FilterType.all;
  final _prefsKey = 'todoListNotes';
  final _titleController = TextEditingController();

  // --- INISIALISASI & PERSISTENSI ---
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_prefsKey);
    if (notesJson != null) {
      final List<dynamic> noteMaps = json.decode(notesJson);
      setState(() {
        _allNotes = noteMaps.map((map) => Note.fromMap(map)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> noteMaps = 
        _allNotes.map((note) => note.toMap()).toList();
    final String notesJson = json.encode(noteMaps); // Perbaikan: menggunakan itemMaps
    await prefs.setString(_prefsKey, notesJson);
  }

  // --- LOGIKA CRUD UTAMA ---

  void _addOrUpdateNote(String title, {Note? noteToEdit}) {
    if (noteToEdit != null) {
      // Logic EDIT
      setState(() {
        noteToEdit.title = title;
      });
    } else {
      // Logic TAMBAH
      setState(() {
        _allNotes.add(Note(title: title));
      });
    }
    _saveNotes();
  }

  void _toggleCompleted(Note note) {
    HapticFeedback.lightImpact(); 
    setState(() {
      note.isCompleted = !note.isCompleted;
    });
    _saveNotes();
  }

  void _deleteNote(String id) {
    setState(() {
      _allNotes.removeWhere((note) => note.id == id);
    });
    _saveNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tugas berhasil dihapus.'), duration: Duration(seconds: 1)),
    );
  }
  
  // --- FITUR HAPUS DENGAN KONFIRMASI ---
  void _deleteNoteWithConfirmation(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Anda yakin ingin menghapus tugas "${note.title}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: Colors.blueGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteNote(note.id); // Panggil fungsi hapus
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- FUNGSI MODAL TAMBAH/EDIT (Satu Modal untuk Keduanya) ---
  void _showNoteModal({Note? noteToEdit}) {
    final isEditing = noteToEdit != null;
    _titleController.text = isEditing ? noteToEdit.title : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'Edit Tugas' : 'Tambahkan Tugas Baru', 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A))
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Todo',
                hintText: 'Misalnya: Kerjakan proyek Flutter',
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  _addOrUpdateNote(title, noteToEdit: noteToEdit);
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
              child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan Tugas', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
  
  // --- LOGIKA FILTER ---
  List<Note> get _filteredNotes {
    return switch (_currentFilter) {
      FilterType.completed => _allNotes.where((note) => note.isCompleted).toList(),
      FilterType.pending => _allNotes.where((note) => !note.isCompleted).toList(),
      FilterType.all => _allNotes,
    };
  }

  // --- BUILD UTAMA ---

  @override
  Widget build(BuildContext context) {
    final displayedNotes = _filteredNotes;
    
    // Logika warna header untuk filter
    final Color headerColor = switch (_currentFilter) {
      FilterType.completed => Colors.green.shade700,
      FilterType.pending => Colors.orange.shade700,
      _ => const Color(0xFF1E3A8A)
    };
    
    final String filterTitle = switch (_currentFilter) {
      FilterType.completed => 'Tugas Selesai',
      FilterType.pending => 'Tugas Menunggu',
      _ => 'Semua Tugas'
    };

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteModal(),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 10,
        child: const Icon(Icons.add_task, size: 30),
      ),
      
      // Bottom Bar Glassmorphism Minimalis
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            color: Colors.white.withAlpha(0x5),
            elevation: 0,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                   SizedBox(width: 40), 
                   SizedBox(width: 40), 
                ],
              ),
            ),
          ),
        ),
      ),
      
      // Latar Belakang Gradien
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TaskFlow: Focus Anda', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF1E3A8A))),
                  PopupMenuButton<FilterType>(
                    initialValue: _currentFilter,
                    onSelected: (FilterType result) {
                      setState(() {
                        _currentFilter = result;
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterType>>[
                      const PopupMenuItem<FilterType>(value: FilterType.all, child: Text('Semua', style: TextStyle(color: Colors.black87))),
                      const PopupMenuItem<FilterType>(value: FilterType.completed, child: Text('Selesai', style: TextStyle(color: Colors.green))),
                      const PopupMenuItem<FilterType>(value: FilterType.pending, child: Text('Belum Selesai', style: TextStyle(color: Colors.orange))),
                    ],
                    icon: const Icon(Icons.filter_list, size: 28, color: Color(0xFF1E3A8A)),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Text(
                filterTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: headerColor),
              ),
            ),
            
            Expanded(
              child: displayedNotes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_note, size: 100, color: Colors.blue.shade300),
                          const SizedBox(height: 10),
                          Text(
                            _allNotes.isEmpty
                                ? "Tambahkan Tugas hari ini!"
                                : "Tidak ada tugas ${_currentFilter.name} yang cocok.",
                            style: TextStyle(fontSize: 18, color: Colors.blue.shade600, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: displayedNotes.length,
                      itemBuilder: (ctx, index) {
                        final note = displayedNotes[index];

                        return Slidable(
                          key: ValueKey(note.id),
                          // --- FITUR HAPUS: Aksi Geser ---
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) => _deleteNoteWithConfirmation(context, note),
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_forever,
                                label: 'Hapus',
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                              ),
                            ],
                          ),
                          // Card Glassmorphism
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // PERBAIKAN KONTRAST DI SINI
                                    color: note.isCompleted ? Colors.green.shade100.withAlpha(0x7) : Colors.white.withAlpha(0x3),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.white.withAlpha(0x5), width: 1.5),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: Checkbox(
                                      value: note.isCompleted,
                                      onChanged: (val) => _toggleCompleted(note),
                                      activeColor: note.isCompleted ? Colors.green.shade700 : Colors.blue.shade700, // Aktif Hijau/Biru
                                      checkColor: Colors.white,
                                      side: BorderSide(color: Colors.white.withAlpha(0x8), width: 2),
                                    ),
                                    title: Text(
                                      note.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                                        // PERBAIKAN KONTRAST DI SINI
                                        color: note.isCompleted ? Colors.green.shade800 : Colors.black87,
                                      ),
                                    ),
                                    subtitle: Text(
                                      note.isCompleted ? 'Tuntas!' : 'Belum Tuntas',
                                      style: TextStyle(
                                        // PERBAIKAN KONTRAST DI SINI
                                        color: note.isCompleted ? Colors.green.shade600 : Colors.black54,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    // --- FITUR EDIT: Aksi Tap pada ikon ---
                                    onTap: () => _showNoteModal(noteToEdit: note), // Tap pada ListTile juga memicu edit
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit, color: note.isCompleted ? Colors.green.shade700 : Colors.blue.shade600),
                                      onPressed: () => _showNoteModal(noteToEdit: note),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
