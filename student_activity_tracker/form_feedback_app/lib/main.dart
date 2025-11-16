// file: lib/main.dart (KODE FINAL DAN BEBAS ERROR)
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'feedback_form_page.dart';
import 'detail_page.dart';
import 'model_data.dart'; // <-- DIPERBAIKI: Mengubah model_data.dart menjadi data_model.dart

void main() {
  runApp(const FormFeedbackApp());
}

// Ubah menjadi StatefulWidget untuk menahan data aplikasi
class FormFeedbackApp extends StatefulWidget {
  const FormFeedbackApp({super.key});

  @override
  State<FormFeedbackApp> createState() => _FormFeedbackAppState();
}

class _FormFeedbackAppState extends State<FormFeedbackApp> {
  // --- Data Global (State) ---
  final FeedbackData _feedbackData = FeedbackData();
  
  // Fungsi callback untuk dioper ke Form Page
  void _addFeedback(ReviewItem review) {
    setState(() {
      _feedbackData.addReview(review); // Mutasi data
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Feedback',
      theme: ThemeData(
        // Tema Dark Mode
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), 
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        )
      ),
      initialRoute: '/',
      routes: {
        // Kirim data LIVE ke HomePage
        '/': (context) => HomePage(data: _feedbackData), 
        
        // Kirim fungsi callback ke FeedbackFormPage
        '/feedbackForm': (context) => FeedbackFormPage(
              onFeedbackSubmitted: _addFeedback, 
            ),
        
        // HAPUS RUTE '/detail' yang bermasalah. DetailPage dibuka melalui Navigator.push
      },
    );
  }
}