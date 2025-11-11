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

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Colors.amberAccent; // Aksen: Amber Gold

    return _buildGradientBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi Icon dengan Rotasi Penuh & Scale
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Transform.rotate(
                    angle: value * 2 * 3.14159, // Rotasi 2 putaran penuh (720 derajat)
                    child: const Icon(
                      Icons.diamond,
                      size: 100,
                      color: accentColor, // Warna ikon Gold
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Teks dengan Fade-In Sederhana
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: const Text(
                    'Tab Kedua: Golden Jewel 💎',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Halaman ini menampilkan animasi putaran yang unik.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:  Text('Tombol Golden Jewel ditekan!'),
                    backgroundColor: accentColor,
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Aksi Tab 2'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}