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

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFFF4081); // Menggunakan nilai const untuk Coral Pink (untuk konsistensi)

    return _buildGradientBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi Fade-In dan Slide-Up untuk Ikon
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final double safeOpacity = value.clamp(0.0, 1.0); 

                return Opacity(
                  opacity: safeOpacity, 
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Icon(
                      Icons.star_border, 
                      size: 120 * value.clamp(0.0, 1.0),
                      color: accentColor, // Warna ikon Coral
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Animasi Fade-In dan Scale untuk Teks
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                final double safeOpacity = value.clamp(0.0, 1.0);
                return Opacity(
                  opacity: safeOpacity,
                  child: Transform.scale(
                    scale: value,
                    child: const Text(
                      'Tab Pertama: Coral Coast 🏝️',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Teks Putih
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Ini adalah halaman pertama Anda di Bottom Nav Bar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // SnackBar tetap non-const karena menggunakan accentColor
                ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                    content:  Text('Tombol Coral Coast ditekan!'), 
                    backgroundColor: accentColor,
                  ),
                );
             },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Aksi Tab 1'),
              // FIX: Menggunakan styleFrom yang non-const untuk menampung accentColor
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}