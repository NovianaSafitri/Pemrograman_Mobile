// file: lib/detail_page.dart (KODE FINAL DAN BEBAS ERROR)

import 'package:flutter/material.dart';
import 'model_data.dart'; // <-- Pastikan ini mengarah ke data_model.dart

// Catatan: Kode ini tidak lagi memerlukan 'package:flutter_rating_bar/flutter_rating_bar.dart'

class DetailPage extends StatelessWidget {
  final ReviewItem feedback; // Menggunakan ReviewItem dari data_model.dart

  const DetailPage({super.key, required this.feedback});

  // Widget Bintang Reusable (Diambil dari logika bintang bawaan)
  Widget _buildStarRating(double rating, {double size = 28, Color color = Colors.amber}) {
    // Menggunakan logika Row dan Icon bawaan untuk menghindari package eksternal
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() 
              ? Icons.star_rate_rounded 
              : (index < rating ? Icons.star_half_rounded : Icons.star_border_rounded),
          color: color,
          size: size,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = feedback.rating >= 4 
        ? Colors.green.shade600 
        : (feedback.rating >= 3 ? Colors.amber.shade700 : Colors.red.shade600);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark Mode Background
      appBar: AppBar(
        title: const Text('Detail Ulasan'),
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0,
        actions: const [
          IconButton(icon: Icon(Icons.reply_rounded), onPressed: null),
          IconButton(icon: Icon(Icons.more_vert_rounded), onPressed: null),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian 1: Ringkasan Pengguna dan Rating ---
            _buildUserSummaryCard(context, feedback, accentColor),
            
            const SizedBox(height: 25),

            // --- Bagian 2: Konten Ulasan ---
            const Text(
              'Ulasan Lengkap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildCommentCard(feedback.comment),

            const SizedBox(height: 25),

            // --- Bagian 3: Analisis/Metadata Tambahan ---
            const Text(
              'Analisis Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildAnalysisSection(feedback),
          ],
        ),
      ),
    );
  }

  // Widget untuk Ringkasan Pengguna dan Rating
  Widget _buildUserSummaryCard(BuildContext context, ReviewItem item, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF282828), // Warna Card Dark Mode
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: 'avatar-${item.reviewerName}',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF6A1B9A), // Ungu tua
                  child: Text(
                    item.reviewerName.isNotEmpty ? item.reviewerName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.reviewerName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Diulas ${item.timeAgo}',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30, color: Colors.white10),
          
          // Visualisasi Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating Ulasan: ${item.rating.toStringAsFixed(1)}/5.0',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  _buildStarRating(item.rating, size: 28), // Menggunakan widget bintang yang sudah diperbaiki
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(50), 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.rating >= 4 ? 'Positif' : (item.rating >= 3 ? 'Netral' : 'Negatif'),
                  style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk Konten Komentar
  Widget _buildCommentCard(String comment) {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: SelectableText( 
        comment,
        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
      ),
    );
  }

  // Widget untuk Analisis dan Metadata
  Widget _buildAnalysisSection(ReviewItem item) {
    return Column(
      children: [
        _buildAnalysisTile(
          icon: Icons.label_important_rounded,
          title: 'Kategori',
          value: item.category,
          color: const Color(0xFF00B0FF),
        ),
        _buildAnalysisTile(
          icon: Icons.text_fields_rounded,
          title: 'Jumlah Kata',
          value: item.comment.split(' ').length.toString(),
          color: Colors.orange,
        ),
        _buildAnalysisTile(
          icon: Icons.sentiment_satisfied_alt_rounded,
          title: 'Sentimen Utama',
          value: item.rating >= 4 ? 'Puas' : 'Perlu Peningkatan',
          color: item.rating >= 4 ? Colors.lightGreen : Colors.red,
        ),
      ],
    );
  }

  // Helper Widget untuk setiap baris analisis
  Widget _buildAnalysisTile({required IconData icon, required String title, required String value, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(50), 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}