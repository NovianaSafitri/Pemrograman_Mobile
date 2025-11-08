// file: lib/home_page.dart (KODE FINAL DAN BEBAS ERROR)
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'model_data.dart'; 
import 'feedback_form_page.dart'; 
import 'detail_page.dart';        

// Data Dummy Final (Sama)
final dummyData = FeedbackData(); // Menggunakan konstruktor kosong

class HomePage extends StatelessWidget {
  final FeedbackData data;
  
  const HomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Feedback'),
        actions: const [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications_none), onPressed: null),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- RINGKASAN DATA ---
              Row(
                children: [
                  Expanded(child: _buildGradientSummaryCard(
                    title: 'Total Ulasan',
                    value: data.totalReviews.toString(), 
                    icon: Icons.people_alt_rounded,
                    gradient: const [Color(0xFF673AB7), Color(0xFF9C27B0)],
                  )),
                  const SizedBox(width: 15),
                  Expanded(child: _buildGradientSummaryCard(
                    title: 'Rating Rata-rata',
                    value: data.averageRating.toStringAsFixed(1), 
                    icon: Icons.star_rate_rounded,
                    gradient: const [Color(0xFFFBC02D), Color(0xFFFFEB3B)], 
                  )),
                  const SizedBox(width: 15),
                  Expanded(child: _buildGradientSummaryCard(
                    title: 'Top Score',
                    value: '5.0', 
                    icon: Icons.emoji_events_rounded,
                    gradient: const [Color(0xFFE91E63), Color(0xFFFF4081)],
                  )),
                ],
              ),

              const SizedBox(height: 30),

              // --- RIWAYAT TERBARU ---
              const Text(
                'Riwayat Feedback Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildRecentReviews(data), // Memanggil data untuk rebuild

              const SizedBox(height: 30),

              // --- IKHTISAR RATING ---
              const Text(
                'Ikhtisar Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildRatingDistribution(data), // Memanggil data untuk rebuild
            ],
          ),
        ),
      ),
      
      // Tombol Tambah Feedback (FAB)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/feedbackForm');
        },
        label: const Text('Tambah Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
    );
  }

  // --- SEMUA WIDGET PEMBANTU DIBAWAH INI HARUS ADA DI SINI ---

  Widget _buildGradientSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withAlpha(100),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(FeedbackData data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          for (int i = 5; i >= 1; i--) 
            _buildRatingBar(
              starCount: i, 
              count: data.ratingCounts[i]!, 
              total: data.totalReviews
            ),
        ],
      ),
    );
  }

  Widget _buildRatingBar({required int starCount, required int count, required int total}) {
    double percentage = total > 0 ? (count / total) : 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$starCount \u{2605}', 
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor: Colors.grey.shade800,
                color: starCount >= 4 ? Colors.lightGreen : (starCount >= 3 ? Colors.amber : Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$count (${(percentage * 100).toStringAsFixed(0)}%)',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReviews(FeedbackData data) {
    return data.totalReviews == 0 
      ? const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Text(
              'Belum ada feedback. Kirimkan feedback pertama Anda!',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        )
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var review in data.recentReviews)
            _buildReviewCard(review),
        ],
      );
  }

  Widget _buildReviewCard(ReviewItem review) {
    String initial = review.reviewerName.isNotEmpty ? review.reviewerName[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero( // Tambahkan Hero untuk transisi ke DetailPage
                tag: 'avatar-${review.reviewerName}',
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF9C27B0),
                  child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'Kategori: ${review.category}',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row( // Widget Bintang Bawaan
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < review.rating.round() ? Icons.star_rate_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFFBC02D), 
                        size: 15.0,
                      );
                    }),
                  ),
                  Text(review.timeAgo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Divider(height: 20, color: Colors.white10),
          Text(
            review.comment,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}