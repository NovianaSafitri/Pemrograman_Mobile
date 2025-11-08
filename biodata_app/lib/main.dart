import 'package:flutter/material.dart';

void main() {
  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Aplikasi Biodata', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueGrey[800],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian Header dengan Foto Profil, Nama, dan Pekerjaan
              Container(
                color: Colors.blueGrey[900],
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: Column(
                  children: [
                    // =======================================================
                    // FOTO PROFIL ANDA DI SINI (SUDAH DIPERBAIKI)
                    // =======================================================
                    ClipOval( // Memotong gambar menjadi lingkaran
                      child: Image.asset( // Mendukung width, height, fit, dan errorBuilder
                        'assets/novi.jpg',
                        width: 160, // Ukuran lingkaran (radius 80 * 2)
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback jika gambar tidak ditemukan atau gagal dimuat
                          return const SizedBox(
                            width: 160,
                            height: 160,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey,
                              ),
                              child: Icon(Icons.person, size: 80, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    // =======================================================

                    const SizedBox(height: 20),
                    const Text(
                      'Noviana Safitri',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sistem Informasi',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mahasiswa UIN Sulthan Thaha Saifuddin Jambi',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              // Bagian Tentang Saya
              Container(
                color: Colors.blueGrey[800],
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang Saya',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Divider(color: Colors.blueGrey, thickness: 1, height: 20),
                    Text(
                      'Saya adalah seorang mahasiswa di UIN Sulthan Thaha Saifuddin Jambi, Fakultas Sains dan Teknologi. Selama masa studi, saya telah banyak mendalami dunia pemrograman, yang memicu minat dan semangat saya dalam menciptakan solusi digital yang fungsional dan inovatif. Saya berkomitmen untuk terus berkembang sebagai pengembang, menciptakan kode yang bersih, efisien, dan memberikan dampak positif.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              // Riwayat Pendidikan
              Container(
                color: Colors.blueGrey[700],
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Pendidikan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Divider(color: Colors.blueGrey, thickness: 1, height: 20),
                    Text(
                      '• SMK Negeri 4 Sarolangun\n  Jurusan Administrasi Perkantoran (2020 - 2022)\n  (Fokus pada bidang surat menyurat dan komputer)',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Keahlian Teknis
              Container(
                color: Colors.blueGrey[800],
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keahlian Teknis',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Divider(color: Colors.blueGrey, thickness: 1, height: 20),
                    Text(
                      '• Menguasai Microsoft Office \n• Kontrol Versi: Git, GitHub',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Informasi Kontak & Detail Pribadi
              Container(
                color: Colors.blueGrey[700],
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kontak & Detail Pribadi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Divider(color: Colors.blueGrey, thickness: 1, height: 20),
                    _buildInfoRow(Icons.cake, 'Tanggal Lahir', '13 November 2004'),
                    _buildInfoRow(Icons.location_on, 'Lokasi', 'Sarolangun Jambi, Indonesia'),
                    const SizedBox(height: 15),
                    _buildInfoRow(Icons.email, 'Email', 'novianasafitri0102@gmail.com'),
                    _buildInfoRow(Icons.message, 'WhatsApp', '+62 813-6634-4621'),
                    _buildInfoRow(Icons.camera_alt, 'Instagram', 'nvianasftri'),
                    _buildInfoRow(Icons.link, 'GitHub', 'https://github.com/NovianaSafitri/Pemprograman-Web-2'),
                  ],
                ),
              ),
              // Footer
              Container(
                color: Colors.blueGrey[900],
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '© 2025 Noviana Safitri. All rights reserved.',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk baris info yang berulang
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}