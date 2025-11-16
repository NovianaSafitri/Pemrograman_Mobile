// lib/screens/home_page.dart (Menggabungkan Home dan Stats menjadi TabBar)

import 'package:flutter/material.dart';
import '../model/activity_model.dart';
import 'add_activity_page.dart';
import 'activity_detail_page.dart';

// --- Helper Functions untuk Statistik (Dipindahkan dari StatsPage) ---

double _calculateTotalHours(List<ActivityModel> activities) {
  return activities.fold(0.0, (sum, activity) => sum + activity.duration);
}

int _calculateCompletedCount(List<ActivityModel> activities) {
  return activities.where((a) => a.isCompleted).length;
}

Map<String, int> _calculateCategoryDistribution(List<ActivityModel> activities) {
  Map<String, int> distribution = {};
  for (var activity in activities) {
    distribution[activity.category] = (distribution[activity.category] ?? 0) + 1;
  }
  return distribution;
}

// Helper untuk mendapatkan ikon kategori
IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'Belajar':
      return Icons.menu_book_rounded;
    case 'Ibadah':
      return Icons.mosque_rounded;
    case 'Olahraga':
      return Icons.directions_run_rounded;
    case 'Hiburan':
      return Icons.palette_rounded;
    default:
      return Icons.folder_open_rounded;
  }
}
// --------------------------------------------------------------------


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ActivityModel> _activities = [
    ActivityModel(name: 'Belajar Flutter Dasar', category: 'Belajar', duration: 3.0, isCompleted: true),
    ActivityModel(name: 'Lari Pagi', category: 'Olahraga', duration: 1.0, isCompleted: true),
    ActivityModel(name: 'Membaca Al-Quran', category: 'Ibadah', duration: 0.5, isCompleted: false, notes: 'Target 1 juz'),
    ActivityModel(name: 'Nonton Film Dokumenter', category: 'Hiburan', duration: 2.0, isCompleted: false),
  ];

  void _navigateToAddActivity() async {
    final newActivity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage()),
    );

    if (newActivity != null && newActivity is ActivityModel) {
      // Kriteria UTS: setState()
      setState(() {
        _activities.add(newActivity);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aktivitas "${newActivity.name}" berhasil ditambahkan!'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    }
  }

  void _toggleCompletion(ActivityModel activity) {
    setState(() {
      activity.isCompleted = !activity.isCompleted;
    });
    // Feedback SnackBar di sini atau di DetailPage
  }

  void _deleteActivity(ActivityModel activity) {
    setState(() {
      _activities.remove(activity);
    });
  }
  
  // --- Widget Build Tab Aktivitas Harian ---
  Widget _buildActivityList(BuildContext context, ColorScheme colorScheme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _activities.isEmpty
          ? Center(
              key: const ValueKey('empty'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_outlined, size: 90, color: colorScheme.primary.withAlpha(0x4)),
                  const SizedBox(height: 16),
                  Text('Ayo catat aktivitas pertamamu!', style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
                ],
              ),
            )
          : ListView.builder(
              key: const ValueKey('list'),
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityDetailPage(
                            activity: activity,
                            onDelete: _deleteActivity,
                            onToggleCompletion: _toggleCompletion,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: activity.isCompleted
                            ? Colors.green.shade50.withAlpha(0x8)
                            : colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withAlpha(activity.isCompleted ? 0x2 : 0x1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: activity.isCompleted ? Colors.green.shade400 : Colors.transparent,
                          width: 1.5,
                        )
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: activity.isCompleted ? Colors.green.shade600 : colorScheme.primary,
                          child: Icon(
                            _getCategoryIcon(activity.category),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          activity.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            decoration: activity.isCompleted ? TextDecoration.lineThrough : null,
                            color: activity.isCompleted ? Colors.grey.shade600 : colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          '${activity.category} • ${activity.duration.toStringAsFixed(1)} jam',
                          style: TextStyle(
                            color: activity.isCompleted ? Colors.green.shade600 : Colors.grey.shade600,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            activity.isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                            color: activity.isCompleted ? Colors.green.shade600 : colorScheme.secondary,
                            size: 30,
                          ),
                          onPressed: () => _toggleCompletion(activity),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // --- Widget Build Tab Statistik & Analisis ---
  Widget _buildStatsView(BuildContext context, ColorScheme colorScheme) {
    if (_activities.isEmpty) {
      return Center(
        child: Text('Tambah aktivitas untuk melihat statistik.', style: TextStyle(color: Colors.grey.shade700)),
      );
    }
    
    final totalHours = _calculateTotalHours(_activities);
    final completedCount = _calculateCompletedCount(_activities);
    final totalActivities = _activities.length;
    final categoryDistribution = _calculateCategoryDistribution(_activities);

    // Widget untuk membuat kartu statistik utama yang menarik
    Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: color.withAlpha(0x1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: color),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    // Widget untuk menampilkan progress bar kategori
    Widget _buildCategoryProgress({required String category, required int count, required int total, required Color color}) {
      final percentage = total > 0 ? count / total : 0.0;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$category ($count)', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${(percentage * 100).toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. Kartu Ringkasan Utama (Grid) ---
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                title: 'Total Jam',
                value: totalHours.toStringAsFixed(1),
                icon: Icons.av_timer_rounded,
                color: colorScheme.secondary,
              ),
              _buildStatCard(
                title: 'Aktivitas Selesai',
                value: completedCount.toString(),
                icon: Icons.check_circle_rounded,
                color: Colors.green.shade600,
              ),
              _buildStatCard(
                title: 'Total Tugas',
                value: totalActivities.toString(),
                icon: Icons.list_alt_rounded,
                color: colorScheme.primary,
              ),
              _buildStatCard(
                title: 'Persentase Selesai',
                value: totalActivities > 0 
                    ? '${((completedCount / totalActivities) * 100).toStringAsFixed(0)}%'
                    : '0%',
                icon: Icons.pie_chart_rounded,
                color: Colors.orange.shade600,
              ),
            ],
          ),
          
          const SizedBox(height: 35),
          
          // --- 2. Distribusi Kategori (Progress Bars) ---
          Text(
            'Distribusi Kategori',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const Divider(thickness: 2, height: 20),
          
          ...categoryDistribution.entries.map((entry) {
            Color categoryColor;
            switch (entry.key) {
              case 'Belajar':
                categoryColor = Colors.blue.shade700;
                break;
              case 'Ibadah':
                categoryColor = Colors.purple.shade600;
                break;
              case 'Olahraga':
                categoryColor = Colors.red.shade600;
                break;
              case 'Hiburan':
                categoryColor = Colors.teal.shade500;
                break;
              default:
                categoryColor = Colors.grey.shade500;
            }
            return _buildCategoryProgress(
              category: entry.key,
              count: entry.value,
              total: totalActivities,
              color: categoryColor,
            );
          }),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2, // Dua tab: Aktivitas dan Statistik
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Activity Tracker', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: colorScheme.secondaryContainer,
            labelColor: colorScheme.onPrimary,
            unselectedLabelColor: colorScheme.onPrimary.withAlpha(0x7),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(icon: Icon(Icons.list_alt_rounded), text: 'Aktivitas'),
              Tab(icon: Icon(Icons.analytics_rounded), text: 'Statistik'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Aktivitas Harian
            _buildActivityList(context, colorScheme),
            
            // Tab 2: Statistik & Analisis
            _buildStatsView(context, colorScheme),
          ],
        ),

        // Tombol Tambah Aktivitas Baru (Hanya di tampilan Aktivitas)
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _navigateToAddActivity,
          icon: const Icon(Icons.add_task_rounded),
          label: const Text('Tambah Aktivitas Baru', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          elevation: 10,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}