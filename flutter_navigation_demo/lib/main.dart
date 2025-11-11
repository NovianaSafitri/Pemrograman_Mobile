import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'detail_screen.dart'; 
import 'bottom_nav_screen.dart'; 
import 'replacement_screen.dart'; 

void main() {
  runApp(const FlutterNavigationDemo());
}

class FlutterNavigationDemo extends StatelessWidget {
  const FlutterNavigationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 5 Metode Navigasi Ocean Demo',
      // FIX: Tambahkan properti ini untuk menghilangkan banner
      debugShowCheckedModeBanner: false, 
      
      theme: ThemeData(
        colorSchemeSeed: Colors.blue, 
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, 
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
     
      // Definisikan 5 Route Utama
      initialRoute: '/', 
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(data: 'Data Default dari Named Route'), 
        '/bottom_nav': (context) => const BottomNavScreen(),
        '/replacement': (context) => const ReplacementScreen(), 
      },

      // Menangani Named Route yang membawa data
      onGenerateRoute: (settings) {
        if (settings.name == '/named_data') {
          final data = settings.arguments as String?;
          
          return MaterialPageRoute(
            builder: (context) => DetailScreen(
              data: data ?? 'Data Default dari Named Route Gagal',
            ),
          );
        }
        return null; 
      },
    );
  }
}