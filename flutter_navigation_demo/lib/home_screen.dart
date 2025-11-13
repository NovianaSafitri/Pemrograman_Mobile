import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'bottom_nav_screen.dart';

// =========================================================================
// WIDGET HELPER GLOBAL
// =========================================================================

// 1. Helper: Latar Belakang Gradien Biru Laut (Diperlukan di banyak file)
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

// 2. Helper: Fungsi Renderer Kartu Interaktif
Widget _interactiveCardRenderer({
  required BuildContext context,
  required String number,
  required String title,
  required String subtitle,
  required IconData icon,
  required MaterialColor baseColor, 
  required Function(BuildContext) onTap, 
}) {
  const Color lightColor = Colors.white; 
  final Color solidColor = baseColor.shade800; 

  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Card(
      elevation: 8, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: lightColor.withAlpha(0xE6), // 90% opacity
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        onTap: () => onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36, color: solidColor), 
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number. $title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: solidColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: solidColor.withAlpha(0xCC),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: solidColor.withAlpha(0x99), size: 18), 
            ],
          ),
        ),
      ),
    ),
  );
}

// =========================================================================
// WIDGET UTAMA (HOME SCREEN)
// =========================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Definisikan semua fungsi navigasi sebagai static method
  static void _onPushSederhana(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const DetailScreen(data: 'Navigasi Sederhana berhasil!')));
  }
  static void _onPushData(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const DetailScreen(data: 'Data Penting: Kiriman Khusus dari Home!')));
  }
  static void _onBottomNav(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const BottomNavScreen()));
  }
  static void _onNamedData(BuildContext context) {
    Navigator.pushNamed(context, '/named_data', arguments: 'Data ini dikirim via Named Route yang kompleks!');
  }
  static void _onPushReplacement(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/replacement');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar( 
        title: const Text('5 Metode Navigasi Ocean Demo 💎'),
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
      body: _buildGradientBackground( 
        child: const SingleChildScrollView( 
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[ 
               Text(
                'Pilih Metode Navigasi:',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white, 
                ),
              ),
               SizedBox(height: 10),
               Text(
                'Eksplorasi 5 teknik utama navigasi Flutter.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
               SizedBox(height: 30),

              // FIX: Hapus SEMUA 'const' dari pemanggilan _InteractiveCardWrapper (SOLUSI)
              _InteractiveCardWrapper( 
                number: '1', title: 'Push Sederhana (MaterialPageRoute)',
                subtitle: 'Menambah halaman baru di atas tumpukan.',
                icon: Icons.flight_takeoff, baseColor: Colors.cyan,
                onTap: _onPushSederhana,
              ),
              _InteractiveCardWrapper(
                number: '2', title: 'Push dengan Data (Constructor)',
                subtitle: 'Mengirim String atau Object via Constructor.',
                icon: Icons.dns, baseColor: Colors.green,
                onTap: _onPushData,
              ),
              _InteractiveCardWrapper(
                number: '3', title: 'Bottom Navigation Bar',
                subtitle: 'Antarmuka navigasi multi-tab yang intuitif.',
                icon: Icons.view_carousel, baseColor: Colors.purple,
                onTap: _onBottomNav,
              ),
              _InteractiveCardWrapper(
                number: '4', title: 'Named Route dengan Data (onGenerateRoute)',
                subtitle: 'Navigasi dengan nama rute dan kirim Argumen.',
                icon: Icons.alt_route, baseColor: Colors.orange,
                onTap: _onNamedData,
              ),
              _InteractiveCardWrapper(
                number: '5', title: 'Push Replacement (Ganti Halaman)',
                subtitle: 'Mengganti halaman ini dengan yang baru di tumpukan.',
                icon: Icons.repeat_one, baseColor: Colors.red,
                onTap: _onPushReplacement,
              ),
              
               SizedBox(height: 40),

               _ExplanationCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET HELPER WRAPPER (Dipertahankan const)
// =========================================================================
class _InteractiveCardWrapper extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final MaterialColor baseColor;
  final Function(BuildContext) onTap;

  const _InteractiveCardWrapper({
  
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.baseColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Memanggil fungsi renderer global
    return _interactiveCardRenderer(
      context: context,
      number: number,
      title: title,
      subtitle: subtitle,
      icon: icon,
      baseColor: baseColor,
      onTap: onTap,
    );
  }
}

// =========================================================================
// WIDGET HELPER PENJELASAN
// =========================================================================
class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard(); 

  Widget _buildExplanationItem(String term, String description, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75,
            child: Text(
              term,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: accentColor,
              ),
            ),
          ),
          Expanded(
            child:  Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.black.withAlpha(0x33), 
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [ 
                Icon(Icons.lightbulb, size: 28, color: Colors.amberAccent),
                SizedBox(width: 10),
                Expanded( 
                  child: Text(
                    'KONSEP 5 METODE NAVIGASI',
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.white, 
                    ),
                  ),
                ),
              ],
            ),
            
            const Divider(height: 25, thickness: 1.5, color: Colors.white54),
            
            _buildExplanationItem('1. Push:', 'Menambah halaman baru di atas tumpukan.', Colors.cyan.shade300),
            const SizedBox(height: 10),
            _buildExplanationItem('2. Pop:', 'Menghapus halaman teratas (kembali ke halaman sebelumnya).', Colors.green.shade300),
            const SizedBox(height: 10),
            _buildExplanationItem('3. Named:', 'Navigasi ke rute yang sudah didefinisikan (tanpa MaterialPageRoute).', Colors.orange.shade300),
            const SizedBox(height: 10),
            _buildExplanationItem('4. Replace:', 'Mengganti halaman saat ini dari tumpukan.', Colors.red.shade300),
            const SizedBox(height: 10),
            _buildExplanationItem('5. Bottom Nav:', 'Manajemen tab multi-halaman dalam satu layar.', Colors.purple.shade300), 
          ],
        ),
      ),
    );
  }
}