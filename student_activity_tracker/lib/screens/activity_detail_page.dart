// lib/screens/activity_detail_page.dart
import 'package:flutter/material.dart';
import '../model/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final ActivityModel activity;
  final Function(ActivityModel) onDelete;
  final Function(ActivityModel) onToggleCompletion;

  const ActivityDetailPage({
    super.key,
    required this.activity,
    required this.onDelete,
    required this.onToggleCompletion,
  });

  // FIX UTAMA: Fungsi untuk kembali ke Dashboard (MainScreen - Rute Pertama)
  void _returnToDashboard(BuildContext context) {
    // Menggunakan popUntil untuk menghapus semua rute hingga rute pertama (MainScreen/Dashboard).
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // Fungsi untuk menampilkan konfirmasi Hapus (Kriteria UTS)
  void _showDeleteConfirmation(BuildContext context) {
    // FIX: Menggunakan showDialog dengan benar
    showDialog( 
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
          title: const Text('Hapus Aktivitas?'),
          content: Text('Anda yakin ingin menghapus aktivitas "${activity.name}"? Tindakan ini tidak dapat dibatalkan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Tutup dialog
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 1. Tutup dialog konfirmasi
                onDelete(activity);         // 2. Panggil fungsi hapus
                
                // 3. Kembali ke MainScreen (Pop dua kali). 
                // Jika ingin selalu kembali ke Home/Dashboard tab, pastikan MainScreen
                // diimplementasikan sebagai Stateful dan memiliki logika untuk reset currentIndex
                // saat rute baru di-pop. Untuk kasus ini, pop dua kali sudah cukup.
                Navigator.of(context).pop(); // Kembali ke halaman induk
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white),
              child: const Text('Hapus Permanen'),
            ),
          ],
        );
      },
    );
  }

  // Widget pembantu untuk item detail
  Widget _buildDetailItem(BuildContext context, {required String title, required String value, IconData? icon, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon ?? Icons.info_outline, color: color ?? Theme.of(context).colorScheme.primary, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        // Tombol kembali di AppBar juga akan menggunakan popUntil secara default 
        // jika kita mengatur AppBar dengan benar. Namun, kita fokus pada tombol di body.
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header Aktivitas
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge Animasi
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Chip(
                        key: ValueKey(activity.isCompleted),
                        avatar: Icon(activity.isCompleted ? Icons.verified : Icons.pending_rounded, size: 18),
                        label: Text(activity.isCompleted ? 'SELESAI' : 'TERTUNDA'),
                        backgroundColor: activity.isCompleted ? Colors.green.shade400 : Colors.orange.shade400,
                        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      activity.name,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onPrimaryContainer,
                        decoration: activity.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // Detail Card (Menampilkan item detail)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildDetailItem(context, title: 'Kategori', value: activity.category, icon: Icons.bookmark_rounded),
                    _buildDetailItem(context, title: 'Durasi', value: '${activity.duration.toStringAsFixed(1)} Jam', icon: Icons.schedule_rounded),
                    _buildDetailItem(context, title: 'Catatan Tambahan', value: activity.notes != null && activity.notes!.isNotEmpty ? activity.notes! : 'Tidak ada catatan.', icon: Icons.text_snippet_rounded, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Aksi (Toggle Status)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  onToggleCompletion(activity);
                  // Force rebuild to show new status instantly
                  (context as Element).markNeedsBuild(); 
                },
                // FIX: Memastikan argumen label ada
                icon: Icon(activity.isCompleted ? Icons.undo_rounded : Icons.check_circle_outline),
                label: Text(activity.isCompleted ? 'Tandai BELUM Selesai' : 'Tandai SELESAI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: activity.isCompleted ? Colors.orange.shade600 : Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Tombol Hapus (Kriteria UTS)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmation(context),
                // FIX: Memastikan argumen label ada
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus Aktivitas'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade300, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Tombol Kembali (Kriteria UTS)
            TextButton(
              // FIX UTAMA: Memanggil fungsi yang memaksa kembali ke root
              onPressed: () => _returnToDashboard(context),
              child: const Text('Kembali ke Dashboard'),
            )
          ],
        ),
      ),
    );
  }
}