// lib/screens/dummy_stats_page.dart

import 'package:flutter/material.dart';

class DummyStatsPage extends StatelessWidget {
  const DummyStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer, 
      appBar: AppBar(title: const Text('Statistik Progres'), automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual Header dengan Gradient dan Border Radius (Menarik)
              Container(
                width: 160, height: 160, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35), 
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.secondary.withAlpha(0x6)], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.secondary.withAlpha(0x3), blurRadius: 30, offset: const Offset(0, 15)),],
                ),
                child: Icon(Icons.show_chart_rounded, size: 90, color: Theme.of(context).colorScheme.onSecondary),
              ),
              const SizedBox(height: 40),
              
              Text('Analisis Kinerja Anda!', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface, letterSpacing: -0.2)),
              const SizedBox(height: 15),
              Card(
                elevation: 5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Grafik interaktif (Pie dan Bar) untuk melihat durasi dan fokus per kategori sedang disiapkan.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade800, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text('Data Anda akan diolah untuk memberikan wawasan mendalam tentang produktivitas Anda. Kumpulkan lebih banyak aktivitas untuk melihatnya beraksi!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text('Fitur Premium: Segera Hadir!', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}