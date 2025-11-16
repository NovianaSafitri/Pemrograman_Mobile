// file: lib/data_model.dart


// Class untuk satu item review
class ReviewItem {
  final String reviewerName;
  final String category;
  final String comment;
  final double rating;
  final String timeAgo; 

  ReviewItem({
    required this.reviewerName,
    required this.category,
    required this.comment,
    required this.rating,
    this.timeAgo = 'Baru saja', // Default waktu
  });
}

// Class untuk seluruh data dashboard (LIVE DATA)
class FeedbackData {
  List<ReviewItem> recentReviews = [];

  // Peta untuk menyimpan jumlah rating: {1: count, 2: count, ..., 5: count}
  Map<int, int> ratingCounts = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  };

  int get totalReviews => recentReviews.length;
  
  double get averageRating {
    if (totalReviews == 0) return 0.0;
    double sum = 0;
    for (var review in recentReviews) {
      sum += review.rating; // Menggunakan rating desimal untuk akurasi
    }
    return sum / totalReviews;
  }

  // --- Fungsi untuk menambahkan review (MUTATOR) ---
  void addReview(ReviewItem review) {
    recentReviews.insert(0, review); // Tambahkan ke depan
    int starRating = review.rating.round();
    if (starRating >= 1 && starRating <= 5) {
      ratingCounts[starRating] = ratingCounts[starRating]! + 1;
    }
  }

  // Konstruktor untuk data kosong (Permintaan: hapus riwayat)
  FeedbackData() {
    ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  }
}