import 'package:flutter/material.dart';

// Helper Widget: Latar Belakang Gradien Biru Laut
Widget _buildGradientBackground({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4FC3F7), 
          Color(0xFF0D47A1), 
        ],
      ),
    ),
    child: child,
  );
}

class ReplacementScreen extends StatelessWidget {
  const ReplacementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        title: const Text('Halaman Pengganti (Replacement) 🔄'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: _buildGradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Animasi Icon Pulse (Berdenyut)
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  // Menggunakan builder: (context, scale, child) { return Transform.scale(...) }
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Icon(
                        Icons.swap_calls,
                        size: 80,
                        color: Colors.red.shade100, // Warna cerah, kontras dengan background
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Halaman Utama TELAH DIGANTI!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Halaman ini menggunakan Push Replacement; ia menghapus halaman sebelumnya dari tumpukan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Tutup Halaman'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}