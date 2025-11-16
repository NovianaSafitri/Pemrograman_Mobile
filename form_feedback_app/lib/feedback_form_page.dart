// file: lib/feedback_form_page.dart (KODE FINAL DAN BERSIH)

import 'package:flutter/material.dart';
import 'model_data.dart'; // Catatan: Mengasumsikan Anda sudah mengganti nama dari model_data.dart ke data_model.dart

class FeedbackFormPage extends StatefulWidget {
  final Function(ReviewItem) onFeedbackSubmitted; 
  final double initialRating;

  const FeedbackFormPage({
    super.key, 
    required this.onFeedbackSubmitted, 
    this.initialRating = 3.0,
  });

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  
  double _currentRating = 3.0;
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  final List<String> _categories = ['Layanan', 'Aplikasi', 'Produk', 'Website', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      
      // 1. Buat ReviewItem baru
      final newReview = ReviewItem(
        reviewerName: _nameController.text.trim().isEmpty ? 'Anonim' : _nameController.text,
        category: _selectedCategory!,
        comment: _commentController.text,
        rating: _currentRating,
      );
      
      // 2. Kirim data ke HomePage melalui callback
      widget.onFeedbackSubmitted(newReview); 
      
      // Safety check sebelum dialog
      if (!mounted) return;

      // Tampilkan dialog sukses (KODE YANG DIPERBAIKI)
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog( // Hapus const di sini untuk menghindari error sintaksis
          backgroundColor: const Color(0xFF303030),
          title: const Text('🎉 Berhasil Dikirim!', style: TextStyle(color: Colors.white)),
          content: const Text('Data Anda sekarang terlihat di dashboard.', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () { // <-- onPRESSED FUNGSIK LENGKAP DAN BENAR
                // 1. Tutup dialog
                Navigator.of(ctx).pop(); 
                // 2. Kembali ke dashboard
                Navigator.of(context).pop(); 
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFFE91E63))),
            ),
          ],
        ),
      ); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)], 
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Pastikan SliverAppBar TIDAK memiliki const jika leading-nya memiliki onPressed
            SliverAppBar( 
              title: const Text('Kirimkan Feedback Anda', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent, 
              elevation: 0,
              // BackButton sudah benar dan fungsional
              leading: BackButton(onPressed: () => Navigator.pop(context), color: Colors.white), 
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bagaimana pengalaman Anda?',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nama Anda',
                        icon: Icons.person_rounded,
                        validator: (v) => v!.isEmpty ? 'Nama wajib diisi.' : null,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email (Opsional)',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      _buildDropdownCategory(),
                      const SizedBox(height: 30),
                      _buildRatingSliderCard(),
                      const SizedBox(height: 30),
                      _buildCommentField(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, String? Function(String?)? validator, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFF383838), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2), 
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFE91E63)),
      ),
    );
  }

  Widget _buildDropdownCategory() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Pilih Kategori',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF383838),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
        ),
        prefixIcon: const Icon(Icons.category_rounded, color: Color(0xFF9C27B0)),
      ),
      initialValue: _selectedCategory, 
      dropdownColor: const Color(0xFF303030),
      style: const TextStyle(color: Colors.white),
      items: _categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (v) => v == null ? 'Pilih kategori.' : null,
    );
  }

  Widget _buildRatingSliderCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF383838),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text( 
            'Rating Anda: ${_currentRating.toStringAsFixed(1)} \u{2605}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Slider(
            value: _currentRating,
            min: 1.0,
            max: 5.0,
            divisions: 8, 
            activeColor: const Color(0xFFE91E63), 
            inactiveColor: const Color(0xFF9C27B0).withAlpha((255 * 0.5).round()), 
            onChanged: (double value) {
              setState(() {
                _currentRating = value;
              });
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1.0', style: TextStyle(color: Color(0xFFE57373))), 
              Text('5.0', style: TextStyle(color: Color(0xFF66BB6A))), 
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCommentField() {
    return TextFormField(
      controller: _commentController,
      maxLines: 5,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Komentar Detail',
        hintText: 'Tuliskan ulasan Anda di sini...',
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFF383838),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
        prefixIcon: const Icon(Icons.edit_note_rounded, color: Color(0xFFE91E63)),
      ),
      validator: (v) => v!.isEmpty ? 'Komentar tidak boleh kosong.' : null,
    );
  }

  Widget _buildSubmitButton() {
    return InkWell(
      onTap: _submitFeedback,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFFE91E63)], 
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E63).withAlpha((255 * 0.4).round()), 
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, size: 24, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Kirim Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}