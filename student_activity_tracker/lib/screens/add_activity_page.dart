// lib/screens/add_activity_page.dart
import 'package:flutter/material.dart';
import '../model/activity_model.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _formKey = GlobalKey<FormState>();

  // State Variables
  String _name = '';
  String? _category;
  double _duration = 2.0;
  bool _isCompleted = false;
  String _notes = '';

  final List<String> _categories = [
    'Belajar', 'Ibadah', 'Olahraga', 'Hiburan', 'Lainnya'
  ];

  // Kriteria UTS: AlertDialog untuk validasi nama kosong
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          title: const Text('Nama Wajib Diisi!'),
          content: const Text('Aktivitas harus memiliki nama untuk dapat disimpan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveActivity() {
    if (_formKey.currentState!.validate() && _category != null) {
      _formKey.currentState!.save();

      final newActivity = ActivityModel(
        name: _name,
        category: _category!,
        duration: _duration,
        isCompleted: _isCompleted,
        notes: _notes.isEmpty ? null : _notes,
      );

      // Kriteria UTS: Kirim data kembali ke HomePage
      Navigator.pop(context, newActivity);
    } else {
      _showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Aktivitas Baru'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- 1. Nama Aktivitas ---
              Text('Nama Aktivitas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Cth: Belajar Struktur Data',
                  prefixIcon: Icon(Icons.label_important_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama aktivitas wajib diisi.' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 24),

              // --- 2. Kategori (DropdownButtonFormField) ---
              Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  hintText: 'Pilih Kategori',
                  prefixIcon: Icon(Icons.category_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => _category = newValue);
                },
                validator: (value) => value == null ? 'Kategori harus dipilih' : null,
                onSaved: (value) => _category = value,
              ),
              const SizedBox(height: 24),

              // --- 3. Durasi (Slider) ---
              Text(
                'Durasi: ${_duration.round()} Jam',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary),
              ),
              Slider(
                value: _duration,
                min: 1,
                max: 8,
                divisions: 7,
                label: '${_duration.round()}',
                activeColor: colorScheme.secondary,
                onChanged: (double value) => setState(() => _duration = value),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1 Jam (Min)', style: TextStyle(fontSize: 12)),
                    Text('8 Jam (Max)', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- 4. Status Selesai/Belum (SwitchListTile dengan Animasi) ---
              Text('Status Penyelesaian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary)),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: _isCompleted ? Colors.green.shade100 : colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _isCompleted ? Colors.green.shade400 : Colors.transparent, width: 2),
                ),
                child: SwitchListTile(
                  title: const Text('Tandai Selesai?', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(_isCompleted ? 'Aktivitas sudah diselesaikan' : 'Aktivitas masih tertunda'),
                  value: _isCompleted,
                  onChanged: (bool value) => setState(() => _isCompleted = value),
                  secondary: Icon(
                    _isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                    color: _isCompleted ? Colors.green.shade600 : colorScheme.primary,
                  ),
                  activeColor: Colors.green.shade600,
                  tileColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 24),

              // --- 5. Catatan Tambahan (TextField Multiline, Opsional) ---
              Text('Catatan Tambahan (Opsional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Detail, tantangan, atau hasil...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 50.0),
                    child: Icon(Icons.notes_rounded),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  alignLabelWithHint: true,
                ),
                onSaved: (value) => _notes = value ?? '',
              ),
              const SizedBox(height: 40),

              // --- 6. Tombol Simpan (ElevatedButton) ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveActivity,
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('SIMPAN AKTIVITAS', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('BATAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}