// lib/screens/main_screen.dart (KODE FINAL, 5 Tab, Gradien Stabil, BEBAS WARNINGS)

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import '../model/activity_model.dart';
import 'add_activity_page.dart';
import 'activity_detail_page.dart';

// --------------------------------------------------------------------
// HELPER FUNCTIONS (GLOBAL - MURNI LOGIC ATAU WIDGET KUSTOM)
// --------------------------------------------------------------------

IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'Belajar': return Icons.menu_book_rounded;
    case 'Ibadah': return Icons.self_improvement_rounded;
    case 'Olahraga': return Icons.directions_run_rounded;
    case 'Hiburan': return Icons.palette_rounded;
    default: return Icons.folder_open_rounded;
  }
}
Color _getCategoryColor(String category) {
  switch (category) {
    case 'Belajar': return Colors.cyanAccent.shade400; // Warna kontras terang
    case 'Ibadah': return Colors.pinkAccent.shade100;
    case 'Olahraga': return Colors.lightGreenAccent.shade400;
    case 'Hiburan': return Colors.yellowAccent.shade700;
    default: return Colors.white54;
  }
}

// WIDGET KUSTOM: GRADIENT BACKGROUND
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5A4FCF), Color(0xFF9F28D5)], // Ungu ke Ungu Magenta
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

// --------------------------------------------------------------------
// KELAS UTAMA: MainScreen (StatefulWidget)
// --------------------------------------------------------------------

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  final List<ActivityModel> _activities = [
    ActivityModel(name: 'Review Tugas Mobile', category: 'Belajar', duration: 3.0, isCompleted: false),
    ActivityModel(name: 'Push Up & Sit Up', category: 'Olahraga', duration: 0.5, isCompleted: true),
    ActivityModel(name: 'Sholat Maghrib', category: 'Ibadah', duration: 0.2, isCompleted: true),
    ActivityModel(name: 'Nonton Tutorial Flutter', category: 'Belajar', duration: 1.5, isCompleted: false),
    ActivityModel(name: 'Baca Buku Novel', category: 'Hiburan', duration: 1.0, isCompleted: false),
    ActivityModel(name: 'Belajar Desain UI/UX', category: 'Belajar', duration: 2.0, isCompleted: true),
  ];

  final List<String> _pageTitles = const [
    'Dashboard', 'Statistik Aktivitas', 'Tugas Pending', 'Kalender Kegiatan', 'Profil', 
  ];

  // --- STATE MANAGEMENT & NAVIGASI ---

  void _navigateToAddActivity() async {
    final newActivity = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddActivityPage()));
    if (newActivity != null && newActivity is ActivityModel) {
      setState(() { _activities.add(newActivity); });
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Aktivitas "${newActivity.name}" berhasil ditambahkan!'), backgroundColor: Colors.green.shade600)); }
    }
  }

  void _toggleCompletion(ActivityModel activity) {
    setState(() { activity.isCompleted = !activity.isCompleted; });
  }

  void _deleteActivity(ActivityModel activity) {
    setState(() { _activities.remove(activity); });
  }

  // --- LOGIC & HELPER FUNCTIONS (Internal to State - TANPA PARAMETER) ---
  
  double _calculateTotalHours() {
    return _activities.fold(0.0, (sum, activity) => sum + activity.duration);
  }
  int _calculateCompletedCount() {
    return _activities.where((a) => a.isCompleted).length;
  }
  Map<String, int> _calculateCategoryDistribution() {
    Map<String, int> distribution = {};
    for (var activity in _activities) {
      distribution[activity.category] = (distribution[activity.category] ?? 0) + 1;
    }
    return distribution;
  }

  // --- WIDGET HELPER DALAM KELAS STATE ---

  

  Widget _buildActivityPieChart() {
    final categoryDistribution = _calculateCategoryDistribution(); // Panggilan tanpa parameter
    final totalActivities = _activities.length;
    
    if (categoryDistribution.isEmpty || totalActivities == 0) {
      return Container(
        height: 150, alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(18)),
        child: const Text('Tidak ada data aktivitas.', style: TextStyle(color: Colors.white70)),
      );
    }

    final Map<String, Color> colorMap = {
      'Belajar': Colors.teal.shade300, 'Olahraga': Colors.orange.shade300,
      'Ibadah': Colors.deepPurple.shade300, 'Hiburan': Colors.yellow.shade400,
      'Lainnya': Colors.grey.shade400,
    };
    
    final List<PieChartSectionData> sections = [];
    categoryDistribution.forEach((category, count) {
      final Color color = colorMap[category] ?? Colors.grey;
      final double value = count.toDouble();
      sections.add(PieChartSectionData(color: color, value: value, title: '', radius: 50));
    });

    return Card(
      elevation: 6, color: Colors.white12, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130, height: 130,
              child: PieChart(
                PieChartData(borderData: FlBorderData(show: false), sectionsSpace: 2, centerSpaceRadius: 40, sections: sections),
              ),
            ),
            const SizedBox(width: 30), // FIX: Jarak antar Pie Chart dan Legenda
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: categoryDistribution.entries.map((entry) {
                  final color = colorMap[entry.key] ?? Colors.grey;
                  final percentage = (entry.value / totalActivities) * 100;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 10, color: color), 
                        const SizedBox(width: 8), 
                        Text('${entry.key} (${percentage.toStringAsFixed(0)}%)', style: const TextStyle(color: Colors.white, fontSize: 14)), 
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // --- 1. Tab Home / Dashboard Aktivitas ---
  Widget _buildHomeTab(BuildContext context, ColorScheme colorScheme) {
    return GradientBackground(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 100.0, bottom: 80), 
        itemCount: _activities.length + 1, 
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded( 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Halo, Noviana', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Semangat, produktif hari ini!', style: const TextStyle(fontSize: 16, color: Colors.white70)),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), 
                  CircleAvatar(
                    radius: 35, backgroundColor: Colors.white70,
                    child: ClipOval(child: Image.asset('assets/images/novi.jpg', width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {return const Icon(Icons.person, size: 45, color: Colors.black54);},)),
                  ),
                ],
              ),
            );
          }
          
          final activity = _activities[index - 1]; 
          final bool isCompleted = activity.isCompleted;
          final Color primaryColor = _getCategoryColor(activity.category);
          final double cardElevation = isCompleted ? 2.0 : 6.0;
          final Color borderColor = isCompleted ? Colors.transparent : primaryColor.withAlpha(0x5);
          final Color cardBgColor = isCompleted ? Colors.white12 : Colors.white24;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetailPage(activity: activity, onDelete: _deleteActivity, onToggleCompletion: _toggleCompletion)));
              },
              child: Card( 
                elevation: cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: borderColor, width: 1.5),
                ),
                color: cardBgColor, 
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300), 
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: isCompleted ? null : LinearGradient(
                        colors: [Colors.white.withAlpha(0x1), primaryColor.withAlpha(0x05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(backgroundColor: primaryColor, child: Icon(_getCategoryIcon(activity.category), color: Colors.white, size: 24)),
                    title: Text(activity.name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, decoration: isCompleted ? TextDecoration.lineThrough : null, color: Colors.white)),
                    subtitle: Text('${activity.category} • ${activity.duration.toStringAsFixed(1)} jam', style: TextStyle(fontWeight: FontWeight.w600, color: isCompleted ? Colors.lightGreenAccent : primaryColor)),
                    trailing: Container( 
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: isCompleted ? primaryColor : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: primaryColor.withAlpha(0x5), width: 2)),
                      child: Icon(isCompleted ? Icons.check : Icons.access_time, color: isCompleted ? Colors.white : primaryColor, size: 20),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetailPage(activity: activity, onDelete: _deleteActivity, onToggleCompletion: _toggleCompletion)));
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 2. Tab Statistik Aktivitas (FIXED)
  Widget _buildStatsTab(BuildContext context, ColorScheme colorScheme) {
    if (_activities.isEmpty) { 
      return const GradientBackground(
        child: Center(
          child: Text(
            'Tambah aktivitas untuk melihat statistik.', 
            // FIX ERROR L302: Menggunakan TextStyle tanpa const
            style: TextStyle(color: Colors.white) 
          )
        )
      ); 
    }
    final totalHours = _calculateTotalHours(); 
    final completedCount = _calculateCompletedCount(); 
    final totalActivities = _activities.length;
    final completionPercentage = totalActivities > 0 ? (completedCount / totalActivities) : 0.0;
    
    Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
      return Card(elevation: 6, color: Colors.white12, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))), child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withAlpha(0x2), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 20, color: color)), const SizedBox(height: 8), Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)), Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70), overflow: TextOverflow.ellipsis)], ), ), );
    }

    

    return GradientBackground(
      child: SingleChildScrollView(
        key: const PageStorageKey('statsTabScroll'),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            GridView.count(
              crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.05, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(title: 'Total Jam', value: totalHours.toStringAsFixed(1), icon: Icons.access_time_filled, color: Colors.cyanAccent.shade400),
                _buildStatCard(title: 'Aktivitas Selesai', value: completedCount.toString(), icon: Icons.check_circle_rounded, color: Colors.lightGreenAccent.shade400),
                _buildStatCard(title: 'Total Tugas', value: totalActivities.toString(), icon: Icons.playlist_add_check_rounded, color: Colors.orangeAccent),
                _buildStatCard(title: 'Persentase Sel.', value: '${(completionPercentage * 100).toStringAsFixed(0)}%', icon: Icons.percent_rounded, color: Colors.pinkAccent.shade100),
              ],
            ),
            const SizedBox(height: 35),
            Text('Jam Mingguan', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const Divider(thickness: 2, color: Colors.white38, height: 30),
            
            _buildActivityPieChart(), 
            
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }

  // 3. Tab Tugas Pending
  Widget _buildUpcomingTab(BuildContext context, ColorScheme colorScheme) {
    final pendingActivities = _activities.where((a) => !a.isCompleted).toList();
    
    return GradientBackground(
      child: ListView.builder(
        key: const PageStorageKey('upcomingTabScroll'),
        padding: const EdgeInsets.only(top: 80, bottom: 80),
        itemCount: pendingActivities.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text('Tugas Pending', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            );
          }
          final activity = pendingActivities[index - 1];
          final categoryColor = _getCategoryColor(activity.category);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Card(
              elevation: 4,
              color: Colors.white12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(_getCategoryIcon(activity.category), color: categoryColor, size: 28),
                title: Text(activity.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                subtitle: Text('${activity.category} • Target: ${activity.duration.toStringAsFixed(1)} jam', style: const TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white54),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ActivityDetailPage(activity: activity, onDelete: _deleteActivity, onToggleCompletion: _toggleCompletion)));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. Tab Kalender Kegiatan
  Widget _buildCalendarTab(BuildContext context, ColorScheme colorScheme) {
    return GradientBackground(
      child: SingleChildScrollView(
        key: const PageStorageKey('calendarTabScroll'),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text('Timeline Harian', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const Divider(color: Colors.white54, thickness: 1.5),
            
            ..._activities.map((a) {
              final color = _getCategoryColor(a.category);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 80, child: Text(a.category, style: TextStyle(color: color, fontWeight: FontWeight.bold))),
                    Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                          Text('${a.duration.toStringAsFixed(1)} jam • ${a.isCompleted ? "Selesai" : "Pending"}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
  
  // 5. Tab Profil
  Widget _buildProfileTab(BuildContext context, ColorScheme colorScheme) {
    final totalHours = _calculateTotalHours(); // <-- Mengambil data ke variabel lokal
final totalActivities = _activities.length;
    
    Widget _buildAchievementTile({required String title, required String subtitle, required IconData icon, required Color color}) {
      return ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      );
    }
    
    Widget _buildStatBox({required String title, required String value, required Color color}) {
      return Container(
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    // Widget Edit Profil yang akan dipanggil
    Widget _buildEditProfilePage(BuildContext context, ColorScheme colorScheme) {
      return Scaffold(
        backgroundColor: const Color(0xFF9F28D5),
        appBar: AppBar(
          title: const Text('Edit Profil'),
          backgroundColor: Colors.transparent, 
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true, 
        body: GradientBackground( 
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80), 
                Text('Perbarui Informasi Akun', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Divider(color: Colors.white54),
                const SizedBox(height: 16),
                const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: 'Noviana', 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.white70), 
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white30)),
                    enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white54)),
                    focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.cyanAccent.shade400, width: 2)),
                  )
                ),
                const SizedBox(height: 24),
                const Text('Email', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: 'noviana@kampus.ac.id', 
                  keyboardType: TextInputType.emailAddress, 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70), 
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white30)),
                    enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white54)),
                    focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.cyanAccent.shade400, width: 2)),
                  )
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); 
                      ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green)
                      );
                    },
                    icon: const Icon(Icons.save, color: Colors.black87),
                    label: const Text('Simpan Perubahan', style: TextStyle(color: Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.cyanAccent.shade400, // Warna tombol
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    Widget _buildChangePasswordPage(BuildContext context, ColorScheme colorScheme) {
      return Scaffold(
        backgroundColor: const Color(0xFF9F28D5),
        appBar: AppBar(
          title: const Text('Ganti Kata Sandi'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: GradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Text('Perhatian: Masukkan kata sandi lama Anda untuk verifikasi.', style: TextStyle(color: Colors.yellowAccent)),
                const Divider(color: Colors.white54),
                const SizedBox(height: 16),
                const Text('Kata Sandi Lama', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true, 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70), 
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white30)),
                    enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white54)),
                    focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.cyanAccent.shade400, width: 2)),
                  )
                ),
                const SizedBox(height: 24),
                const Text('Kata Sandi Baru', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true, 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70), 
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white30)),
                    enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white54)),
                    focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.cyanAccent.shade400, width: 2)),
                  )
                ),
                const SizedBox(height: 24),
                const Text('Konfirmasi Kata Sandi Baru', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true, 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70), 
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white30)),
                    enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.white54)),
                    focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.cyanAccent.shade400, width: 2)),
                  )
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton.icon(
                    onPressed: () {Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi berhasil diubah!'), backgroundColor: Colors.green));}, 
                    icon: const Icon(Icons.save, color: Colors.black87), 
                    label: const Text('Ubah Kata Sandi', style: TextStyle(color: Colors.black87)), 
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.cyanAccent.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return GradientBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Foto Profil (Sama seperti desain)
            CircleAvatar(
              radius: 70, 
              backgroundColor: Colors.white70,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/novi.jpg', 
                  width: 140, // 2 * radius
                  height: 140, // 2 * radius
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback jika gambar tidak ditemukan di assets/
                    return const Icon(Icons.person, size: 70, color: Colors.deepPurple);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Noviana', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Sistem Informasi', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 30),

            // Statistik Utama (Kotak)
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // FIX: Gunakan variabel lokal totalHours (tanpa pemanggilan fungsi lagi)
    _buildStatBox(title: 'Total Jam', value: totalHours.toStringAsFixed(1), color: Colors.cyanAccent.shade400),
    _buildStatBox(title: 'Total Tugas', value: totalActivities.toString(), color: Colors.pinkAccent.shade100),
  ],
),
            const SizedBox(height: 40),

            // Pengaturan Akun di Profil
            Text('Pengaturan Akun', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const Divider(color: Colors.white38, thickness: 1),
            // Navigasi ke form Edit Profil
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white), 
              title: const Text('Edit Profil', style: TextStyle(color: Colors.white)), 
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => _buildEditProfilePage(context, colorScheme)));
              },
            ),
            // Navigasi ke form Ganti Kata Sandi
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white), 
              title: const Text('Ganti Kata Sandi', style: TextStyle(color: Colors.white)), 
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => _buildChangePasswordPage(context, colorScheme)));
              },
            ),
            
            const SizedBox(height: 40),

            // Achievement Section
            Text('Achievements', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const Divider(color: Colors.white38, thickness: 1),
            
            _buildAchievementTile(title: 'Aktif 7 Hari', subtitle: 'Mencatat aktivitas selama seminggu penuh.', icon: Icons.calendar_today_rounded, color: Colors.yellowAccent),
            _buildAchievementTile(title: 'Mencapai Target Belajar', subtitle: 'Telah menyelesaikan 10 tugas belajar.', icon: Icons.star_rate_rounded, color: Colors.orangeAccent),
            
            const SizedBox(height: 60),
            
            // Tombol Logout
            ElevatedButton.icon(
              onPressed: () { 
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Logout'),
                    content: const Text('Anda yakin ingin keluar dari aplikasi?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Ya, Logout')),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET MAIN SCREEN (BUILD METHOD) ---
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      _buildHomeTab(context, Theme.of(context).colorScheme),
      _buildStatsTab(context, Theme.of(context).colorScheme),
      _buildUpcomingTab(context, Theme.of(context).colorScheme),
      _buildCalendarTab(context, Theme.of(context).colorScheme), 
      _buildProfileTab(context, Theme.of(context).colorScheme), 
    ];
    
    final bool showFab = (_selectedIndex == 0); 
    final String currentTitle = _pageTitles[_selectedIndex];
    const Color bottomNavColor = Color(0xFF9F28D5); // Warna Ungu Magenta

    return Scaffold(
      backgroundColor: bottomNavColor, 
      appBar: AppBar(
        centerTitle: true, 
        title: Text(currentTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.transparent, 
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.info_outline_rounded, size: 28), onPressed: () {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda berada di halaman: $currentTitle')));}),
          const SizedBox(width: 8),
        ],
      ),
      extendBodyBehindAppBar: true, 
      
      body: Padding(
        padding: const EdgeInsets.only(bottom: 5.0), 
        child: widgetOptions.elementAt(_selectedIndex),
      ),

      floatingActionButton: showFab ? FloatingActionButton.extended(
        onPressed: _navigateToAddActivity,
        backgroundColor: Colors.cyanAccent.shade400, 
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Tambah Aktivitas'),
        elevation: 6.0, 
      ) : null,
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      
      // Bottom Navigation Bar standar (5 Item)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 24, 
        backgroundColor: bottomNavColor, 
        elevation: 0, 
        
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'), 
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined), label: 'Terdekat'), 
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Kalender'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'), 
        ],
        
        currentIndex: _selectedIndex, 
        onTap: (index) {
          setState(() {
              _selectedIndex = index;
          });
        },
      ),
    );
  }
}