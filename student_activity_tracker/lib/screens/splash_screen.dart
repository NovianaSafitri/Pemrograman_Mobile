// lib/screens/splash_screen.dart (Versi Asli, Tanpa Asset Gambar)

import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import MainScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller dan animasi fade
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durasi fade-in 1 detik
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward(); // Mulai animasi

    // Navigasi ke MainScreen setelah 3 detik total
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return; // Pastikan widget masih ada
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Background menggunakan warna primary dari tema (Biru)
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, 
      body: Center(
        child: FadeTransition( // Widget untuk animasi Fade In
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan Icon standar Flutter
              Icon(
                Icons.track_changes_rounded, // Ikon pelacakan
                size: 100,
                color: Theme.of(context).colorScheme.onPrimary, // Warna putih/kontras
              ),
              const SizedBox(height: 20),
              // Judul Aplikasi
              Text(
                'Student Activity Tracker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 10),
              // Slogan
              Text(
                'Mencatat Setiap Langkah Suksesmu', // Slogan Awal
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(0x8),
                ),
              ),
              const SizedBox(height: 50),
              // Indikator Loading
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}