import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

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
        primaryColor: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFFE0E5EC),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          primary: const Color(0xFF1E88E5),
          secondary: const Color(0xFF00BFA5),
          tertiary: const Color(0xFF673AB7),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(0x4),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'profile-picture',
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(0x8),
                        offset: const Offset(-10, -10),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black.withAlpha(0x15),
                        offset: const Offset(10, 10),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/foto.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
                  ),
                ).animate().fadeIn(duration: 900.ms).scale(begin: const Offset(0.7, 0.7)),
              ),
              const SizedBox(height: 35),
              Text(
                'Noviana Safitri',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 900.ms).slideY(begin: 0.2),
              const Text(
                'NIM: 701230017',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 900.ms),
              const SizedBox(height: 50),
              _NeumorphicButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BiodataScreen()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Biodata Lengkap',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_right_alt, size: 24, color: Theme.of(context).colorScheme.secondary),
                  ],
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
  // Widget untuk menampilkan baris informasi
  Widget _buildInfoItem(
      {required IconData icon,
        required String label,
        required String value,
        String? url}) {
    final Widget content = Row(
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
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              SelectableText(
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
    );

    if (url != null) {
      return InkWell(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tidak dapat membuka $label')),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: content,
    );
  }

  // Widget pembantu untuk membuat bagian (section)
  Widget _buildSection({
    required String title,
    required Widget content,
    bool initiallyExpanded = false,
    double delayMs = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: _NeumorphicContainer(
        borderRadius: 20,
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          iconColor: Theme.of(context).colorScheme.secondary,
          collapsedIconColor: Theme.of(context).colorScheme.secondary,
          children: [content],
        ),
      ).animate().fadeIn(duration: 600.ms, delay: delayMs.ms).slideX(begin: -0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Colors.black87,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: const Text(
                'Noviana Safitri',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/foto.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(0x7),
                        ],
                        stops: const [0.5, 1.0],
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
                _buildSection(
                  title: 'Tentang Saya',
                  content: const Text(
                    'Saya seorang mahasiswa di UIN Sulthan Thaha Saifuddin Jambi, Fakultas Sains dan Teknologi. Selama masa studi, saya telah belajar banyak tentang pemrograman.',
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.3),
                    textAlign: TextAlign.justify,
                  ),
                  initiallyExpanded: true,
                  delayMs: 100,
                ),

                _buildSection(
                  title: 'Riwayat Pendidikan',
                  content: const Text(
                    '• SMK Negeri 4 Sarolangun\n  Jurusan Administrasi Perkantoran (2020 - 2022)\n• (Fokus pada bidang surat menyurat dan komputer)',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),
                  delayMs: 200,
                ),

                _buildSection(
                  title: 'Keahlian Teknis',
                  content: const Text(
                    '• Menguasai Microsoft Office\n• Kontrol Versi: Git, GitHub',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),
                  delayMs: 300,
                ),

                _buildSection(
                  title: 'Kontak & Detail Pribadi',
                  content: Column(
                    children: [
                      _buildInfoItem(
                          icon: Icons.cake_outlined,
                          label: 'Tanggal Lahir',
                          value: '13 November 2004'),
                      _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          label: 'Lokasi',
                          value: 'Sarolangun Jambi, Indonesia'),
                      _buildInfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: 'novianasafitri0102@gmail.com',
                          url: 'mailto:novianasafitri0102@gmail.com'),
                      _buildInfoItem(
                          icon: Icons.message_outlined,
                          label: 'WhatsApp',
                          value: '+62 813-6634-4621',
                          url: 'https://wa.me/6281366344621'),
                      _buildInfoItem(
                          icon: Icons.camera_alt_outlined,
                          label: 'Instagram',
                          value: '@nvianasftri',
                          url: 'https://www.instagram.com/nvianasftri/'),
                      _buildInfoItem(
                          icon: Icons.link_outlined,
                          label: 'GitHub',
                          value: 'github.com/NovianaSafitri',
                          url: 'https://github.com/NovianaSafitri'),
                    ],
                  ),
                  delayMs: 400,
                ),

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

// --- Neumorphism Widgets ---
class _NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isPressed;

  const _NeumorphicContainer({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
          BoxShadow(
            color: Colors.white.withAlpha(0x5),
            offset: const Offset(2, 2),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(0x08),
            offset: const Offset(-2, -2),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ]
            : [
          BoxShadow(
            color: Colors.white.withAlpha(0x8),
            offset: const Offset(-8, -8),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(0x15),
            offset: const Offset(8, 8),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _NeumorphicButton({
    required this.child,
    required this.onPressed,
  });

  @override
  State<_NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<_NeumorphicButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: _NeumorphicContainer(
        isPressed: _isPressed,
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: widget.child,
      ),
    );
  }
}