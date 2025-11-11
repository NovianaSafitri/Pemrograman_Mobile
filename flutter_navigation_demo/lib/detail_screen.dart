import 'package:flutter/material.dart';

// Helper Widget: Latar Belakang Gradien Biru Laut (Harus ada di setiap file)
Widget _buildGradientBackground({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4FC3F7), // Light Sky Blue
          Color(0xFF0D47A1), // Deep Ocean Blue
        ],
      ),
    ),
    child: child,
  );
}

class DetailScreen extends StatelessWidget {
  final String data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        title: const Text('Detail Informasi 📄'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white, 
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.info_outline, size: 28, color: Colors.white),
          ),
        ],
      ),
      body: _buildGradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Informasi yang Anda Cari:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Animasi: Kartu Berubah Warna Halus (Pulsating Card)
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: Colors.white,
                    end: Colors.yellow.shade100, // Aksen Kuning Pucat
                  ),
                  duration: const Duration(seconds: 4),
                  curve: Curves.easeInOut,
                  // Menggunakan repeat: true untuk membuatnya berulang
                  builder: (context, color, child) {
                    return Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: color!.withAlpha(0xE6), // Warna kartu yang beranimasi
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                            const SizedBox(height: 15),
                            const Text(
                              'Data Berhasil Diterima:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data, // Data yang dikirim dari halaman sebelumnya
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // Tombol Pop (Kembali)
                    Navigator.pop(context); 
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Kembali ke Menu Utama'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary, // Warna Biru Aksen
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}