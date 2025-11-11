import 'package:flutter/material.dart';
import 'page_one.dart';
import 'page_two.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const PageOne(),
    const PageTwo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Penting untuk melihat gradien
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Halaman Multi-Tab: Coral' : 'Halaman Multi-Tab: Gold',
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      
      // Animasi dan Warna Kontras untuk Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Gradien Ungu/Pink Kontras untuk Bar
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade700,
              Colors.pink.shade400,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(0x80),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Properti harus transparan agar gradien Container terlihat
          backgroundColor: Colors.transparent,
          elevation: 0, 
          selectedItemColor: Colors.yellowAccent, // Warna terang
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed, // Tetap terlihat
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_one),
              label: 'Coral Coast',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_two),
              label: 'Golden Jewel',
            ),
          ],
        ),
      ),
    );
  }
}