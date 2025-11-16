// lib/screens/stats_page.dart
import 'package:flutter/material.dart';
import '../model/activity_model.dart';

class StatsPage extends StatelessWidget {
  final List<ActivityModel> activities;

  const StatsPage({super.key, required this.activities});

  double _calculateTotalHours() {
    return activities.fold(0.0, (sum, activity) => sum + activity.duration);
  }

  int _calculateCompletedCount() {
    return activities.where((a) => a.isCompleted).length;
  }

  Map<String, int> _calculateCategoryDistribution() {
    Map<String, int> distribution = {};
    for (var activity in activities) {
      distribution[activity.category] = (distribution[activity.category] ?? 0) + 1;
    }
    return distribution;
  }
  
  // Widget untuk membuat kartu statistik utama yang menarik
  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
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
  Widget _buildCategoryProgress(BuildContext context, {required String category, required int count, required int total, required Color color}) {
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

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(child: Text('Tidak ada data aktivitas untuk ditampilkan.'));
    }

    final totalHours = _calculateTotalHours();
    final completedCount = _calculateCompletedCount();
    final totalActivities = activities.length;
    final categoryDistribution = _calculateCategoryDistribution();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Aktivitas', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
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
                  context,
                  title: 'Total Jam',
                  value: totalHours.toStringAsFixed(1),
                  icon: Icons.av_timer_rounded,
                  color: colorScheme.secondary,
                ),
                _buildStatCard(
                  context,
                  title: 'Aktivitas Selesai',
                  value: completedCount.toString(),
                  icon: Icons.check_circle_rounded,
                  color: Colors.green.shade600,
                ),
                _buildStatCard(
                  context,
                  title: 'Total Tugas',
                  value: totalActivities.toString(),
                  icon: Icons.list_alt_rounded,
                  color: colorScheme.primary,
                ),
                _buildStatCard(
                  context,
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
                context,
                category: entry.key,
                count: entry.value,
                total: totalActivities,
                color: categoryColor,
              );
            }),
            
            const SizedBox(height: 20),
            
            // Tombol Kembali
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Kembali ke Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}