// lib/main.dart (Diperbarui untuk Dark Theme Biru-Hijau)
import 'package:flutter/material.dart';
import 'package:student_activity_tracker/screens/splash_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const StudentActivityTracker());
}

class StudentActivityTracker extends StatelessWidget {
  const StudentActivityTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // FIX: Menggunakan Brightness DARK dan Green/Cyan sebagai base
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Warna teal/biru-hijau sebagai base
          brightness: Brightness.dark, 
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}