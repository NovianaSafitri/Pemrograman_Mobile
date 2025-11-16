// lib/screens/welcome_screen.dart (FILE BARU)
import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import MainScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Fungsi untuk simulasi login dan navigasi ke MainScreen
  void _simulateLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.assignment_turned_in_outlined, 
                size: 100, 
                color: colorScheme.onPrimary
              ),
              const SizedBox(height: 20),
              Text(
                'Student Activity Tracker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Catat, lacak, dan capai target harian Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onPrimary.withAlpha(0x8),
                ),
              ),
              const SizedBox(height: 60),

              // Tombol Simulasi Login
              ElevatedButton.icon(
                onPressed: () => _simulateLogin(context),
                icon: const Icon(Icons.login),
                label: const Text('Mulai / Login Simulasi', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}