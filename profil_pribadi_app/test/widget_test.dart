import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Untuk menjalankan kode ini, tambahkan package flutter_animate ke pubspec.yaml Anda:
// dependencies:
//   flutter:
//     sdk: flutter
//   flutter_animate: ^4.5.0  // Gunakan versi terbaru

void main() {
  runApp(const WidgetDasarApp());
}

class WidgetDasarApp extends StatelessWidget {
  const WidgetDasarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        // Skema warna yang lebih elegan dan profesional
        primaryColor: const Color(0xFF0D47A1), // Biru Gelap
        scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Latar belakang abu-abu sangat muda
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(
          primary: const Color(0xFF0D47A1), // Biru Gelap
          secondary: const Color(0xFF00ACC1), // Aksen Teal/Cyan
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// --- HALAMAN UTAMA (HOMEPAGE) ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withAlpha(229),
              Theme.of(context).colorScheme.secondary.withAlpha(204),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero Animation untuk transisi foto profil
              Hero(
                tag: 'profile-picture',
                child: CircleAvatar(
                  radius: 85,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      // Ganti dengan URL foto Anda
                      'assets/images/foto.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 900.ms).scale(begin: const Offset(0.5, 0.5)),
              const SizedBox(height: 25),
              const Text(
                'Noviana Safitri',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 900.ms),
              const Text(
                'NIM: 701230017',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 900.ms),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BiodataScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                label: const Text('Lihat Biodata Lengkap'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                ),
              ).animate().slideY(begin: 1, delay: 700.ms, duration: 600.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HALAMAN BIODATA ---
class BiodataScreen extends StatefulWidget {
  const BiodataScreen({super.key});

  @override
  State<BiodataScreen> createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  // Widget pembantu untuk baris info yang berulang
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk membuat bagian (section) yang bisa di-expand/collapse
  Widget _buildSection(String title, List<Widget> children, {bool initiallyExpanded = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Efek hover dan animasi
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          iconColor: Theme.of(context).primaryColor,
          collapsedIconColor: Theme.of(context).primaryColor,
          children: children,
        ),
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- APPBAR / HEADER ---
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Noviana Safitri', style: TextStyle(fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    // Ganti dengan URL foto Anda
                    'assets/images/foto.jpg',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay untuk kontras teks
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(158),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- KONTEN BIODATA ---
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                _buildSection('Tentang Saya', [
                  const Text(
                    'Saya adalah seorang mahasiswa di UIN Sulthan Thaha Saifuddin Jambi, Fakultas Sains dan Teknologi. Selama masa studi, saya telah banyak mendalami dunia pemrograman, yang memicu minat dan semangat saya dalam menciptakan solusi digital yang fungsional dan inovatif. Saya berkomitmen untuk terus berkembang sebagai pengembang, menciptakan kode yang bersih, efisien, dan memberikan dampak positif.',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ], initiallyExpanded: true),

                _buildSection('Riwayat Pendidikan', [
                  const Text(
                    '• SMK Negeri 4 Sarolangun\n  Jurusan Administrasi Perkantoran (2020 - 2022)\n  (Fokus pada bidang surat menyurat dan komputer)',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),
                ]),

                _buildSection('Keahlian Teknis', [
                  const Text(
                    '• Menguasai Microsoft Office\n• Kontrol Versi: Git, GitHub',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),
                ]),

                _buildSection('Kontak & Detail Pribadi', [
                  _buildInfoRow(Icons.cake_outlined, 'Tanggal Lahir', '13 November 2004'),
                  _buildInfoRow(Icons.location_on_outlined, 'Lokasi', 'Sarolangun Jambi, Indonesia'),
                  _buildInfoRow(Icons.email_outlined, 'Email', 'novianasafitri0102@gmail.com'),
                  _buildInfoRow(Icons.message_outlined, 'WhatsApp', '+62 813-6634-4621'),
                  _buildInfoRow(Icons.camera_alt_outlined, 'Instagram', '@nvianasftri'),
                  _buildInfoRow(Icons.link_outlined, 'GitHub', 'github.com/NovianaSafitri'),
                ]),

                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Text(
                    '© 2025 Noviana Safitri. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
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